//
//  Restaurants+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
//
//

import Foundation
import CoreData

@objc(Restaurants)
public class Restaurants: NSManagedObject {

}

extension Restaurants {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurants> {
        return NSFetchRequest<Restaurants>(entityName: "Restaurants")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var identifier: String?
    @NSManaged public var schedule: Schedule?
    @NSManaged public var address: Address?
    @NSManaged public var menuItems: NSSet?

}

// MARK: Generated accessors for menuItems
extension Restaurants {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItems)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItems)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}
