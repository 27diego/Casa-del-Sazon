//
//  GoogleSignInButton.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/1/21.
//

import SwiftUI
import GoogleSignIn

struct GoogleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .light
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController 
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
}
