//
//  MenuItemOptionsCollection+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
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

    @NSManaged public var allowedOptions: Int
    @NSManaged public var identifier: String?
    @NSManaged public var title: String
    @NSManaged public var menuItems: NSSet?
    @NSManaged public var options: Set<MenuItemOption>?

}

// MARK: Generated accessors for menuItems
extension MenuItemOptionsCollection {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItem)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItem)

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

extension MenuItemOptionsCollection {
    static func fetchById(id: String) -> NSFetchRequest<MenuItemOptionsCollection> {
        let request = NSFetchRequest<MenuItemOptionsCollection>(entityName: "MenuItemOptionsCollection")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MenuItemOptionsCollection.identifier), id)
        
        return request
    }
    
    static func fetchByMenuItem(id itemId: String) -> NSFetchRequest<MenuItemOptionsCollection> {
        let request = NSFetchRequest<MenuItemOptionsCollection>(entityName: "MenuItemOptionsCollection")
        request.predicate = NSPredicate(format: "ANY menuItems.identifier == %@", itemId)
        request.sortDescriptors = []
        
        return request
    }
}

extension MenuItemOptionsCollection {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> MenuItemOptionsCollection {
        let request = MenuItemOptionsCollection.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let optionsCollection = MenuItemOptionsCollection(context: context)
        optionsCollection.identifier = id
        
        return optionsCollection
    }
}

