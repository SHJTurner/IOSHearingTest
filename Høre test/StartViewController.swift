//
//  ViewController.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 09/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//

import UIKit

var Test = HearingTestModel(firstName: "dum",lastName: "dummy")

class StartViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TextFieldFirstName: UITextField!
    @IBOutlet weak var TextFieldLastName: UITextField!
    @IBOutlet weak var ButtonStartTest: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the first apper for the video to false (new test person should see the video)
        //firstAppear = true
        self.TextFieldFirstName.delegate = self
        self.TextFieldLastName.delegate = self
        ButtonStartTest.enabled = false
        firstAppear = true
        TextFieldLastName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        TextFieldFirstName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
    func textFieldDidChange(textField: UITextField) {
        if (TextFieldFirstName.text?.characters.count > 0 && TextFieldLastName.text?.characters.count > 0)
        { ButtonStartTest.enabled = true
            Test = HearingTestModel(firstName: TextFieldFirstName.text!, lastName: TextFieldLastName.text!)
        }
        else
        { ButtonStartTest.enabled = false }
    }
}

