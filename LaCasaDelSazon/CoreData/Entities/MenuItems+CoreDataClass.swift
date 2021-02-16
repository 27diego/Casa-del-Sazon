//
//  MenuItems+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItem)
public class MenuItem: NSManagedObject {

}

extension MenuItem: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItem> {
        return NSFetchRequest<MenuItem>(entityName: "MenuItems")
    }

    @NSManaged public var hasOptions: Bool
    @NSManaged public var hasPrerequisites: Bool
    @NSManaged public var identifier: String?
    @NSManaged public var overview: String
    @NSManaged public var favorites: Int
    @NSManaged public var price: Double
    @NSManaged public var timeForCompletion: Double
    @NSManaged public var title: String
    @NSManaged public var type: String
    @NSManaged public var categories: NSSet?
    @NSManaged public var options: NSSet?
    @NSManaged public var prerequisites: NSSet?
    @NSManaged public var restaurant: NSSet?

}

// MARK: Generated accessors for categories
extension MenuItem {

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
extension MenuItem {

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
extension MenuItem {

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
extension MenuItem {

    @objc(addRestaurantObject:)
    @NSManaged public func addToRestaurant(_ value: Restaurant)

    @objc(removeRestaurantObject:)
    @NSManaged public func removeFromRestaurant(_ value: Restaurant)

    @objc(addRestaurant:)
    @NSManaged public func addToRestaurant(_ values: NSSet)

    @objc(removeRestaurant:)
    @NSManaged public func removeFromRestaurant(_ values: NSSet)

}

extension MenuItem {
    static func fetchById(id: String) -> NSFetchRequest<MenuItem> {
        let request = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MenuItem.identifier), id)
        
        return request
    }
    
    static func fetchByRestaurant(id: String) -> NSFetchRequest<MenuItem> {
        let request = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        request.sortDescriptors = [NSSortDescriptor(key: "favorites", ascending: true)]
        request.predicate = NSPredicate(format: "ANY restaurant.identifier = %@", id)
        
        return request
    }
}

extension MenuItem {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> MenuItem {
        let request = MenuItem.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let menuItem = MenuItem(context: context)
        menuItem.identifier = id
        
        return menuItem
    }
    
    static func saveMenuItem(from FSItem: FSMenuItem, to coreMenuItem: MenuItem){
        coreMenuItem.overview = FSItem.description
        coreMenuItem.favorites = FSItem.favorites
        coreMenuItem.hasOptions = FSItem.hasOptions
        coreMenuItem.hasPrerequisites = FSItem.hasPrerequisites
        coreMenuItem.price = FSItem.price
        coreMenuItem.timeForCompletion = FSItem.timeForCompletion ?? 0.0
        coreMenuItem.title = FSItem.title
        coreMenuItem.type = FSItem.type
    }
    
    static func isEmpty(for id: String, context: NSManagedObjectContext) -> Bool {
        let request = MenuItem.fetchByRestaurant(id: id)
        let count = try? context.count(for: request)
        
        return count ?? 0 == 0 ? true : false
    }
}
