//
//  HoldButtonViewController.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 09/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//
import AVFoundation
import AVKit

var firstAppear = true


class HoldButtonViewController: UIViewController  {
   
    @IBAction func PressedHoldButton(sender: AnyObject) {
        //Start playing sound
        Test.findStartAmpStart()
        
    }
    
    @IBAction func ReleasedHoldButtonInside(sender: AnyObject) {
        
        Test.findStartAmpStop() //stop sound
        performSegueWithIdentifier("SegueToHearSound", sender: nil) //change view
        
    }

    @IBAction func ReleasedHoldButtonOutside(sender: AnyObject) {
        //change view
    }
    
    

    @IBAction func Info(sender: AnyObject) {
           do {
            try playVideo()
            firstAppear = false
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            do {
                try playVideo()
                firstAppear = false
            } catch AppError.InvalidResource(let name, let type) {
                debugPrint("Could not find resource \(name).\(type)")
            } catch {
                debugPrint("Generic error")
            }
        }
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

enum AppError : ErrorType {
    case InvalidResource(String, String)
}