//
//  LoginViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 1/29/21.
//

import Foundation
import Firebase
import Combine
import CoreData
import SwiftUI


class SessionService: ObservableObject {
    
    static let shared = SessionService()
    let firestoreService = FirestoreService.shared
    
    // MARK: - UI Publishers
    @Published var inProgress: Bool = false
    @Published var error: String = ""
    @Published var showError: Bool = false
    
    
    // MARK: - Signed in state
    @Published var isSignedIn: Bool = false
    var signedInAnonymously: Bool = false
    
    let context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        checkSignIn()
    }
    
    private func checkSignIn() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let _ = try? context.fetch(request).first {
            isSignedIn = true
        }
    }
    
    
    
    func signInAnonymously() {
        signedInAnonymously = true
        isSignedIn = true
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.handleFirebaseErr(error: error as NSError)
                return
            }
            
            if let results = authResult {
                User.saveLogedUser(email: results.user.email ?? nil, name: results.user.displayName ?? nil, identifier: results.user.uid, context: strongSelf.context)
                strongSelf.inProgress = false
                strongSelf.isSignedIn = true
            }
        }
    }
    
    func signOut() {
        
        let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
        if let results = try? context.fetch(request) {
            results.forEach { item in
                context.delete(item)
            }
        }
        
        PersistenceController.saveContext(context)
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            isSignedIn = false
            signedInAnonymously = false
            
            // MARK: - Handle this error
            try? Auth.auth().signOut()
        } catch {
            self.error = error.localizedDescription
            self.triggerError()
            print(error.localizedDescription)
        }        
    }
    
    // TODO: - create user with name and phone number
    func createUser(name: String, email: String, password: String, phone: String, completion: @escaping (_ isSignedIn: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.handleFirebaseErr(error: error as NSError)
                return
            }
            
            guard let authResult = authResult, error == nil else { return }
            
            User.saveLogedUser(email: authResult.user.email, name: name, phone: phone, identifier: authResult.user.uid, context: self.context)
            
            self.firestoreService.addUser(name: email, phone: phone, UID: authResult.user.uid)
            
            self.isSignedIn = true
            self.inProgress = false
            
            completion(self.isSignedIn)
        }
    }
}




extension SessionService {
    private func triggerError() {
        withAnimation(.easeInOut){
            showError = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            withAnimation(.easeInOut){
                self.showError = false
            }
            self.error = ""
        }
    }
    
    func handleFirebaseErr(error: NSError) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            self.error = errorCode.errorMessage
            
            self.inProgress = false
            triggerError()
        }
    }
}
