//
//  PreGeneratedLine.swift
//  LineTip
//
//  Created by Artur Schäfer on 11.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import Foundation

/// this class class contains some lines to test
class PreGeneratedLine: LineGenerator {
    
    func getLines() -> Array<Line> {
        var lines = [Line]()
        let line2 = Line(x1: 105, y1: 324, x2: 401, y2: 324)
        lines.append(line2)
        let line4 = Line(x1: 72, y1: 545, x2: 549, y2: 545)
        lines.append(line4)
        let line5 = Line(x1: 18, y1: 284, x2: 521, y2: 284)
        lines.append(line5)
        let line6 = Line(x1: 35, y1: 630, x2: 614, y2: 630)
        lines.append(line6)
        let line7 = Line(x1: 104, y1: 563, x2: 420, y2: 563)
        lines.append(line7)
        let line8 = Line(x1: 71, y1: 731, x2: 264, y2: 731)
        lines.append(line8)
        return lines
    }
}