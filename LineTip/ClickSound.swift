//
//  ClickSound.swift
//  LineTip
//
//  Created by Artur Schäfer on 02.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import AudioToolbox

class ClickSound {
    
    class func play(soundName: String, soundExtension: String){
        // Load "mysoundname.wav"
        if let soundURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: soundExtension) {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }
    }

}