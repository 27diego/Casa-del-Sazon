//
//  SignUpView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI

struct SignUpView: View {
    var spacing: AppSpacing = AppSpacing()
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var phone: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
                .frame(height: spacing.screenHeight * 0.02)
            Text("Sign Up!")
                .font(.title)
                .bold()
            Text("Sign up to make ordering, reserving and collecting order history easier.")
            Spacer()
            Group {
                Text("Name")
                CustomTextFieldView(content: $name, placeholder: "Name", type: .nonSecure)
                Text("Email")
                CustomTextFieldView(content: $email, placeholder: "Email", type: .nonSecure)
                Text("Password")
                CustomTextFieldView(content: $password, placeholder: "Password", type: .secure)
                Text("Phone")
                CustomTextFieldView(content: $phone, placeholder: "Phone Number", type: .nonSecure)
            }
            Spacer()
                .frame(height: spacing.screenHeight * 0.02)
            RegularButtonView(text: "Sign Up", textColor: .white, buttonColor: .red) {}
            Spacer()
                .frame(height: spacing.screenHeight * 0.02)
        }
        .padding(spacing.padding)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
