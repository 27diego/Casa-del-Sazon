//
//  FirestoreService.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/8/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class FirestoreService: ObservableObject {
    static var shared = FirestoreService()
    private let settings: FirestoreSettings
    private let db: Firestore
    private let context: NSManagedObjectContext
    
    private let restaurantRef: DocumentReference
    
    @Published var drinks = [FSDrink]()
    @Published var drinkPrerequisites = [FSDrinkPrerequisites]()
        
    init(){
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        self.settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        self.db = Firestore.firestore()
        db.settings = self.settings
        
        context = PersistenceController.shared.container.viewContext
        
        restaurantRef = db.collection("Restaurants").document("Sazon431")
        
        getMenuItemOptions()
    }
    
    
    func addUser(name: String, phone: String, UID: String) {
        let formattedName: String = name.split(separator: " ").joined()
        
        db.collection("Users").document("\(formattedName)Profile").setData([
            "name": name,
            "phone": phone,
            "uid": UID
        ], merge: true) { err in
            if let err = err {
                print("error writing document: \(err.localizedDescription)")
            }
            else {
                print("Success!")
            }
        }
    }
    
    func updateCategories() {
        getDocuments(for: .categories, from: FSCategories.self) { results in
            results.forEach { result in
                let category: MenuItemCategory = MenuItemCategory.findOrInsert(name: result.category, context: self.context)
                category.identifier =  result.id

                result.restaurant.forEach { catRestaurant in
                    let restaurant = Restaurant.findOrInsert(id: catRestaurant, context: self.context)
                    restaurant.addToMenuItemCategories(category)
                }
                
                PersistenceController.saveContext(self.context)
            }
        }
    }
    
    func updateCategories(for restaurantId: String) {
        getDocuments(for: .categories, from: FSCategories.self, whereField: "restaurant", contains: restaurantId) { results in
            results.forEach { result in
                let category = MenuItemCategory.findOrInsert(name: result.category, context: self.context)
                category.identifier = result.id
                
                let restaurant = Restaurant.findOrInsert(id: restaurantId, context: self.context)
                restaurant.addToMenuItemCategories(category)
                
                PersistenceController.saveContext(self.context)
            }
        }
    }
    
    func updateRestaurants() {
        getDocuments(for: .restaurants, from: FSRestaurant.self) { res in
            res.forEach { restaurant in
                let coreRestaurant = Restaurant.findOrInsert(id: restaurant.id ?? "No ID", context: self.context)
                coreRestaurant.name = restaurant.name
                coreRestaurant.phone = restaurant.phone
                coreRestaurant.image = restaurant.image
                
                let restaurantSchedule = restaurant.schedule
                let coreSchedule = Schedule.findOrInsert(id: restaurantSchedule.id ?? "No ID", context: self.context)
                Schedule.saveFromFSSchedule(coreSchedule: coreSchedule, fsSchedule: restaurantSchedule)
                
                let restaurantAddress = restaurant.address
                let coreAddress = Address.findOrInsert(id: restaurantAddress.id ?? "No ID", context: self.context)
                Address.saveFromFSAddress(coreAddress: coreAddress, fsAddress: restaurantAddress)
                
                coreRestaurant.address = coreAddress
                coreRestaurant.schedule = coreSchedule
                
                PersistenceController.saveContext(self.context)
            }
        }
    }
    
    
    func updateMenuItems(){
        getDocuments(for: .menuItems, from: FSMenuItem.self) { results in
            self.saveMenuItems(results, restaurantId: nil)
        }
    }
    
    func updateMenuItems(for restaurantId: String){
        getDocuments(for: .menuItems, from: FSMenuItem.self, whereField: "restaurant", contains: restaurantId) { results in
            self.saveMenuItems(results, restaurantId: restaurantId)
        }
    }
    
    private func saveMenuItems(_ results: [FSMenuItem], restaurantId: String?) {
        results.forEach { result in
            let menuItem = MenuItem.findOrInsert(withId: result.id ?? "No ID", context: self.context)
            MenuItem.saveMenuItem(from: result, to: menuItem)
            
            result.categories.forEach { cat in
                let category = MenuItemCategory.findOrInsert(name: cat, context: self.context)
                menuItem.addToCategories(category)
            }
            
            
            if let restaurantId = restaurantId {
                let restaurant = Restaurant.findOrInsert(id: restaurantId, context: self.context)
                menuItem.addToRestaurant(restaurant)
            }

            /*
             @NSManaged public var options: NSSet?
             @NSManaged public var prerequisites: NSSet?
             */
        }
        
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinks() {
        getDocuments(for: .drinks, from: FSDrink.self) { res in
            self.drinks = res
        }
    }
    
    func getDrinkPrerequisites() {
        getDocuments(for: .drinkPrerequisites, from: FSDrinkPrerequisites.self) { res in
            self.drinkPrerequisites = res
        }
    }
    
    func getMenuItemPrerequisites(for menuItemId: String) {
        let menuItem = MenuItem.findOrInsert(withId: menuItemId, context: self.context)
        
        getDocuments(for: .menuItemPrerequisites, from: FSMenuItemPrerequisites.self, whereField: "forItems", contains: menuItemId) { results in
            results.forEach { result in
                let prerequisitesCollection = MenuItemPrerequisiteCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                prerequisitesCollection.title = result.title
                prerequisitesCollection.allowedPrerequisites = result.allowedPrerequisites
                
                result.prerequisites.forEach { FSprereq in
                    let prerequisite = MenuItemPrerequisite.findOrInsert(withId: FSprereq.id ?? "No ID", context: self.context)
                    prerequisite.overview = FSprereq.description
                    prerequisite.price = FSprereq.price
                    prerequisite.title = FSprereq.title
                    
                    prerequisite.prerequisiteCollection = prerequisitesCollection
                }
                menuItem.addToPrerequisites(prerequisitesCollection)
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getMenuItemPrerequisites() {
        getDocuments(for: .menuItemPrerequisites, from: FSMenuItemPrerequisites.self) { results in
            results.forEach { result in
                let prerequisitesCollection = MenuItemPrerequisiteCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                prerequisitesCollection.title = result.title
                prerequisitesCollection.allowedPrerequisites = result.allowedPrerequisites
                
                result.prerequisites.forEach { FSprereq in
                    let prerequisite = MenuItemPrerequisite.findOrInsert(withId: FSprereq.id ?? "No ID", context: self.context)
                    prerequisite.overview = FSprereq.description
                    prerequisite.price = FSprereq.price
                    prerequisite.title = FSprereq.title
                    
                    prerequisite.prerequisiteCollection = prerequisitesCollection
                }
                
                result.forItems.forEach { itemId in
                    let item = MenuItem.findOrInsert(withId: itemId, context: self.context)
                    item.addToPrerequisites(prerequisitesCollection)
                }
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getMenuItemOptions(for menuItemId: String) {
        let menuItem = MenuItem.findOrInsert(withId: menuItemId, context: self.context)
        
        getDocuments(for: .menuItemOptions, from: FSMenuItemOptions.self, whereField: "forItems", contains: menuItemId) { results in
            results.forEach { result in
                let optionCollection = MenuItemOptionsCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                optionCollection.allowedOptions = result.allowedOptions
                optionCollection.title = result.title
                
                result.options.forEach { FSOption in
                    let option = MenuItemOption.findOrInsert(withId: FSOption.id ?? "No ID", context: self.context)
                    option.overview = FSOption.description
                    option.title = FSOption.title
                    option.price = FSOption.price
                    option.optionCollection = optionCollection
                }
                
                menuItem.addToOptions(optionCollection)
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getMenuItemOptions() {
        getDocuments(for: .menuItemOptions, from: FSMenuItemOptions.self) { results in
            results.forEach { result in
                let optionCollection = MenuItemOptionsCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                optionCollection.title = result.title
                optionCollection.allowedOptions = result.allowedOptions
                
                result.options.forEach { FSOption in
                    let option = MenuItemOption.findOrInsert(withId: FSOption.id ?? "No ID", context: self.context)
                    option.overview = FSOption.description
                    option.title = FSOption.title
                    option.price = FSOption.price
                    option.optionCollection = optionCollection
                }
                
                result.forItems.forEach { itemId in
                    let item = MenuItem.findOrInsert(withId: itemId, context: self.context)
                    item.addToOptions(optionCollection)
                }
            }
        }
        PersistenceController.saveContext(self.context)
    }
}

extension FirestoreService {
    func getDocuments<T:Codable>(for type: Collections, from data: T.Type = T.self, completion: @escaping (_ res: [T]) -> Void){
        var results: [T] = .init()
        
        restaurantRef.collection(type.rawValue).getDocuments { (querySnapShot, error) in
            if let error = error {
                print("Error retrieving \(type.rawValue): \(error.localizedDescription)")
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No documents pulled")
                return
            }
            
            results = documents.compactMap({ queryDocumentSnapShot -> T? in
                do {
                    return try queryDocumentSnapShot.data(as: T.self)
                }
                catch {
                    print("There was an error in decoding the data: \(error.localizedDescription)")
                    return nil
                }
            })
            completion(results)
        }
    }
    
    func getDocuments<T:Codable>(for type: Collections, from data: T.Type = T.self, whereField field: String, contains: String, completion: @escaping (_ res: [T]) -> Void){
        var results: [T] = .init()
        
        restaurantRef.collection(type.rawValue).whereField(field, arrayContains: contains).getDocuments { (querySnapShot, error) in
            if let error = error {
                print("Error retrieving \(type.rawValue): \(error.localizedDescription)")
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No documents pulled")
                return
            }
            
            results = documents.compactMap({ queryDocumentSnapShot -> T? in
                do {
                    return try queryDocumentSnapShot.data(as: T.self)
                }
                catch {
                    print("There was an error in decoding the data: \(error.localizedDescription)")
                    return nil
                }
            })
            completion(results)
        }
    }
}

enum Collections: String {
    case menuItems = "MenuItems"
    case menuItemOptions = "MenuItemOptions"
    case menuItemPrerequisites = "MenuItemPrerequisites"
    case drinks = "Drinks"
    case drinkPrerequisites = "DrinkPrerequisites"
    case categories = "Categories"
    case restaurants = "Restaurants"
}

extension AuthErrorCode {
    var errorMessage: String {
        switch(self){
        case .invalidEmail:
            return "Invalid Email"
        case .wrongPassword:
            return "Wrong Password"
        case .userDisabled:
            return "User Disabled"
        case .emailAlreadyInUse:
            return "Email already in use"
        case .weakPassword:
            return "Weak Passwors"
        case.userNotFound:
            return "User not found"
        case .tooManyRequests:
            return "Access disabled, try again later"
        default:
            return "Unknown error occurred"
        }
    }
}
