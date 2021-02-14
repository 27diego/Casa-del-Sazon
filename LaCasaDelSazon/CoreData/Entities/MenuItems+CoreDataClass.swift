//
//  MenuItems+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItems)
public class MenuItems: NSManagedObject {

}

extension MenuItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItems> {
        return NSFetchRequest<MenuItems>(entityName: "MenuItems")
    }

    @NSManaged public var hasOptions: Bool
    @NSManaged public var hasPrerequisites: Bool
    @NSManaged public var identifier: String?
    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var timeForCompletion: Double
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var options: NSSet?
    @NSManaged public var prerequisites: NSSet?
    @NSManaged public var restaurant: NSSet?

}

// MARK: Generated accessors for categories
extension MenuItems {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: MenuItemCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: MenuItemCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for options
extension MenuItems {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: MenuItemOptionsCollection)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: MenuItemOptionsCollection)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}

// MARK: Generated accessors for prerequisites
extension MenuItems {

    @objc(addPrerequisitesObject:)
    @NSManaged public func addToPrerequisites(_ value: MenuItemPrerequisiteCollection)

    @objc(removePrerequisitesObject:)
    @NSManaged public func removeFromPrerequisites(_ value: MenuItemPrerequisiteCollection)

    @objc(addPrerequisites:)
    @NSManaged public func addToPrerequisites(_ values: NSSet)

    @objc(removePrerequisites:)
    @NSManaged public func removeFromPrerequisites(_ values: NSSet)

}

// MARK: Generated accessors for restaurant
extension MenuItems {

    @objc(addRestaurantObject:)
    @NSManaged public func addToRestaurant(_ value: Restaurant)

    @objc(removeRestaurantObject:)
    @NSManaged public func removeFromRestaurant(_ value: Restaurant)

    @objc(addRestaurant:)
    @NSManaged public func addToRestaurant(_ values: NSSet)

    @objc(removeRestaurant:)
    @NSManaged public func removeFromRestaurant(_ values: NSSet)

}
