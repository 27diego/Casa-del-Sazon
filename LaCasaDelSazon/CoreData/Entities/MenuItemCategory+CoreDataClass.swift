//
//  MenuItemCategory+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItemCategory)
public class MenuItemCategory: NSManagedObject {

}

extension MenuItemCategory: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemCategory> {
        return NSFetchRequest<MenuItemCategory>(entityName: "MenuItemCategory")
    }

    @NSManaged public var category: String
    @NSManaged public var identifier: String?
    @NSManaged public var menuItems: NSSet?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for menuItems
extension MenuItemCategory {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItems)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItems)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}

// MARK: Generated accessors for restaurants
extension MenuItemCategory {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}

// MARK: - Fetch Requests
extension MenuItemCategory {
    static func fetchByCategory(_ category: String) -> NSFetchRequest<MenuItemCategory> {
        let request = NSFetchRequest<MenuItemCategory>(entityName: String(describing: MenuItemCategory.self))
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MenuItemCategory.category), category)
        return request
    }
    
    static func fetchByRestaurant(id restaurantId: String) -> NSFetchRequest<MenuItemCategory> {
        let request = NSFetchRequest<MenuItemCategory>(entityName: String(describing: MenuItemCategory.self))
        request.sortDescriptors = []
        request.predicate  = NSPredicate(format: "ANY restaurants.identifier = %@", restaurantId)        
        return request
    }
}

// MARK: - Static functions
extension MenuItemCategory {
    static func findOrInsert(name: String, context: NSManagedObjectContext) -> MenuItemCategory {
        let request = fetchByCategory(name)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let category = MenuItemCategory(context: context)
        category.category = name
        
        return category
    }
    
    static func isEmpty(using context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<MenuItemCategory> = MenuItemCategory.fetchRequest()
        let count = try? context.count(for: request)
        return count ?? 0 == 0 ? true : false
    }
    
    static func isEmpty(for restaurant: String, using context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<MenuItemCategory> = MenuItemCategory.fetchByRestaurant(id: restaurant)
        let count = try? context.count(for: request)
        return count ?? 0 == 0 ? true : false
    }
    
}
