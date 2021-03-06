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
        
    init(){
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        self.settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        self.db = Firestore.firestore()
        db.settings = self.settings
        
        context = PersistenceController.shared.container.viewContext
        
        restaurantRef = db.collection("Restaurants").document("Sazon431")
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
            self.saveMenuItems(results)
        }
    }
    
    func updateMenuItems(for restaurantId: String){
        getDocuments(for: .menuItems, from: FSMenuItem.self, whereField: "restaurant", contains: restaurantId) { results in
            self.saveMenuItems(results, restaurantId: restaurantId)
        }
    }
    
    private func saveMenuItems(_ results: [FSMenuItem], restaurantId: String? = nil) {
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
        }
        
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinks() {
        getDocuments(for: .drinks, from: FSDrink.self) { results in
            results.forEach { result in
                let drink = Drink.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                drink.hasPrerequisites = result.hasPrerequisites
                drink.overview = result.description
                drink.price = result.price
                drink.title = result.title
                drink.type = result.type
                
                result.restaurant.forEach { restaurantFS in
                    let restaurant = Restaurant.findOrInsert(id: restaurantFS, context: self.context)
                    restaurant.addToDrinks(drink)
                }
                
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinks(for restaurantId: String) {
        let restaurant = Restaurant.findOrInsert(id: restaurantId, context: self.context)
        getDocuments(for: .drinks, from: FSDrink.self, whereField: "restaurant", contains: restaurantId) { results in
            results.forEach { result in
                let drink = Drink.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                drink.hasPrerequisites = result.hasPrerequisites
                drink.overview = result.description
                drink.price = result.price
                drink.title = result.title
                drink.type = result.type
                
                restaurant.addToDrinks(drink)
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinkPrerequisites() {
        getDocuments(for: .drinkPrerequisites, from: FSDrinkPrerequisites.self) { results in
            results.forEach { result in
                let collection = DrinkPrerequisiteCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                collection.allowedPrerequisites = result.allowedPrerequisites
                collection.title = result.title
                
                result.prerequisites.forEach { prerequisiteFS in
                    let prerequisite = DrinkPrerequisite.findOrInsert(withId: prerequisiteFS.id ?? "No ID", context: self.context)
                    prerequisite.overview = prerequisiteFS.description
                    prerequisite.price = prerequisiteFS.price
                    prerequisite.title = prerequisiteFS.title
                    collection.addToPrerequisites(prerequisite)
                }
                
                result.forItems.forEach { items in
                    let drink = Drink.findOrInsert(withId: items, context: self.context)
                    drink.addToPrerequisites(collection)
                }
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinkPrerequisites(for drinkId: String) {
        let drink = Drink.findOrInsert(withId: drinkId, context: self.context)
        getDocuments(for: .drinkPrerequisites, from: FSDrinkPrerequisites.self, whereField: "forItems", contains: drinkId) { results in
            results.forEach { result in
                let collection = DrinkPrerequisiteCollection.findOrInsert(withId: drinkId, context: self.context)
                collection.allowedPrerequisites = result.allowedPrerequisites
                collection.title = result.title
            
                result.prerequisites.forEach { prerequisiteFS in
                    let prerequisite = DrinkPrerequisite.findOrInsert(withId: prerequisiteFS.id ?? "No ID", context: self.context)
                    prerequisite.overview = prerequisiteFS.description
                    prerequisite.price = prerequisiteFS.price
                    prerequisite.title = prerequisiteFS.title
                    collection.addToPrerequisites(prerequisite)
                }
                
                drink.addToPrerequisites(collection)
            }
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinkCategories() {
        getDocuments(for: .drinkCategories, from: FSDrinkCategories.self) { results in
            results.forEach({ result in
                let category = DrinksCategory.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                category.category = result.category
                
                result.restaurant.forEach { restaurantFS  in
                    let restaurant = Restaurant.findOrInsert(id: restaurantFS , context: self.context)
                    restaurant.addToDrinkCategories(category)
                }
            })
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getDrinkCategories(for restaurantId: String) {
        let restaurant = Restaurant.findOrInsert(id: restaurantId, context: self.context
        )
        getDocuments(for: .drinkCategories, from: FSDrinkCategories.self) { results in
            results.forEach({ result in
                let category = DrinksCategory.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                category.category = result.category
                
                restaurant.addToDrinkCategories(category)
            })
        }
        PersistenceController.saveContext(self.context)
    }
    
    func getMenuItemPrerequisites(for menuItemId: String) {
        let menuItem = MenuItem.findOrInsert(withId: menuItemId, context: self.context)
        getDocuments(for: .menuItemPrerequisites, from: FSMenuItemPrerequisites.self, whereField: "forItems", contains: menuItemId) { results in
            results.forEach { result in
                let prerequisiteCollection = MenuItemPrerequisiteCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                prerequisiteCollection.allowedPrerequisites = result.allowedPrerequisites
                prerequisiteCollection.title = result.title
                
                result.prerequisites.forEach { FSPrereq in
                    let prerequisite = MenuItemPrerequisite.findOrInsert(withId: FSPrereq.identifier, context: self.context)
                    prerequisite.overview = FSPrereq.description
                    prerequisite.title = FSPrereq.title
                    prerequisite.price = FSPrereq.price
                    
                    prerequisiteCollection.addToPrerequisites(prerequisite)
                }
                
                menuItem.addToPrerequisites(prerequisiteCollection)
                
                PersistenceController.saveContext(self.context)
            }
        }
    }
    
    func getMenuItemPrerequisites() {
        getDocuments(for: .menuItemPrerequisites, from: FSMenuItemPrerequisites.self) { results in
            results.forEach { result in
                let prerequisiteCollecton = MenuItemPrerequisiteCollection.findOrInsert(withId: result.id ?? "No ID", context: self.context)
                prerequisiteCollecton.allowedPrerequisites = result.allowedPrerequisites
                prerequisiteCollecton.title = result.title
                
                result.prerequisites.forEach({ FSPrereq in
                    let prerequisite = MenuItemPrerequisite.findOrInsert(withId: FSPrereq.identifier, context: self.context)
                    prerequisite.price = FSPrereq.price
                    prerequisite.overview = FSPrereq.description
                    prerequisite.title = FSPrereq.title
                    
                    prerequisiteCollecton.addToPrerequisites(prerequisite)
                })
                
                result.forItems.forEach { itemId in
                    let menuItem: MenuItem = .findOrInsert(withId: itemId, context: self.context)
                    menuItem.addToPrerequisites(prerequisiteCollecton)
                }
                
                PersistenceController.saveContext(self.context)
            }
        }
        
    }
    
    func getMenuItemOptions(for menuItemId: String) {
        let menuItem = MenuItem.findOrInsert(withId: menuItemId, context: context)
        getDocuments(for: .menuItemOptions, from: FSMenuItemOptions.self, whereField: "forItems", contains: menuItemId) { results in
            results.forEach { result in
                let optionsCollection: MenuItemOptionsCollection = .findOrInsert(withId: menuItemId, context: self.context)
                optionsCollection.title = result.title
                optionsCollection.allowedOptions = result.allowedOptions
                
                result.options.forEach { FSOption in
                    let option = MenuItemOption.findOrInsert(withId: FSOption.identifier, context: self.context)
                    option.title = FSOption.title
                    option.overview = FSOption.description
                    option.price = FSOption.price
                
                    optionsCollection.addToOptions(option)
                }
                
                menuItem.addToOptions(optionsCollection)
                
                PersistenceController.saveContext(self.context)
            }
        }
    }
    
    func getMenuItemOptions() {
        getDocuments(for: .menuItemOptions, from: FSMenuItemOptions.self) { results in
            results.forEach { result in
                let optionsCollection: MenuItemOptionsCollection = .findOrInsert(withId: result.id ?? "No ID", context: self.context)
                optionsCollection.title = result.title
                optionsCollection.allowedOptions = result.allowedOptions
                
                result.options.forEach { FSOption in
                    let option = MenuItemOption.findOrInsert(withId: FSOption.identifier, context: self.context)
                    option.price = FSOption.price
                    option.title = FSOption.title
                    option.overview = FSOption.description
                    
                    optionsCollection.addToOptions(option)
                }
                
                result.forItems.forEach { itemId in
                    let menuItem = MenuItem.findOrInsert(withId: itemId, context: self.context)
                    menuItem.addToOptions(optionsCollection)
                }
                
                PersistenceController.saveContext(self.context)
            }
        }
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
    case drinkCategories = "DrinkCategories"
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
