//
//  MedUser+CoreDataProperties.swift
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

extension MedUser {

    @NSManaged var medId: String
    @NSManaged var creationDate: NSDate
    @NSManaged var trial: NSSet?
    
    func addTrial(value: MedTrial) {
        self.mutableSetValueForKey("trial").addObject(value)
    }
    
    func getTrialList() -> [MedTrial] {
        var trialList: [MedTrial]
        //let befriendedByPerson = aPerson.valueForKeyPath("befriendedBy.source")
        //trialList = self.valueForKeyPath("trial.source") as! [MedTrial]
        trialList = self.trial!.allObjects as! [MedTrial]
        return trialList
    }
}
