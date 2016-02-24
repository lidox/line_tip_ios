//
//  MedUser+CoreDataProperties.swift
//  LineTip
//
//  Created by Artur Schäfer on 24.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MedUser {

    @NSManaged var medId: String?
    @NSManaged var trials: String?

}
