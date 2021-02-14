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

extension MenuItemOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItemOption> {
        return NSFetchRequest<MenuItemOption>(entityName: "MenuItemOption")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var optionCollection: MenuItemOptionsCollection?

}
