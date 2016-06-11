//
//  ViewController.swift
//  VideoSlider
//
//  Created by Dharmesh on 11/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit

class ViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, AVAssetResourceLoaderDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data : NSArray!
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView,   numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCell", forIndexPath: indexPath) as! PlayerCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen .mainScreen().scale
        
        var post = data[indexPath.row] as! String
        post = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        cell.setupPlayerItem(post, indexPath: indexPath)
        
        return cell
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //let cell = collectionView.visibleCells().first as! PlayerCell
        //let indexPath = collectionView.indexPathForCell(cell)
        //cell.playerLayer.player?.play()
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stringURL = "http://download.wavetlan.com/SVV/Media/HTTP/H264/Talkinghead_Media/H264_test2_Talkinghead_mp4_480x320.mp4"
        data = [ stringURL, stringURL, stringURL, stringURL, stringURL, stringURL, stringURL]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

