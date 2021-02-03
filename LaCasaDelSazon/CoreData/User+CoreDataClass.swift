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

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var identifier: String
    @NSManaged public var phone: String?
}

extension User {
    static func fetchUser(withId id: String) -> NSFetchRequest<User> {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(User.identifier), id)
        return request
    }
}

extension User {
    static func saveLogedUser(email: String?, name: String?, phone: String? = nil, identifier: String, context: NSManagedObjectContext){
        let user = User(context: context)
        user.email = email
        user.name = name
        user.phone = phone
        user.identifier = identifier
        
        do {
            try context.save()
        }
        catch {
            print("Could not save new user |AuthenticationViewModel| : \(error.localizedDescription)")
        }
    }
    
    static func deleteLogedUser(id: String, context: NSManagedObjectContext) {
        let request = User.fetchUser(withId: id)
        if let user = try? context.fetch(request).first {
            do {
                context.delete(user)
                try context.save()
            }
            catch {
                context.rollback()
                print(error.localizedDescription)
            }
        }
    }
}
