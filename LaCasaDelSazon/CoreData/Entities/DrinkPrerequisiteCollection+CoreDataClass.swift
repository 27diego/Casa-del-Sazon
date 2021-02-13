//
//  DrinkPrerequisiteCollection+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
//
//

import Foundation
import CoreData

@objc(DrinkPrerequisiteCollection)
public class DrinkPrerequisiteCollection: NSManagedObject {

}

extension DrinkPrerequisiteCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkPrerequisiteCollection> {
        return NSFetchRequest<DrinkPrerequisiteCollection>(entityName: "DrinkPrerequisiteCollection")
    }

    @NSManaged public var allowedPrerequisites: Int64
    @NSManaged public var title: String?
    @NSManaged public var identifier: String?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var prerequisites: NSSet?

}

// MARK: Generated accessors for drinks
extension DrinkPrerequisiteCollection {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drinks)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drinks)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

// MARK: Generated accessors for prerequisites
extension DrinkPrerequisiteCollection {

    @objc(addPrerequisitesObject:)
    @NSManaged public func addToPrerequisites(_ value: DrinkPrerequisite)

    @objc(removePrerequisitesObject:)
    @NSManaged public func removeFromPrerequisites(_ value: DrinkPrerequisite)

    @objc(addPrerequisites:)
    @NSManaged public func addToPrerequisites(_ values: NSSet)

    @objc(removePrerequisites:)
    @NSManaged public func removeFromPrerequisites(_ values: NSSet)

}
