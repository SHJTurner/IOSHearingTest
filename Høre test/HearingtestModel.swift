//
//  HearingtestModel.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 20/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//

import Foundation



class HearingTestModel:NSObject {
    
    enum PropertyKeys {
        static let firstRun = "FirstRun"
        static let FirstName = "FName"
        static let LastName = "LName"
        static let ResultL1 = "LFreq200"
        static let ResultL2 = "LFreq500"
        static let ResultL3 = "LFreq1000"
        static let ResultL4 = "LFreq2000"
        static let ResultL5 = "LFreq4000"
        static let ResultR1 = "RFreq200"
        static let ResultR2 = "RFreq500"
        static let ResultR3 = "RFreq1000"
        static let ResultR4 = "RFreq2000"
        static let ResultR5 = "RFreq4000"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let toneplayer = TonePlayer()
    let InitialStepDown: Float = 0.0001
    let StepUpInit : Float = 0.001
    let StepUp: Float = 0.001
    let StepDown: Float = 0.005
    let tones: [Float] = [200.0,500.0,1000.0,2000.0,4000.0]
    
    var FirstName: String = ""
    var LastName: String = ""
    var currentTestFreqIndex = 0
    
    var currentTestAmpL: Float = 0.0
    var currentTestAmpR: Float = 0.0
    var crossedThresHoldCounterL: Int = 0
    var crossedThresHoldCounterR: Int = 0
    var crossedThresHoldValueL: [Float] = [-1,-1,-1]
    var crossedThresHoldValueR: [Float] = [-1,-1,-1]
    var resultLeft: [Float] = [-1,-1,-1,-1,-1]
    var resultRight: [Float] = [-1,-1,-1,-1,-1]
    
    var timer = NSTimer()
    var testSoundTimer = NSTimer()
    
    var foundStartAmpForCurrentFreq = false
    var testingLeftside = true
    var lastTestedEar = ""
    
    
    init(firstName: String, lastName: String){
       FirstName = firstName
       LastName = lastName
       super.init()
    }
    
    func checkForData(){
        if(defaults.boolForKey(PropertyKeys.firstRun)){
            defaults.setValue("Dummy", forKey: PropertyKeys.FirstName)
            defaults.setValue("Name", forKey: PropertyKeys.LastName)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultL1)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultL2)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultL3)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultL4)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultL5)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultR1)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultR2)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultR3)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultR4)
            defaults.setValue(0.0, forKey: PropertyKeys.ResultR5)
        }
        
    }
    
    func save(){
        defaults.setValue(FirstName, forKey: PropertyKeys.FirstName)
        defaults.setValue(LastName, forKey: PropertyKeys.LastName)
        defaults.setValue(resultLeft[0], forKey: PropertyKeys.ResultL1)
        defaults.setValue(resultLeft[1], forKey: PropertyKeys.ResultL2)
        defaults.setValue(resultLeft[2], forKey: PropertyKeys.ResultL3)
        defaults.setValue(resultLeft[3], forKey: PropertyKeys.ResultL4)
        defaults.setValue(resultLeft[4], forKey: PropertyKeys.ResultL5)
        defaults.setValue(resultRight[0], forKey: PropertyKeys.ResultR1)
        defaults.setValue(resultRight[1], forKey: PropertyKeys.ResultR2)
        defaults.setValue(resultRight[2], forKey: PropertyKeys.ResultR3)
        defaults.setValue(resultRight[3], forKey: PropertyKeys.ResultR4)
        defaults.setValue(resultRight[4], forKey: PropertyKeys.ResultR5)
    }
    
    func load(){
        checkForData()
        FirstName = defaults.stringForKey(PropertyKeys.FirstName)!
        LastName = defaults.stringForKey(PropertyKeys.LastName)!
        resultLeft[0] = defaults.floatForKey(PropertyKeys.ResultL1)
        resultLeft[1] = defaults.floatForKey(PropertyKeys.ResultL2)
        resultLeft[2] = defaults.floatForKey(PropertyKeys.ResultL3)
        resultLeft[3] = defaults.floatForKey(PropertyKeys.ResultL4)
        resultLeft[4] = defaults.floatForKey(PropertyKeys.ResultL5)
        resultRight[0] = defaults.floatForKey(PropertyKeys.ResultR1)
        resultRight[1] = defaults.floatForKey(PropertyKeys.ResultR2)
        resultRight[2] = defaults.floatForKey(PropertyKeys.ResultR3)
        resultRight[3] = defaults.floatForKey(PropertyKeys.ResultR4)
        resultRight[4] = defaults.floatForKey(PropertyKeys.ResultR5)
    }
    
    func getFirstName()->String{ return FirstName }
    func getLastName()->String{ return LastName }
    func getFullName()->String{ return FirstName + " " + LastName }

    
    //stats playing a sound at 0.0 volume and slowly increses the volume until it hits 1.0
    func findStartAmpStart(){
        //init currentTestAmp
        if(testingLeftside){
            currentTestAmpL = StepUp
        }
        if(!testingLeftside){
            currentTestAmpR = StepUp
        }
        toneplayer.playSound(0.0, freq: tones[currentTestFreqIndex], left: testingLeftside) //start sound
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target:self, selector: Selector("timerAmpUp"), userInfo: nil, repeats: true) //start timer (run timerAmpUp perodicaly)
    }
    
    //timer function (slowly incesing the volume while the butten is pressed
    func timerAmpUp() {
        if(currentTestAmpL > 0.999 && testingLeftside){//left //dont go above 100
            timer.invalidate() //stop timer
            findStartAmpStop()
        }
        else if(currentTestAmpR > 0.999 && !testingLeftside){//right
            timer.invalidate()
            findStartAmpStop()
        }
        else if(testingLeftside){//left //increse the volume
            currentTestAmpL = currentTestAmpL + StepUpInit
            toneplayer.playSound(currentTestAmpL, freq: tones[currentTestFreqIndex], left: testingLeftside)
        }
        else if(!testingLeftside){//right
            currentTestAmpR = currentTestAmpR + StepUpInit
            toneplayer.playSound(currentTestAmpR, freq: tones[currentTestFreqIndex], left: testingLeftside)
        }
    }
    
    func findStartAmpStop(){
        timer.invalidate() //stop timer and sound
        toneplayer.stopSound()
        if(testingLeftside){ //if we are testing left ear
            currentTestAmpL = currentTestAmpL - InitialStepDown //go a step down before going to step tests
            if(currentTestAmpL < 0){ currentTestAmpL = 0.0 } //if testamp is below 0, then set it to 0
            lastTestedEar = "Left"
        }
        else{ //right ear
            currentTestAmpL = currentTestAmpL - InitialStepDown
            if(currentTestAmpL < 0){ currentTestAmpL = 0.0 }
            lastTestedEar = "Right"
        }
    }
    
    
    
    
    func HearSoundGetNextSegue(answer: String) ->String{
            if(!foundStartAmpForCurrentFreq){ //finding init values
                    switch answer {
                        case "Left":
                            if(lastTestedEar == "Left") { // Left side is done...
                                testingLeftside = false
                                return "HoldButton"
                            }
                            else { //something went worng, run the holdButton test again
                                return "HoldButton"
                            }
                        case "Right":
                            if(lastTestedEar == "Right") { //we are good both left and right init values has been found
                                foundStartAmpForCurrentFreq = true;
                                return "Playsound"
                            }
                            else { //repeat HoldButton test
                                return "HoldButton"
                            }
                        case "No":
                            return "HoldButton" //Run the holdButton Test again
                        default:
                            return "ERROR!"
                    }
            }
        else{//finding values
                return testSpecificAmp(answer)
        }
    }
    
    
    
    func testSpecificAmp(answer:String)->String{
        switch answer {
        case "Left":
            if(lastTestedEar == "Left") { //correct
                let ret = correctAnswer()
                if(ret == 1){ //returns true of the test for current freq is done
                    return "HoldButton"
                }
                else if(ret == 2){ //returns true of the test for current freq is done
                    return "TestComplete"
                }

                else{ //step down.. we want to cross the threshold again
                    currentTestAmpL = stepDown(currentTestAmpL)
                    return "Playsound"
                }
            }
            else { //wrong ear, incese volume
                currentTestAmpL = currentTestAmpL + StepUp
                return "Playsound"
            }
            
        case "Right":
            if(lastTestedEar == "Right") {
                let ret = correctAnswer()
                if(ret == 1){ //returns true of the test for current freq is done
                    return "HoldButton"
                }
                else if(ret == 2){ //returns true of the test for current freq is done
                    return "TestComplete"
                }
                else{
                    currentTestAmpR = stepDown(currentTestAmpR)
                    return "Playsound"
                }
            }
            else {
                currentTestAmpR = currentTestAmpR + StepUp
                return "Playsound"
            }
            
        case "No": //incese volume
            if(lastTestedEar == "Left") {
                currentTestAmpL = currentTestAmpL + StepUp
            }
            else {
                currentTestAmpR = currentTestAmpR + StepUp
            }
            return "Playsound"
            
        default:
            return "ERROR!"
        }
    }
    
    func stepDown(val:Float)->Float{
        var tmp = val - StepDown
        if(tmp < 0){tmp = 0.0}
        return tmp
    }
    
    //returns true if currentFreq thresholds have been found
    func correctAnswer()->Int{
        if(lastTestedEar == "Left"){
            crossedThresHoldValueL[crossedThresHoldCounterL] = currentTestAmpL //save threadhold
            crossedThresHoldCounterL++
            if(crossedThresHoldValueL.capacity == crossedThresHoldCounterL){
                var tmp: Float = 0
                for val in crossedThresHoldValueL {
                    tmp += val
                }
                tmp = tmp / Float(crossedThresHoldValueL.capacity)
                resultLeft[currentTestFreqIndex] = tmp
                crossedThresHoldCounterL = 0
            }
            
        }
        else{
            crossedThresHoldValueR[crossedThresHoldCounterR] = currentTestAmpR //save threadhold
            crossedThresHoldCounterR++
            if(crossedThresHoldValueR.capacity == crossedThresHoldCounterR){
                var tmp: Float = 0
                for val in crossedThresHoldValueR {
                    tmp += val
                }
                tmp = tmp / Float(crossedThresHoldValueR.capacity)
                resultRight[currentTestFreqIndex] = tmp
                crossedThresHoldCounterR = 0
            }
            
        }
        
        if(resultRight[currentTestFreqIndex] > 0.0 && resultLeft[currentTestFreqIndex] >        0.0){
            currentTestFreqIndex++
            
                if(currentTestFreqIndex == tones.capacity){ //test complete
                return 2
                }
            foundStartAmpForCurrentFreq = false
            return 1
        }
        else { return 0 }
        
    }
    
    //pick a random ear and play the next test sound
    func playTestSound(){
        let rand = Int(arc4random_uniform(2))
        if(resultLeft[currentTestFreqIndex] > 0) //if result for left ear is found, then pick the right
        { testingLeftside = false }
        else if(resultRight[currentTestFreqIndex] > 0) //if result for right ear is found, then pick the left
        { testingLeftside = true }
        else if(rand == 1){ testingLeftside = true } //pick a random ear
        else{ testingLeftside = false }
        
        if(testingLeftside){ //play the sound
            toneplayer.playSound(currentTestAmpL, freq: tones[currentTestFreqIndex], left: testingLeftside)
            lastTestedEar = "Left"
        }
        else{
            toneplayer.playSound(currentTestAmpR, freq: tones[currentTestFreqIndex], left: testingLeftside)
            lastTestedEar = "Right"
        }
        testSoundTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("stopTestSound"), userInfo: nil, repeats: false) //start timer to stop the sound again
    }

    func stopTestSound(){
        toneplayer.stopSound()
    }
    
    
}