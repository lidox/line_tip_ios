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
        entity.setValue(NSDate(), forKey: "creationDate")
 
        
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
            var users = try moc.executeFetchRequest(personFetch) as! [MedUser]
            
            // sort by creation date:
            users = users.sort({ $0.creationDate.compare($1.creationDate) == .OrderedDescending })
            
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
            print("fetched person: \(fetchedPerson.last!.medId)")
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    class func deleteMedUserByObjectId(objectID: NSManagedObjectID ) {
        let moc = DataController().managedObjectContext
        do {
            let userToDelete = try moc.existingObjectWithID(objectID) as! MedUser
            
            // first delete all trials of user
            for item in userToDelete.trial!{
                moc.deleteObject(item as! NSManagedObject)
            }
            
            let userName = userToDelete.medId
            
            // now delete object
            moc.deleteObject(userToDelete)
            
            try moc.save()
            print("user: \(userName) deleted")
            
        } catch {
            fatalError("Failed to delete user: \(error)")
        }
    }
    
    class func deleteTrialByObjectIdAndTrialIndex(objectID: NSManagedObjectID, index : Int) {
        let moc = DataController().managedObjectContext
        do {
            let medUser = try moc.existingObjectWithID(objectID) as! MedUser
            
            var trialList = medUser.trial!.allObjects as! [MedTrial]
            
            // sort by creation date:
            trialList = trialList.sort({ $0.creationDate.compare($1.creationDate) == .OrderedAscending })
            
            // now delete object
            moc.deleteObject(trialList[index])
            
            try moc.save()
            print("trial deleted")
            
        } catch {
            fatalError("Failed to delete user: \(error)")
        }
    }
    
    class func getTrialListByObjectId(objectId: NSManagedObjectID) -> [Trial]
    {
        let context = DataController().managedObjectContext
        var retList = [Trial] ()
        do {
            let medUser = try context.existingObjectWithID(objectId) as? MedUser
            var trialList = medUser?.trial!.allObjects as! [MedTrial]
            
            // sort by creation date:
            trialList = trialList.sort({ $0.creationDate.compare($1.creationDate) == .OrderedAscending })
            
            for (index, _) in trialList.enumerate() {
                let trial = Trial()
                trial.hits = Int(trialList[index].hits!)
                trial.fails = Int(trialList[index].fails!)
                trial.duration = trialList[index].duration!.doubleValue
                trial.timeStamp = trialList[index].timeStamp!
                trial.creationDate = trialList[index].creationDate
                retList.append(trial)
            }
            return retList
        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
}

    
