//
//  MenuItemPrerequisite+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItemPrerequisite)
public class MenuItemPrerequisite: NSManagedObject {

}

extension MenuItemPrerequisite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemPrerequisite> {
        return NSFetchRequest<MenuItemPrerequisite>(entityName: "MenuItemPrerequisite")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var prerequisiteCollection: MenuItemPrerequisiteCollection?

}

extension MenuItemPrerequisite {
    static func fetchById(id: String) -> NSFetchRequest<MenuItemPrerequisite> {
        let request = NSFetchRequest<MenuItemPrerequisite>(entityName: "MenuItemPrerequisite")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MenuItemPrerequisite.identifier), id)
        
        return request
    }
}

extension MenuItemPrerequisite {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> MenuItemPrerequisite {
        let request = MenuItemPrerequisite.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let menuItem = MenuItemPrerequisite(context: context)
        menuItem.identifier = id
        
        return menuItem
    }
}
