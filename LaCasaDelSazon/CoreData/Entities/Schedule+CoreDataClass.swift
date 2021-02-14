//
//  Schedule+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(Schedule)
public class Schedule: NSManagedObject {

}

extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var friday: String
    @NSManaged public var identifier: String?
    @NSManaged public var monday: String
    @NSManaged public var saturday: String
    @NSManaged public var sunday: String
    @NSManaged public var thursday: String
    @NSManaged public var tuesday: String
    @NSManaged public var wednesday: String
    @NSManaged public var restaurant: Restaurant?
    
    var openingTime: String {
        let schedule = tuesday.components(separatedBy: "-")
        return schedule.first ?? ""
    }
    
    var closingTime: String {
        let schedule = tuesday.components(separatedBy: "-")
        return schedule[1]
    }

}


// MARK: - Static Fetch Requests
extension Schedule {
    static func fetchByIdentifier(_ identifier: String) -> NSFetchRequest<Schedule> {
        let request = NSFetchRequest<Schedule>(entityName: "Schedule")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Restaurant.identifier), identifier)
        return request
    }
}

// MARK: - Static Member Functions
extension Schedule {
    static func findOrInsert(id: String, context: NSManagedObjectContext) -> Schedule {
        let request = Schedule.fetchByIdentifier(id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let schedule = Schedule(context: context)
        schedule.identifier = id
        return schedule
    }
    
    
    static func saveFromFSSchedule(coreSchedule: Schedule, fsSchedule: FSSchedule) {
        coreSchedule.friday = fsSchedule.Friday
        coreSchedule.monday = fsSchedule.Monday
        coreSchedule.saturday = fsSchedule.Saturday
        coreSchedule.sunday = fsSchedule.Sunday
        coreSchedule.thursday = fsSchedule.Thursday
        coreSchedule.tuesday = fsSchedule.Tuesday
        coreSchedule.wednesday = fsSchedule.Wednesday
    }
}
