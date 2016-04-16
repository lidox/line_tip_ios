//
//  MissedTouchPosition+CoreDataProperties.swift
//  LineTip
//
//  Created by Artur Schäfer on 16.04.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MissedTouchPosition {

    @NSManaged var x: NSNumber?
    @NSManaged var y: NSNumber?
    @NSManaged var medtrial: MedTrial?
    
    func setXY(x: Double, y: Double) {
        self.setValue(y, forKey: "y")
        self.setValue(x, forKey: "x")
    }
}
