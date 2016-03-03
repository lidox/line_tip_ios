//
//  MedTrial+CoreDataProperties.swift
//  LineTip
//
//  Created by Artur Schäfer on 29.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MedTrial {

    @NSManaged var duration: NSNumber!
    @NSManaged var fails: NSNumber!
    @NSManaged var hits: NSNumber!
    @NSManaged var timeStamp: String!
    @NSManaged var isSelectedForStats: NSNumber!
    @NSManaged var creationDate: NSDate!
    @NSManaged var user: MedUser!

}
