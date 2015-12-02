//
//  ViewController.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 09/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//

import UIKit
import AVKit


class PlaySoundViewController: UIViewController {

    @IBAction func PlaySoundButton(sender: AnyObject) {
        Test.playTestSound()
        performSegueWithIdentifier("SegueHearSound", sender: nil)
    }
    
    @IBAction func Info(sender: AnyObject) {
        do {
            try playVideo()
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func playVideo() throws {
        guard let path = NSBundle.mainBundle().pathForResource("Instruction_Video", ofType:"mp4") else {
            throw AppError.InvalidResource("video", "m4v")
        }
        let item = AVPlayerItem(URL: NSURL(fileURLWithPath: path))
        let player = AVPlayer(playerItem: item)
        let playerController = AVPlayerViewController()
        playerController.player = player
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
        self.presentViewController(playerController, animated: true) {
        }
        player.play()
    }
    func playerDidFinishPlaying(note: NSNotification) {
        self.dismissViewControllerAnimated(true,completion: {})
    }
    
    
    
}

