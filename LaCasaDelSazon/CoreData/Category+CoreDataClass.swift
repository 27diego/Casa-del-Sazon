//
//  Category+CoreDataClass.swift
//  
//
//  Created by Developer on 2/8/21.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {

}

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var category: String
}

extension Category {
    static func findOrInsert(name: String, context: NSManagedObjectContext) {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.category), name)
        request.sortDescriptors = []
        
        if let _ = try? context.fetch(request).first {
            return
        }
        
        let category = Category(context: context)
        category.category = name
        
        do {
            try context.save()
            return
        } catch {
            print("Could not save Category \(name) to core data")
            context.rollback()
        }
    }
}
