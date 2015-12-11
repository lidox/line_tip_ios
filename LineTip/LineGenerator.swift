//
//  LineGenerator.swift
//  LineTip
//
//  Created by Artur Schäfer on 11.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import Foundation

protocol LineGenerator {
    func getLines() -> Array<Line>
}