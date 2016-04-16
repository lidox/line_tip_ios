//
//  MedUserManager.swift
//  LineTip
//
//  Created by Artur Schäfer on 28.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// This class accesses the data base via core data to create, delete and update users and its trials
class MedUserManager {
    
    var myMoc : NSManagedObjectContext!
    
    init(){
        myMoc = DataController().managedObjectContext
    }
    
    func renameMedUserByObjectId(objectID: NSManagedObjectID, newName: String ) {
        
        do {
            let userToRename = try myMoc.existingObjectWithID(objectID) as! MedUser
            
            
            // now delete object
            userToRename.rename(newName)
            
            try myMoc.save()
            
        } catch {
            fatalError("Failed to rename user: \(error)")
        }
    }
    
    /// adds the trial to the selected user and saves in database
    func addTrialToUserByUserObjectId(objectID: NSManagedObjectID, givenTrial: Trial) {
        
        do {
            let medUser = try myMoc.existingObjectWithID(objectID) as? MedUser
            let trial = NSEntityDescription.insertNewObjectForEntityForName("MedTrial", inManagedObjectContext: myMoc) as! MedTrial
            
            trial.setValue(givenTrial.hits, forKey: "hits")
            trial.setValue(givenTrial.fails, forKey: "fails")
            trial.setValue(givenTrial.duration, forKey: "duration")
            trial.setValue(givenTrial.timeStamp, forKey: "timeStamp")
            trial.setValue(true, forKey: "isSelectedForStats")
            trial.setValue(givenTrial.creationDate, forKey: "creationDate")
            
            for point in givenTrial.missedLinePositionList {
                let databasePoint = NSEntityDescription.insertNewObjectForEntityForName("MissedTouchPosition", inManagedObjectContext: myMoc) as! MissedTouchPosition
                print("MedUserManager: \(Double(point.x))")
                databasePoint.setValue(Double(point.x), forKey: "x")
                databasePoint.setValue(Double(point.y), forKey: "y")
                //databasePoint.setXY(Double(point.x), y: Double(point.y))
                trial.addMissedTouchPosition(databasePoint)
            }

            medUser!.addTrial(trial)
            try myMoc.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getTrialListByObjectId(objectId: NSManagedObjectID) -> [Trial]
    {
        var retList = [Trial] ()
        do {
            let medUser = try myMoc.existingObjectWithID(objectId) as? MedUser
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
                
                let missedPositionList = trialList[index].missedTouchPosList!.allObjects as! [MissedTouchPosition]
                for point in missedPositionList {
                    //print("MedUserManager \(point.x!)")
                    let cgpoint = CGPoint(x: Double(point.x!), y: Double(point.y!))
                    trial.missedLinePositionList.append(cgpoint)
                }
                
                retList.append(trial)
            }
            return retList
        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
    
    func deleteMedUserByObjectId(objectID: NSManagedObjectID ) {
        
        do {
            let userToDelete = try myMoc.existingObjectWithID(objectID) as! MedUser
            
            // first delete all trials of user
            for item in userToDelete.trial!{
                myMoc.deleteObject(item as! NSManagedObject)
            }
            
            let userName = userToDelete.medId
            
            // now delete object
            myMoc.deleteObject(userToDelete)
            
            try myMoc.save()
            print("user: \(userName) deleted")
            
        } catch {
            fatalError("Failed to delete user: \(error)")
        }
    }
    
    func getLastTrialByObjectId(objectId: NSManagedObjectID) -> Trial {
        do {
            let medUser = try myMoc.existingObjectWithID(objectId) as? MedUser
            let trialList = medUser?.trial!.allObjects as! [MedTrial]
            
            let retTrial = Trial()
            retTrial.hits = 0
            if(trialList.count > 0){
                
                //find the latest trial by creationdate
                let lastTrial = trialList.sort({ $0.creationDate.compare($1.creationDate) == .OrderedDescending }).last

                
                retTrial.hits = (lastTrial?.hits?.integerValue)!
                retTrial.fails = (lastTrial?.fails?.integerValue)!
                retTrial.duration = (lastTrial?.duration?.doubleValue)!
                retTrial.timeStamp = (lastTrial?.timeStamp)!
                retTrial.isSelectedForStats = (lastTrial!.isSelectedForStats!.boolValue)
            }
            return retTrial
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetchMedUserById(objectID: NSManagedObjectID ) -> MedUser {
        do {
            let users = try self.myMoc.existingObjectWithID(objectID) as! MedUser
            print("fetched user: \(users.medId)")
            return users
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }

    
    func fetchMedUsers() -> Array<MedUser> {
        
        let personFetch = NSFetchRequest(entityName: "MedUser")
        
        do {
            var users = try myMoc.executeFetchRequest(personFetch) as! [MedUser]
            
            // sort by creation date:
            users = users.sort({ $0.creationDate.compare($1.creationDate) == .OrderedDescending })
            
            return users
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func getMedTrialListByObjectId(objectId: NSManagedObjectID) -> [MedTrial]
    {
        do {
            
            let medUser = try myMoc.existingObjectWithID(objectId) as? MedUser
            //return medUser!.trial!.allObjects as! [MedTrial]
            
            let fetchRequest = NSFetchRequest(entityName: "MedTrial")
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            let predicate = NSPredicate(format: "user == %@", medUser!)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            
            let result = try myMoc.executeFetchRequest(fetchRequest)
            //print(result)
            
            return (result as! [MedTrial])
            
        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
    
    class func insertMedUserByName(userName: String) -> MedUser {
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
    
    class func getLastTrialByObjectId(objectId: NSManagedObjectID) -> Trial {
        let context = DataController().managedObjectContext
        
        do {
            let medUser = try context.existingObjectWithID(objectId) as? MedUser
            let trialList = medUser?.trial!.allObjects as! [MedTrial]
            
            let retTrial = Trial()
            retTrial.hits = -1
            if(trialList.count > 0){
                
                //find the latest trial by creationdate
                var lastTrial = trialList.last
                for (index, _) in trialList.enumerate() {
                    let date = trialList[index].creationDate
                    if(lastTrial!.creationDate.isLessThanDate(date)){
                        lastTrial = trialList[index]
                    }
                    
                }
                
                retTrial.hits = (lastTrial?.hits?.integerValue)!
                retTrial.fails = (lastTrial?.fails?.integerValue)!
                retTrial.duration = (lastTrial?.duration?.doubleValue)!
                retTrial.timeStamp = (lastTrial?.timeStamp)!
                retTrial.isSelectedForStats = (lastTrial!.isSelectedForStats!.boolValue)
            }
            return retTrial
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    class func deleteMedUserByObjectId(objectID: NSManagedObjectID ) {
        let moc = DataController().managedObjectContext
        do {
            let userToDelete = try moc.existingObjectWithID(objectID) as! MedUser
            
            
            // first delete all trials of user and their missed line positions
            for item in userToDelete.trial!{
                let currentTrial = item as! MedTrial
                for position in currentTrial.missedTouchPosList! {
                    moc.deleteObject(position as! NSManagedObject)
                }
                
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
            
            // first delete all missed line positions
            for item in trialList[index].missedTouchPosList! {
                moc.deleteObject(item as! NSManagedObject)
            }
            
            // now delete object
            moc.deleteObject(trialList[index])
            
            // delete missed points
            
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
    
    class func getMedTrialListByObjectId(objectId: NSManagedObjectID) -> [MedTrial]
    {
        let context = DataController().managedObjectContext
        do {
            
            let medUser = try context.existingObjectWithID(objectId) as? MedUser
            
            let fetchRequest = NSFetchRequest(entityName: "MedTrial")
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            let predicate = NSPredicate(format: "user == %@", medUser!)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            
            let result = try context.executeFetchRequest(fetchRequest)
            
            return (result as! [MedTrial])

        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
    
    class func insertMedTrial(duration : NSNumber, fails: NSNumber, hits: NSNumber, timeStamp: String, isSelectedForStats: NSNumber, creationDate: NSDate, user: MedUser) -> MedTrial {
 
        let moc = DataController().managedObjectContext

        let entity = NSEntityDescription.insertNewObjectForEntityForName("MedTrial", inManagedObjectContext: moc) as! MedTrial
        
        entity.setValue(duration, forKey: "duration")
        entity.setValue(fails, forKey: "fails")
        entity.setValue(hits, forKey: "hits")
        entity.setValue(timeStamp, forKey: "timeStamp")
        entity.setValue(isSelectedForStats, forKey: "isSelectedForStats")
        entity.setValue(creationDate, forKey: "creationDate")
        entity.setValue(user, forKey: "user")

        do {
            try moc.save()
            return entity
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
}

    
