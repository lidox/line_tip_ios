//
//  ConfigKey.swift
//  LineTip
//
//  Created by Artur Schäfer on 19.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation

/// This enum contains important configuration keys.
/// They are used for loading nsuserdefaults.
enum ConfigKey {
    static let LINE_WIDTH = "LINE_WIDTH"
    static let LINE_BROADNESS = "LINE_BROADNESS"
    static let LINE_REDRAW_DELAY = "LINE_REDRAW_DELAY"
    static let LINE_RANDOM_GENERATION = "LINE_RANDOM_GENERATION"
    static let LINE_TIMER_ACTIVATED = "LINE_TIMER_ACTIVATED"
    static let SPOT_WIDTH = "spot_width"
    static let SPOT_HEIGHT = "spot_height"
    static let SPOT_IMAGE_NAME = "spot_image_name"
    static let SOUND_MISS = "SOUND_MISS"
    static let SOUND_HIT = "SOUND_HIT"
    static let TRANSLATION = "TRANSLATION"
    
}