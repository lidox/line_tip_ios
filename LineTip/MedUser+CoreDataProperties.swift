//
//  MedUser+CoreDataProperties.swift
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

extension MedUser {
    
    @NSManaged var medId: String
    @NSManaged var creationDate: NSDate
    @NSManaged var trial: NSSet?
    @NSManaged var updateDate: NSDate?
    
    func rename(value: String) {
        self.setValue(value, forKey: "medId")
    }
    
    func addTrial(value: MedTrial) {
        self.mutableSetValueForKey("trial").addObject(value)
        self.setValue(NSDate(), forKey: "updateDate")
    }
    
    func getTrialList() -> [MedTrial] {
        var trialList: [MedTrial]
        //let befriendedByPerson = aPerson.valueForKeyPath("befriendedBy.source")
        //trialList = self.valueForKeyPath("trial.source") as! [MedTrial]
        trialList = self.trial!.allObjects as! [MedTrial]
        return trialList
    }
    
}