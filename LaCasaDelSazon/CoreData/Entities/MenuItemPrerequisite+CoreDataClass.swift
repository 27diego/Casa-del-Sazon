//
//  MenuItemPrerequisite+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
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

    @NSManaged public var overview: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var identifier: String?
    @NSManaged public var prerequisiteCollection: MenuItemPrerequisiteCollection?

}
