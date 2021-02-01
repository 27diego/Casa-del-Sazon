//
//  User+CoreDataClass.swift
//  
//
//  Created by Developer on 2/1/21.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
}

extension User {
    static func createUser(email: String, context: NSManagedObjectContext) {
        let user = User(context: context)
        user.email = email
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
