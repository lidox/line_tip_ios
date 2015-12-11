//
//  PreGeneratedLine.swift
//  LineTip
//
//  Created by Artur Schäfer on 11.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import Foundation

class PreGeneratedLine: LineGenerator {
    
    func getLines() -> Array<Line> {
        var lines = [Line]()
        let line = Line(x1: 0, y1: 100, x2: 400, y2: 100)
        let line2 = Line(x1: 0, y1: 200, x2: 400, y2: 200)
        let line3 = Line(x1: 0, y1: 500, x2: 400, y2: 500)
        lines.append(line)
        lines.append(line2)
        lines.append(line3)
        return lines
    }
}