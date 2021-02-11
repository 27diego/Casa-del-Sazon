//
//  SignupViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    let Session = SessionService.shared
    
    // MARK: - Create User published variables
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var passwordVerification: String = ""
    @Published var phone: String = ""
    @Published var registerButton: Bool = false
    
    init() {
        setupPublishers()
    }
    
    func setupPublishers() {
        //due to combineLatest limitations, nested a publisher to adhere to 4 publisher zips
        let passwordsPublisher = Publishers.CombineLatest($password, $passwordVerification)
        Publishers.CombineLatest4($email, $name, passwordsPublisher, $phone)
            .map { email, name, passwords, phone -> Bool in
                if VerifyInputs.verifyEmail(email) && VerifyInputs.verifyName(name) && VerifyInputs.verifyPasswords(passwords.0, with: passwords.1) && VerifyInputs.verifyPhone(phone){
                    return false
                }
                return true
            }
            .assign(to: &$registerButton)
    }
    
    func createUser(completion: @escaping (_ isSignedIn: Bool) -> Void)  {
        Session.createUser(name: name, email: email, password: password, phone: phone) { res in
            completion(res)
        }
    }
}
