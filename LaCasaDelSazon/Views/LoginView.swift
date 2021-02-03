//
//  LoginView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authentication: AuthenticationViewModel
    @State private var presentSignUpSheet: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack {
                    Text("Bienvenidos!")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                Image("SazonLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                
                HStack {
                    Text("Login")
                    Spacer()
                }
                CustomTextFieldView(content: $authentication.signInEmail, placeholder: "Email", type: .nonSecure)
                CustomTextFieldView(content: $authentication.signInPassword, placeholder: "Password", type: .secure)
                RegularButtonView(text: "Login", textColor: .white, buttonColor: authentication.signInButton ? .gray : .red) {
                    authentication.signIn()
                }
                    .disabled(authentication.signInButton)
                RegularButtonView(symbolImage: "applelogo", text: "Continue with apple", textColor: .white, buttonColor: .black) {}
//                RegularButtonView(image: Image("google"), text: "Continue with Google", textColor: .white, buttonColor: Color(#colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1))) {}
                
                GoogleButton()
                    .frame(width: UIScreen.screenWidth * 0.9)                
                VStack {
                    HStack {
                        Text("Don't have an account?")
                        Text("Create an account")
                            .foregroundColor(.red)
                            .onTapGesture {
                                presentSignUpSheet.toggle()
                            }
                            .sheet(isPresented: $presentSignUpSheet, content: {
                                SignUpView()
                            })
                    }
                    Text("OR")
                    Text("Continue as guest")
                        .foregroundColor(.red)
                }
                .font(.subheadline)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear{
            authentication.signInPublishers()
        }
        .padding(UIScreen.padding)
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
