//
//  LineGenerator.swift
//  LineTip
//
//  Created by Artur Schäfer on 11.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import Foundation

/// prototype for different line detection modi (random, leftrigth etc.)
protocol LineGenerator {
    func getLines() -> Array<Line>
}