//
//  Restaurant+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(Restaurant)
public class Restaurant: NSManagedObject {

}

extension Restaurant: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var image: String
    @NSManaged public var address: Address
    @NSManaged public var menuItems: Set<MenuItems>?
    @NSManaged public var schedule: Schedule
    @NSManaged public var drinkCategories: Set<DrinksCategory>?
    @NSManaged public var drinks: Set<Drinks>?
    @NSManaged public var menuItemCategories: Set<MenuItemCategory>?

}

// MARK: Generated accessors for menuItems
extension Restaurant {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItems)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItems)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}

// MARK: Generated accessors for drinkCategories
extension Restaurant {

    @objc(addDrinkCategoriesObject:)
    @NSManaged public func addToDrinkCategories(_ value: DrinksCategory)

    @objc(removeDrinkCategoriesObject:)
    @NSManaged public func removeFromDrinkCategories(_ value: DrinksCategory)

    @objc(addDrinkCategories:)
    @NSManaged public func addToDrinkCategories(_ values: NSSet)

    @objc(removeDrinkCategories:)
    @NSManaged public func removeFromDrinkCategories(_ values: NSSet)

}

// MARK: Generated accessors for drinks
extension Restaurant {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drinks)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drinks)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

// MARK: Generated accessors for menuItemCategories
extension Restaurant {

    @objc(addMenuItemCategoriesObject:)
    @NSManaged public func addToMenuItemCategories(_ value: MenuItemCategory)

    @objc(removeMenuItemCategoriesObject:)
    @NSManaged public func removeFromMenuItemCategories(_ value: MenuItemCategory)

    @objc(addMenuItemCategories:)
    @NSManaged public func addToMenuItemCategories(_ values: NSSet)

    @objc(removeMenuItemCategories:)
    @NSManaged public func removeFromMenuItemCategories(_ values: NSSet)

}

// MARK: - Static Fetch Requests
extension Restaurant {
    static func fetchByIdentifier(_ identifier: String) -> NSFetchRequest<Restaurant> {
        let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Restaurant.identifier), identifier)
        return request
    }
}

// MARK: - Static Member Functions
extension Restaurant {
    static func findOrInsert(id: String, context: NSManagedObjectContext) -> Restaurant {
        let request = Restaurant.fetchByIdentifier(id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let restaurant = Restaurant(context: context)
        restaurant.identifier = id
        return restaurant
    }
    
    static func isEmpty(using context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let count = try? context.count  (for: request)
        return count ?? 0 == 0 ? true : false
    }
}

