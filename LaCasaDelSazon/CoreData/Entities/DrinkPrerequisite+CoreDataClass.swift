//
//  DrinkPrerequisite+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
//
//

import Foundation
import CoreData

@objc(DrinkPrerequisite)
public class DrinkPrerequisite: NSManagedObject {

}

extension DrinkPrerequisite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkPrerequisite> {
        return NSFetchRequest<DrinkPrerequisite>(entityName: "DrinkPrerequisite")
    }

    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var identifier: String?
    @NSManaged public var drinkCollection: DrinkPrerequisiteCollection?

}
