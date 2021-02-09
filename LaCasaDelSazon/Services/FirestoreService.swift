//
//  FirestoreService.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/8/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreService {
    static var shared = FirestoreService()
    let settings: FirestoreSettings
    let db: Firestore
    
    init(){
        FirebaseApp.configure()
        self.settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        self.db = Firestore.firestore()
        db.settings = self.settings
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
}
