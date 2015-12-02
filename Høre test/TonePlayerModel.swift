//
//  Model.swift
//  Høre test
//
//  Created by Stig Halfdan Juhl Turner on 20/11/15.
//  Copyright © 2015 Stig Halfdan Juhl Turner. All rights reserved.
//

import Foundation
import AVKit

class TonePlayer {
    
    
    let instrument = AKInstrument()
    let Leftamplitude = AKInstrumentProperty(value: 0.25, minimum: 0.0, maximum: 1.0)
    let Leftfrequency = AKInstrumentProperty(value: 1000, minimum: 0, maximum: 10000)
    let Rightamplitude = AKInstrumentProperty(value: 0.25, minimum: 0.0, maximum: 1.0)
    let Rightfrequency = AKInstrumentProperty(value: 1000, minimum: 0, maximum: 10000)

    var playing = false;

    init(){
        
        instrument.addProperty(Leftamplitude)
        instrument.addProperty(Leftfrequency)
        instrument.addProperty(Rightamplitude)
        instrument.addProperty(Rightfrequency)

        let LOscillator = AKOscillator(waveform: AKTable.standardSineWave(), frequency: Leftfrequency, amplitude: Leftamplitude)
        let ROscillator = AKOscillator(waveform: AKTable.standardSineWave(), frequency: Rightfrequency, amplitude: Rightamplitude)
        let stereoaudio = AKStereoAudio(leftAudio: LOscillator,rightAudio: ROscillator)

        instrument.setStereoAudioOutput(stereoaudio)
        AKOrchestra.addInstrument(instrument)
    
    }
    func playSound(amp: Float, freq: Float, left: Bool){
        if(left){
            Rightamplitude.value = 0.0
            Leftamplitude.value = amp
            Leftfrequency.value = freq
        }
        else{
            Leftamplitude.value = 0.0
            Rightamplitude.value = amp
            Rightfrequency.value = freq
        }
        if !playing{
            instrument.play()
            playing = true
        }
    }
    
    func stopSound()
    {
        instrument.stop()
        playing = false
    }
    

}
