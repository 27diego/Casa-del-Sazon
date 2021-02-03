//
//  SignUpView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authentication: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.02)
            Text("Sign Up!")
                .font(.title)
                .bold()
            Text("Sign up to make ordering, reserving and collecting order history easier.")
            Spacer()
            Group {
                Text("Name")
                CustomTextFieldView(content: $authentication.createName, placeholder: "Name", type: .nonSecure)
                Text("Email")
                CustomTextFieldView(content: $authentication.createEmail, placeholder: "Email", type: .nonSecure)
                Text("Password")
                CustomTextFieldView(content: $authentication.createPassword, placeholder: "Password", type: .secure)
                Text("Phone")
                CustomTextFieldView(content: $authentication.createPhone, placeholder: "Phone Number", type: .nonSecure)
            }
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.02)
            RegularButtonView(text: "Sign Up", textColor: .white, buttonColor: authentication.registerButton ? .gray : .red) {
                authentication.createUser()
            }
                .disabled(authentication.registerButton)
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.02)
        }
        .onAppear {
            authentication.createUserPublishers()
        }
        .padding(UIScreen.padding)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
