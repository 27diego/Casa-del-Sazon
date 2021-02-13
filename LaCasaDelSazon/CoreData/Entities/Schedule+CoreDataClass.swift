//
//  Schedule+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
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

    @NSManaged public var sunday: String?
    @NSManaged public var monday: String?
    @NSManaged public var tuesday: String?
    @NSManaged public var wednesday: String?
    @NSManaged public var thursday: String?
    @NSManaged public var friday: String?
    @NSManaged public var saturday: String?
    @NSManaged public var identifier: String?
    @NSManaged public var restaurant: Restaurants?

}
