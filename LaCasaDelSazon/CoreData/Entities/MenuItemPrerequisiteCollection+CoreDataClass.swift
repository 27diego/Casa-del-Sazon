//
//  MenuItemPrerequisiteCollection+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItemPrerequisiteCollection)
public class MenuItemPrerequisiteCollection: NSManagedObject {

}

extension MenuItemPrerequisiteCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemPrerequisiteCollection> {
        return NSFetchRequest<MenuItemPrerequisiteCollection>(entityName: "MenuItemPrerequisiteCollection")
    }

    @NSManaged public var allowedPrerequisites: Double
    @NSManaged public var identifier: String?
    @NSManaged public var title: String?
    @NSManaged public var menuItems: NSSet?
    @NSManaged public var prerequisites: NSSet?

}

// MARK: Generated accessors for menuItems
extension MenuItemPrerequisiteCollection {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItems)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItems)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}

// MARK: Generated accessors for prerequisites
extension MenuItemPrerequisiteCollection {

    @objc(addPrerequisitesObject:)
    @NSManaged public func addToPrerequisites(_ value: MenuItemPrerequisite)

    @objc(removePrerequisitesObject:)
    @NSManaged public func removeFromPrerequisites(_ value: MenuItemPrerequisite)

    @objc(addPrerequisites:)
    @NSManaged public func addToPrerequisites(_ values: NSSet)

    @objc(removePrerequisites:)
    @NSManaged public func removeFromPrerequisites(_ values: NSSet)

}
