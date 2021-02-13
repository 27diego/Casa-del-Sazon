//
//  MenuItemOptionsCollection+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
//
//

import Foundation
import CoreData

@objc(MenuItemOptionsCollection)
public class MenuItemOptionsCollection: NSManagedObject {

}

extension MenuItemOptionsCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemOptionsCollection> {
        return NSFetchRequest<MenuItemOptionsCollection>(entityName: "MenuItemOptionsCollection")
    }

    @NSManaged public var allowedOptions: Int64
    @NSManaged public var title: String?
    @NSManaged public var identifier: String?
    @NSManaged public var menuItems: NSSet?
    @NSManaged public var options: NSSet?

}

// MARK: Generated accessors for menuItems
extension MenuItemOptionsCollection {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItems)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItems)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}

// MARK: Generated accessors for options
extension MenuItemOptionsCollection {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: MenuItemOption)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: MenuItemOption)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}
