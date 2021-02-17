//
//  MenuItemOption+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
//
//

import Foundation
import CoreData

@objc(MenuItemOption)
public class MenuItemOption: NSManagedObject {

}

extension MenuItemOption: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemOption> {
        return NSFetchRequest<MenuItemOption>(entityName: "MenuItemOption")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var overview: String
    @NSManaged public var price: Double
    @NSManaged public var title: String
    @NSManaged public var optionCollection: MenuItemOptionsCollection?

}


extension MenuItemOption {
    static func fetchById(id: String) -> NSFetchRequest<MenuItemOption> {
        let request = NSFetchRequest<MenuItemOption>(entityName: "MenuItemOption")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MenuItemOption.identifier), id)
        
        return request
    }
}

extension MenuItemOption {
    static func findOrInsert(withId id: String, context: NSManagedObjectContext) -> MenuItemOption {
        let request = MenuItemOption.fetchById(id: id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let option = MenuItemOption(context: context)
        option.identifier = id
        
        return option
    }
}
