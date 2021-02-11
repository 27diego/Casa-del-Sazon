//
//  SignUpView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI
import iPhoneNumberField

struct SignUpView: View {
    @EnvironmentObject var authentication: SessionService
    @Binding var presentSignUpSheet: Bool
    
    @ObservedObject var SignUp: SignUpViewModel
    
    init(SignUp: SignUpViewModel, presentSignUpSheet: Binding<Bool>){
        self.SignUp = SignUp
        self._presentSignUpSheet = presentSignUpSheet
    }
    
    var body: some View {
        ZStack{
            if authentication.showError {
                VStack{
                    Spacer()
                    NotificationBanner(text: authentication.error)
                }
                .zIndex(100)
            }
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.02)
                    Text("Sign Up!")
                        .font(.title)
                        .bold()
                    Text("Sign up to make ordering, reserving and collecting order history easier.")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                        .frame(height: UIScreen.screenHeight*0.10)
                    Group {
                        Text("Name")
                        CustomTextFieldView(content: $SignUp.name, placeholder: "Name", type: .nonSecure)
                        Text("Email")
                        CustomTextFieldView(content: $SignUp.email, placeholder: "Email", type: .nonSecure)
                            .keyboardType(.emailAddress)
                        Text("Password")
                        CustomTextFieldView(content: $SignUp.password, placeholder: "Password", type: .secure)
                        Text("Verify Password")
                        CustomTextFieldView(content: $SignUp.passwordVerification, placeholder: "Password", type: .secure)
                        Text("Phone")
                        
                        iPhoneNumberField(text: $SignUp.phone)
                            .maximumDigits(10)
                            .padding()
                            .background(Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)).opacity(0.40))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black.opacity(0.6)))
                            .frame(width: UIScreen.screenWidth * 0.9)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .keyboardType(.phonePad)
                    }
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.02)
                    RegularButtonView(text: "Sign Up", textColor: .white, buttonColor: SignUp.registerButton ? .gray : .red) {
                        withAnimation(.spring()) {
                            authentication.inProgress = true
                        }
                        SignUp.createUser() { isSignedIn in
                            if isSignedIn == true {
                                presentSignUpSheet = false
                            }
                        }
                    }
                    .disabled(SignUp.registerButton)
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.02)
                }
            }
        }
        .padding([.leading, .trailing], UIScreen.padding)
    }
}
