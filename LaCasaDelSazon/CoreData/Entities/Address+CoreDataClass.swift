//
//  Address+CoreDataClass.swift
//  
//
//  Created by Developer on 2/14/21.
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

    @NSManaged public var city: String
    @NSManaged public var identifier: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var state: String
    @NSManaged public var street: String
    @NSManaged public var zip: String
    @NSManaged public var restaurant: Restaurant?
    
    var formattedAddress: String {
        return street + ", " + city + ", " + state
    }
}

// MARK: - Static Fetch Requests
extension Address {
    static func fetchByIdentifier(_ identifier: String) -> NSFetchRequest<Address> {
        let request = NSFetchRequest<Address>(entityName: "Address")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Restaurant.identifier), identifier)
        return request
    }
}

// MARK: - Static Member Functions
extension Address {
    static func findOrInsert(id: String, context: NSManagedObjectContext) -> Address {
        let request = Address.fetchByIdentifier(id)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let address = Address(context: context)
        address.identifier = id
        return address
    }
    
    
    static func saveFromFSAddress(coreAddress: Address, fsAddress: FSAddress) {
        coreAddress.city = fsAddress.city
        coreAddress.latitude = fsAddress.latitude
        coreAddress.longitude = fsAddress.longitude
        coreAddress.state = fsAddress.state
        coreAddress.street = fsAddress.street
        coreAddress.zip = fsAddress.zip
    }
}
