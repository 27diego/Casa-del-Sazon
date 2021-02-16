//
//  DrinksCategory+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(DrinksCategory)
public class DrinksCategory: NSManagedObject {

}

extension DrinksCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinksCategory> {
        return NSFetchRequest<DrinksCategory>(entityName: "DrinksCategory")
    }

    @NSManaged public var category: String?
    @NSManaged public var identifier: String?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for drinks
extension DrinksCategory {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

// MARK: Generated accessors for restaurants
extension DrinksCategory {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)
}

extension DrinksCategory {
    static func fetchById(id: String) -> NSFetchRequest<DrinksCategory> {
        let request = NSFetchRequest<DrinksCategory>(entityName: "DrinksCategory")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(DrinksCategory.identifier), id)
        
        return request
    }
}

extension DrinksCategory {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> DrinksCategory {
        let request = DrinksCategory.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let categorty = DrinksCategory(context: context)
        categorty.identifier = id
        
        return categorty
    }
}
