//
//  VerifyInputs.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation


class VerifyInputs {
    static func verifyEmail(_ email: String) -> Bool {
        if email.count > 0 && email.contains("@") && email.contains(".") {
            return true
        }
        return false
    }
    
    static func verifyName(_ name: String) -> Bool {
        if name.count > 2 {
            return true
        }
        return false
    }
    
    // TODO: - make password check stronger
    static func verifyPasswords(_ password: String, with verification: String) -> Bool {
        if password.count > 5 && password == verification {
            return true
        }
        return false
    }
    
    static func verifyPhone(_ phone: String) -> Bool {
        let strippedPhone = phone.removeByAll(characters: [" ", "(", ")", "-"])
        if strippedPhone.count >= 10 && Int(strippedPhone) != nil {
            return true
        }
        return false
    }
}
