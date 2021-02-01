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

class AuthenticationViewModel: ObservableObject {
    // MARK: - Create User published variables
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var phone: String = ""
    var id = 0
    
    // MARK: - UI Publishers
    @Published var button: Bool = false
    
    // MARK: - Signed in state
    @Published var isSignedIn: Bool = false
    
    let cancellables = Set<AnyCancellable>()
    let context = PersistenceController.shared.container.viewContext
    
    // TODO: find way to cancel a cancellable
    
    private func createUserPublishers() {
        //listen to the 4 publishers
    }
    
    private func signInPublishers() {
        // listen to 2 publishers
    }
    
    private func signIn(){
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            // TODO: - Save user with saveUser()
        }
    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func checkSignIn() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let user = try? context.fetch(request).first {
            name = user.name
            email = user.email
            phone = user.phone
            isSignedIn = true
            id = Int(user.identifier)
        }
    }
    
    private func signOut() {
        let request = User.fetchUser(withId: id)
        if let user = try? context.fetch(request).first {
            do {
                context.delete(user)
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}


extension AuthenticationViewModel {
    private func saveUser(email: String, name: String, phone: String, identifier: Int){
        let user = User(context: context)
        user.email = email
        user.name = name
        user.phone = phone
        user.identifier = Int64(identifier)
        
        do {
            try context.save()
        }
        catch {
            print("Could not save new user |AuthenticationViewModel| : \(error.localizedDescription)")
        }
    }
}
