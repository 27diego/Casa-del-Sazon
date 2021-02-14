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

    @Published var menuItems = [FSMenuItem]()
    @Published var menuItemPrerequisites = [FSMenuItemPrerequisites]()
    @Published var menuItemOptions = [FSMenuItemOptions]()
    
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
        
        getMenuItems()
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
    
    func updateCategories(for restaurant: String) {
        getDocuments(for: .categories, from: FSCategories.self) { res in
            res.forEach { result in
                let category: MenuItemCategory = MenuItemCategory.findOrInsert(name: result.category, context: self.context)
                category.identifier =  result.id
                
                let restaurant = Restaurant.findOrInsert(id: restaurant, context: self.context)
                restaurant.addToMenuItemCategories(category)
                
                PersistenceController.saveContext(context: self.context)
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
                
                PersistenceController.saveContext(context: self.context)
            }
        }
    }
    
    
    func getMenuItems(){
        getDocuments(for: .menuItems, from: FSMenuItem.self) { res in
            self.menuItems = res
        }
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
    
    func getMenuItemPrerequisites() {
        getDocuments(for: .menuItemPrerequisites, from: FSMenuItemPrerequisites.self) { res in
            self.menuItemPrerequisites = res
        }
    }
    
    func getMenuItemOptions() {
        getDocuments(for: .menuItemOptions, from: FSMenuItemOptions.self) { res in
            self.menuItemOptions = res
        }
    }
}

extension FirestoreService {
    func getDocuments<T:Codable>(for type: Collections, from data: T.Type = T.self, completion: @escaping (_ res: [T]) -> Void){
        var results: [T] = .init()
        
        db.collection("Restaurants").document("Sazon431").collection(type.rawValue).getDocuments { (querySnapShot, error) in
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
