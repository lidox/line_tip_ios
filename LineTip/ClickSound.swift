//
//  ClickSound.swift
//  LineTip
//
//  Created by Artur Schäfer on 02.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import AudioToolbox

class ClickSound {
    
    /// Plays a sound by sound and extension name
    class func play(soundName: String, soundExtension: String){
        if let soundURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: soundExtension) {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }
    }
    
    /// let the device vibrate (only iphone)
    class func playVibration(){
        //AudioServicesPlayAlertSoundWithCompletion(kSystemSoundID_Vibrate, nil)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }


}