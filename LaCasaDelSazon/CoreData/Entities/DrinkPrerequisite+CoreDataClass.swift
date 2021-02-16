//
//  DrinkPrerequisite+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
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

    @NSManaged public var identifier: String?
    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var drinkCollection: DrinkPrerequisiteCollection?

}

extension DrinkPrerequisite {
    static func fetchById(id: String) -> NSFetchRequest<DrinkPrerequisite> {
        let request = NSFetchRequest<DrinkPrerequisite>(entityName: "DrinkPrerequisite")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(DrinkPrerequisite.identifier), id)
        
        return request
    }
}

extension DrinkPrerequisite {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> DrinkPrerequisite {
        let request = DrinkPrerequisite.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let prerequisite = DrinkPrerequisite(context: context)
        prerequisite.identifier = id
        
        return prerequisite
    }
}
