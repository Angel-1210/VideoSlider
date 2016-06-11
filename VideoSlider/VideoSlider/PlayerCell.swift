//
//  PlayerCell.swift
//  VideoSlider
//
//  Created by Dharmesh on 11/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlayerCell : UICollectionViewCell, AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var playerLayer : AVPlayerLayer!
    var player : AVPlayer!
    var persistentTime : CMTime!
    var connection : NSURLConnection!
    var currentIndexPath : NSIndexPath!
    
    var cacheData : NSMutableData!
    
    //MARK: Memory Management Method

    deinit { //same like dealloc in ObjectiveC
       player.removeObserver(self, forKeyPath: "status")
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func prepareForReuse() {
        //player.replaceCurrentItemWithPlayerItem(nil)
        playerLayer.removeFromSuperlayer()
        player.removeObserver(self, forKeyPath: "status")
    }
    
    override func awakeFromNib() {
        
    }
    
    func setupPlayerItem( strURL : String, indexPath : NSIndexPath ) {
        
        self.indicator.startAnimating()
        currentIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        
        let url = NSURL(string: strURL)
        
        guard (url == nil) else {
            
            //let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["status"])
            let asset = AVURLAsset(URL: url!)
            asset.resourceLoader .setDelegate(self, queue: dispatch_get_main_queue())
            
            let playerItem = AVPlayerItem(asset:asset)
            
            //let playerItem = AVPlayerItem(URL:url!)
            player = AVPlayer(playerItem: playerItem)
            let options = NSKeyValueObservingOptions()
            player.addObserver(self, forKeyPath: "status", options: options, context: nil)
            
            persistentTime = player.currentTime()
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = UIScreen.mainScreen().bounds
            playerView.layer.addSublayer(playerLayer)                                   
            
            guard persistentTime == nil else {
                player.seekToTime(persistentTime)
                return
            }
            return
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let player = object as! AVPlayer
                
        if keyPath! == "status" {
            
            if player.status == AVPlayerStatus.ReadyToPlay {
                self.indicator.stopAnimating()
                player.play()
            } else {
                self.indicator.startAnimating()
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: AVAssetResourceLoaderDelegate
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        if connection == nil {
            
            let interceptedURL = loadingRequest.request.URL
            let component = NSURLComponents(URL: interceptedURL!, resolvingAgainstBaseURL: true)
            component?.scheme = "http"
            
            let request = NSURLRequest(URL: (component?.URL)!)
            connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            connection.setDelegateQueue(NSOperationQueue.mainQueue())
            connection .start()
            
        }
        
        return true
    }
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, didCancelLoadingRequest loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
        
    //------------------------------------------------------
    
    //MARK: NSURLConnectionDelegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        cacheData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        cacheData .appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        let fileName = String(currentIndexPath.section).stringByAppendingString(String(currentIndexPath.row)).stringByAppendingString(".MP4")
        let cacheFilePath = NSTemporaryDirectory().stringByAppendingString(fileName)
        
        debugPrint(fileName)
        
        cacheData.writeToFile(cacheFilePath, atomically: true)
    }
}
