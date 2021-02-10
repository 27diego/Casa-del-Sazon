//
//  LoginViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    var session = AuthenticationViewModel.shared
    
    // MARK: - UI published variables
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var signInButton: Bool = false
    
    init() {
        signInPublishers()
    }
    
    func signInPublishers() {
        Publishers.CombineLatest($email, $password)
            .map { email, password -> Bool in
                if VerifyInputs.verifyEmail(email) && VerifyInputs.verifyPasswords(password, with: password) {
                    return false
                }
                return true
            }
            .assign(to: &$signInButton)
    }
    
    func signIn() {
        session.signIn(email: email, password: password)
    }
}
