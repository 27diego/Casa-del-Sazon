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
    
    static let shared = AuthenticationViewModel()
    
    // MARK: - Create User published variables
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var phone: String = ""
    var id = ""
    
    // MARK: - UI Publishers
    @Published var button: Bool = false
    
    // MARK: - Signed in state
    @Published var isSignedIn: Bool = false
    
    let context: NSManagedObjectContext
    
    // TODO: find way to cancel a cancellable
    
    init() {
        context = PersistenceController.shared.container.viewContext
        checkSignIn()
    }
    
    private func createUserPublishers() {
        Publishers.CombineLatest4($email, $name, $password, $phone)
            .map { email, name, password, phone -> Bool in
                if self.verifyEmail(email) && self.verifyName(name) && self.verifyPassword(password) && self.verifyPhone(phone){
                    return true
                }
                return false
            }
            .assign(to: &$button)
    }
    
    private func signInPublishers() {
        Publishers.CombineLatest($email, $password)
            .map { email, password -> Bool in
                if self.verifyEmail(email) && self.verifyPassword(password) {
                    return true
                }
                return false
            }
            .assign(to: &$button)
    }
    
    func signIn(){
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Could not sign in \(error.localizedDescription)")
                return
            }
            // TODO: - Save user with saveUser()
            if let results = authResult {
                User.saveLogedUser(email: results.user.email ?? nil, name: results.user.displayName ?? nil, identifier: results.user.uid, context: strongSelf.context)
            }
        }
    }
    
    // TODO: - create user with name and phone number
    func createUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            User.saveLogedUser(email: authResult?.user.email, name: self.name, phone: self.phone, identifier: (authResult?.user.uid)!, context: self.context)
        }
    }
    
    private func checkSignIn() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let user = try? context.fetch(request).first {
            id = user.identifier
            isSignedIn = true
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
    private func verifyEmail(_ email: String) -> Bool {
        if email.count > 0 && email.contains("@") && email.contains(".") {
            return true
        }
        return false
    }
    
    private func verifyName(_ name: String) -> Bool {
        if name.count > 2 {
            return true
        }
        return false
    }
    
    // TODO: - make password check stronger
    private func verifyPassword(_ password: String) -> Bool {
        if password.count > 5 {
            return true
        }
        return false
    }
    
    private func verifyPhone(_ phone: String) -> Bool {
        if phone.count >= 10 {
            return true
        }
        return false
    }
}
