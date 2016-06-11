//
//  CameraVC.swift
//  VideoSlider
//
//  Created by Dharmesh on 11/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation

class CameraVC : UIViewController {
    
    @IBOutlet weak var btnCamera: RecordButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnFrontRear: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    var camera : LLSimpleCamera!
    var progressTimer : NSTimer!
    var progress : CGFloat! = 0
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Methods
    
    func applicationDocumentsDirectory() -> NSURL {
        
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    func record() {
        
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func updateProgress() {
        
        let maxDuration = CGFloat(15)
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        btnCamera.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
            progress = 0.0
            btnCamera.setProgress(progress)
        }
        
    }
    
    func stop() {
        
        self.progressTimer.invalidate()
        progress = 0.0
        btnCamera.setProgress(progress)
    }
    
    //------------------------------------------------------
    
    //MARK: Camera
    
    @IBAction func btnFrontRearTapped(sender: UIButton) {
        camera.togglePosition()
    }
    
    @IBAction func btnFlashTapped(sender: UIButton) {
        
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.btnFlash.selected = true
                self.btnFlash.tintColor = UIColor.yellowColor()
            }
        }
        else {
            
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.btnFlash.selected = false
                self.btnFlash.tintColor = UIColor.whiteColor()
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UILongPressGestureRecognizer
    
    @IBAction func handleSingleTap(sender: UIButton) {
        
        self.camera.capture({(camera: LLSimpleCamera!, image: UIImage!, metadata: [NSObject : AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                debugPrint("Image : \(image)")
            }
            }, exactSeenImage: true)

    }
    
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .Began {
            
            if !self.camera.recording {
                
                let outputURL = applicationDocumentsDirectory().URLByAppendingPathComponent("Video").URLByAppendingPathExtension("mov")
                debugPrint(outputURL)
                
                camera.startRecordingWithOutputUrl(outputURL, didRecord: { (camera : LLSimpleCamera!, outputFileUrl : NSURL!, error : NSError!) in
                    
                    debugPrint("Video : \(outputFileUrl)")
                   
                    do {
                        
                        let asset = AVURLAsset(URL: outputFileUrl, options: nil)
                        let imgGenerator = AVAssetImageGenerator(asset: asset)
                        //let cgImage = imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
                        let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                        
                        // !! check the error before proceeding
                        let uiImage = UIImage(CGImage: cgImage)
                        
                        debugPrint("Image : \(uiImage)")
                        
                    } catch ( let error ){
                        
                        debugPrint(error)
                    }
                })
            }
            
        } else if (sender.state == .Ended) {

            self.progressTimer.invalidate()
            self.progress = 0.0
            self.btnCamera.setProgress(self.progress)
            self.btnCamera.didTouchUp()
            camera.stopRecording()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCamera.closeWhenFinished = false
        btnCamera.progressColor = .redColor()
        btnCamera.addTarget(self, action: #selector(CameraVC.record), forControlEvents: .TouchDown)
        btnCamera.addTarget(self, action: #selector(CameraVC.stop), forControlEvents: UIControlEvents.TouchUpInside)
        longPress.minimumPressDuration = 2
        
        camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        //camera .attachToViewController(self, withFrame: view.bounds)
        camera.view.frame = view.bounds
        self.view .insertSubview(camera.view, atIndex: 0)
        camera.fixOrientationAfterCapture = false
        
        weak var weakSelf = self
        self.camera.onDeviceChange = {(camera: LLSimpleCamera!, device: AVCaptureDevice!) -> Void in
            
            // device changed, check if flash is available
            if camera!.isFlashAvailable() {
                weakSelf?.btnFlash.hidden = false
                
                if camera.flash == LLCameraFlashOff {
                    weakSelf!.btnFlash.selected = false
                }
                else {
                    weakSelf!.btnFlash.selected = true
                }
            }
            else {
                weakSelf!.btnFlash.hidden = true
            }
        }
     
        self.camera.onError = {(camera: LLSimpleCamera!, error: NSError!) -> Void in
            
            if (error.domain == LLSimpleCameraErrorDomain) {
                
                if error.code == Int(LLSimpleCameraErrorCodeCameraPermission.rawValue) || error.code == Int(LLSimpleCameraErrorCodeMicrophonePermission.rawValue) {
                    debugPrint("Camera not supported")
                }
            }
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        camera.start()        
    }
    
    //------------------------------------------------------
}
