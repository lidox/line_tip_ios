//
//  MedUserManager.swift
//  LineTip
//
//  Created by Artur Schäfer on 28.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import CoreData

class MedUserManager {
    
    let medId : String
    
    init(medId : String){
        self.medId = medId
    }
    
    class func insertMedUserByName(userName: String) -> MedUser {
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("MedUser", inManagedObjectContext: moc) as! MedUser
        
        // add our data
        entity.setValue(userName, forKey: "medId")
        
        // we save our entity
        do {
            try moc.save()
            return entity
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    class func fetchMedUsers() -> Array<MedUser> {
        
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "MedUser")
        
        do {
            let users = try moc.executeFetchRequest(personFetch) as! [MedUser]
            return users
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    class func fetchMedUserById(objectID: NSManagedObjectID ) -> MedUser {
        let moc = DataController().managedObjectContext
        do {
            let users = try moc.existingObjectWithID(objectID) as! MedUser
            print("fetched user: \(users.medId)")
            return users
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    class func fetchMedIdByObjectId(objectID: NSManagedObjectID ) -> String {
        let moc = DataController().managedObjectContext
        do {
            let users = try moc.existingObjectWithID(objectID) as! MedUser
            return users.medId
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func fetchLastTrial() {
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "MedUser")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(personFetch) as! [MedUser]
            print("fetched person: \(fetchedPerson.last!.medId!)")
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}