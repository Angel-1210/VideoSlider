//
//  PickStoryVC.swift
//  VideoSlider
//
//  Created by Dharmesh on 11/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation
import MobileCoreServices

class PickStoryVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    @IBAction func btnGalleryTapped(sender: UIButton) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        pickerController.allowsEditing = true
        pickerController.videoMaximumDuration = 15
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)!
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnCameraTapped(sender: UIButton) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        pickerController.allowsEditing = true
        pickerController.videoMaximumDuration = 15
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
        presentViewController(pickerController, animated: true, completion: nil)        
    }
    
    //------------------------------------------------------
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType: NSString = (info[UIImagePickerControllerMediaType] as! NSString)
        
        if mediaType.isEqualToString(kUTTypeMovie as NSString as String) {
           
            let videoUrl: NSURL = ((info[UIImagePickerControllerMediaURL] as! NSURL) )
           
            let moviePath: String = videoUrl.path!
          
            let outputFileUrl = NSURL(fileURLWithPath: moviePath)
            
            do {
             
                let asset = AVURLAsset(URL: outputFileUrl, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                //let cgImage = imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
                let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                
                // !! check the error before proceeding
                let uiImage = UIImage(CGImage: cgImage)
                
                debugPrint("Image : \(uiImage)")
                
            } catch (let error) {
                
                debugPrint(error)
            }
            
            /*if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil)
            }*/
        }
        
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
