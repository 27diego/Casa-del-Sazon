//
//  Drinks+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(Drinks)
public class Drinks: NSManagedObject {

}

extension Drinks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drinks> {
        return NSFetchRequest<Drinks>(entityName: "Drinks")
    }

    @NSManaged public var hasPrerequisites: Bool
    @NSManaged public var identifier: String?
    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var prerequisites: NSSet?
    @NSManaged public var restaurants: NSSet?

}

// MARK: Generated accessors for categories
extension Drinks {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: DrinksCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: DrinksCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for prerequisites
extension Drinks {

    @objc(addPrerequisitesObject:)
    @NSManaged public func addToPrerequisites(_ value: DrinkPrerequisiteCollection)

    @objc(removePrerequisitesObject:)
    @NSManaged public func removeFromPrerequisites(_ value: DrinkPrerequisiteCollection)

    @objc(addPrerequisites:)
    @NSManaged public func addToPrerequisites(_ values: NSSet)

    @objc(removePrerequisites:)
    @NSManaged public func removeFromPrerequisites(_ values: NSSet)

}

// MARK: Generated accessors for restaurants
extension Drinks {

    @objc(addRestaurantsObject:)
    @NSManaged public func addToRestaurants(_ value: Restaurant)

    @objc(removeRestaurantsObject:)
    @NSManaged public func removeFromRestaurants(_ value: Restaurant)

    @objc(addRestaurants:)
    @NSManaged public func addToRestaurants(_ values: NSSet)

    @objc(removeRestaurants:)
    @NSManaged public func removeFromRestaurants(_ values: NSSet)

}
