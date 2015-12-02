//
//  ViewController.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 09/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController {
    

    
    @IBOutlet weak var patienNameLabel: UILabel!
    @IBOutlet weak var LeftResult1: UILabel!
    @IBOutlet weak var LeftResult2: UILabel!
    @IBOutlet weak var LeftResult3: UILabel!
    @IBOutlet weak var LeftResult4: UILabel!
    
 
    @IBOutlet weak var RightResult1: UILabel!
    @IBOutlet weak var RightResult2: UILabel!
    @IBOutlet weak var RightResult3: UILabel!
    @IBOutlet weak var RightResult4: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patienNameLabel.text = Test.getFullName()
        
        LeftResult1.text = Test.resultLeft[0].description
        LeftResult2.text = Test.resultLeft[1].description
        LeftResult3.text = Test.resultLeft[2].description
        LeftResult4.text = Test.resultLeft[3].description
        
        RightResult1.text = Test.resultRight[0].description
        RightResult1.text = Test.resultRight[1].description
        RightResult1.text = Test.resultRight[2].description
        RightResult1.text = Test.resultRight[3].description
        
        // Do any additional setup after loading the view, typically from a nib.
        //WORKING
        /*let instrument = AKInstrument()
        instrument.setAudioOutput(AKOscillator())
        AKOrchestra.addInstrument(instrument)
        instrument.play()*/
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

