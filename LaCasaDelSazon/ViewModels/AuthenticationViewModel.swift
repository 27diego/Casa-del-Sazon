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
    @Published var createEmail: String = ""
    @Published var createName: String = ""
    @Published var createPassword: String = ""
    @Published var createPhone: String = ""
    var id = ""
    
    // MARK: - Sign In published variables
    @Published var signInEmail: String = ""
    @Published var signInPassword: String = ""
    
    // MARK: - UI Publishers
    @Published var registerButton: Bool = false
    @Published var signInButton: Bool = false
    @Published var inProgress: Bool = true
    
    // MARK: - Signed in state
    @Published var isSignedIn: Bool = false
    
    let context: NSManagedObjectContext
    
    // TODO: find way to cancel a cancellable within set
    
    init() {
        context = PersistenceController.shared.container.viewContext
        checkSignIn()
    }
    
    func createUserPublishers() {
        Publishers.CombineLatest4($createEmail, $createName, $createPassword, $createPhone)
            .map { email, name, password, phone -> Bool in
                if self.verifyEmail(email) && self.verifyName(name) && self.verifyPassword(password) && self.verifyPhone(phone){
                    return false
                }
                return true
            }
            .assign(to: &$registerButton)
    }
    
    func signInPublishers() {
        Publishers.CombineLatest($signInEmail, $signInPassword)
            .map { email, password -> Bool in
                if self.verifyEmail(email) && self.verifyPassword(password) {
                    return false
                }
                return true
            }
            .assign(to: &$signInButton)
    }
    
    func signIn(){
        Auth.auth().signIn(withEmail: signInEmail, password: signInPassword) {[weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Could not sign in \(error.localizedDescription)")
                return
            }
            // TODO: - Save user with saveUser()
            if let results = authResult {
                User.saveLogedUser(email: results.user.email ?? nil, name: results.user.displayName ?? nil, identifier: results.user.uid, context: strongSelf.context)
                strongSelf.isSignedIn = true
            }
        }
    }
    
    func signOut() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            isSignedIn = false
        } catch {
            print(error.localizedDescription)
        }        
    }
    
    // TODO: - create user with name and phone number
    func createUser() {
        self.inProgress = true
        Auth.auth().createUser(withEmail: createEmail, password: createPassword) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.inProgress = false
                return
            }
            
            User.saveLogedUser(email: authResult?.user.email, name: self.createName, phone: self.createPhone, identifier: (authResult?.user.uid)!, context: self.context)
            
            self.isSignedIn = true
            self.inProgress = false
        }
    }
    
    private func checkSignIn() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let user = try? context.fetch(request).first {
            id = user.identifier
            isSignedIn = true
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
        if phone.count >= 10 && Int(phone) != nil {
            return true
        }
        return false
    }
}
