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

class FirestoreService {
    static var shared = FirestoreService()
    let settings: FirestoreSettings
    let db: Firestore
    let context: NSManagedObjectContext
    
    init(){
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        self.settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        self.db = Firestore.firestore()
        db.settings = self.settings
        
        context = PersistenceController.shared.container.viewContext
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
    
    func setCategories(for restaurant: String) -> [Categories] {
        var categories = [Categories]()
        db.collection("Restaurants").document("\(restaurant)").collection("Categories").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("There was an error retrieving categories: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No Categories pulled")
                return
            }
            
            categories = documents.compactMap({ queryDocumentSnapshot -> Categories? in
                do {
                    return try queryDocumentSnapshot.data(as: Categories.self)
                }
                catch {
                    print("There was an error \(error.localizedDescription)")
                    return nil
                }
            })
        }
        return categories
    }
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
