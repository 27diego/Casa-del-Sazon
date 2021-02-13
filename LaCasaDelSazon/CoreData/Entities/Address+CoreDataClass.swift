//
//  Address+CoreDataClass.swift
//  
//
//  Created by Developer on 2/13/21.
//
//

import Foundation
import CoreData

@objc(Address)
public class Address: NSManagedObject {

}

extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var zip: String?
    @NSManaged public var longitude: Int64
    @NSManaged public var latitude: Int64
    @NSManaged public var identifier: String?
    @NSManaged public var restaurant: Restaurants?

}
