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


class AuthenticationViewModel: ObservableObject {
    
    static let shared = AuthenticationViewModel()
    
    // MARK: - Create User published variables
    @Published var createEmail: String = ""
    @Published var createName: String = ""
    @Published var createPassword: String = ""
    @Published var createPasswordVerification: String = ""
    @Published var createPhone: String = ""
    var id = ""
    
    // MARK: - Sign In published variables
    @Published var signInEmail: String = ""
    @Published var signInPassword: String = ""
    
    // MARK: - UI Publishers
    @Published var registerButton: Bool = false
    @Published var signInButton: Bool = false
    @Published var inProgress: Bool = false
    @Published var error: String = ""
    @Published var showError: Bool = false
    
    
    // MARK: - Signed in state
    @Published var isSignedIn: Bool = false
    
    let context: NSManagedObjectContext
    
    // TODO: find way to cancel a cancellable within set
    
    init() {
        context = PersistenceController.shared.container.viewContext
        checkSignIn()
    }
    
    private func checkSignIn() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let user = try? context.fetch(request).first {
            id = user.identifier
            isSignedIn = true
        }
    }
    
    func createUserPublishers() {
        //due to combineLatest limitations, nested a publisher to adhere to 4 publisher zips
        let passwordsPublisher = Publishers.CombineLatest($createPassword, $createPasswordVerification)
        Publishers.CombineLatest4($createEmail, $createName, passwordsPublisher, $createPhone)
            .map { email, name, passwords, phone -> Bool in
                if self.verifyEmail(email) && self.verifyName(name) && self.verifyPasswords(passwords.0, with: passwords.1) && self.verifyPhone(phone){
                    return false
                }
                return true
            }
            .assign(to: &$registerButton)
    }
    
    func signInPublishers() {
        Publishers.CombineLatest($signInEmail, $signInPassword)
            .map { email, password -> Bool in
                if self.verifyEmail(email) && self.verifyPasswords(password, with: password) {
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
                strongSelf.handleFirebaseErrr(error: error as NSError)
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            isSignedIn = false
        } catch {
            self.error = error.localizedDescription
            self.triggerError()
            print(error.localizedDescription)
        }        
    }
    
    // TODO: - create user with name and phone number
    func createUser() {
        Auth.auth().createUser(withEmail: createEmail, password: createPassword) { authResult, error in
            if let error = error {
                self.handleFirebaseErrr(error: error as NSError)
                return
            }
            
            User.saveLogedUser(email: authResult?.user.email, name: self.createName, phone: self.createPhone, identifier: (authResult?.user.uid)!, context: self.context)
            
            self.isSignedIn = true
            self.inProgress = false
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
    private func verifyPasswords(_ password: String, with verification: String) -> Bool {
        if password.count > 5 && password == verification {
            return true
        }
        return false
    }
    
    private func verifyPhone(_ phone: String) -> Bool {
        let strippedPhone = phone.removeByAll(characters: [" ", "(", ")", "-"])
        print(strippedPhone)
        if strippedPhone.count >= 10 && Int(strippedPhone) != nil {
            return true
        }
        return false
    }
}


extension AuthenticationViewModel {
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
    
    func handleFirebaseErrr(error: NSError) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch(errorCode){
            case .invalidEmail:
                print("Invalid Email")
                self.error = "Invalid Email"
                break
            case .wrongPassword:
                print("Wrong Password")
                self.error = "Wrong Password"
                break
            case .userDisabled:
                print("User Disabled")
                self.error = "User Disabled"
                break
            case .emailAlreadyInUse:
                print("Email already in use")
                self.error = "Email already in use"
                break
            case .weakPassword:
                print("Weak Password")
                self.error = "Weak Passwors"
                break
            case.userNotFound:
                print("User Not Found")
                self.error = "User not found"
                break
            case .tooManyRequests:
                print("Too many requests")
                self.error = "Access disabled, try again later"
                break
            default:
                print("some other code")
                self.inProgress = false
                return
            }
            
            self.inProgress = false
            triggerError()
        }
    }
}


extension AuthenticationViewModel {
    func clearFields() {
        createEmail = ""
        createName = ""
        createPassword = ""
        createPasswordVerification = ""
        createPhone = ""
    }
}
