//
//  LoginView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var Session: SessionService
    @State private var presentSignUpSheet: Bool = false
    
    @ObservedObject var Login: LoginViewModel
    
    init(login: LoginViewModel){
        Login = login
    }
    
    var body: some View {
        ZStack{
            NavigationLink("", destination: LocationChooserView(), isActive: $Session.isSignedIn)
            if Session.inProgress {
                ProgressView()
                    .zIndex(50)
            }
            
            if Session.showError {
                VStack{
                    Spacer()
                    NotificationBanner(text: Session.error)
                }
                .zIndex(100)
            }
            VStack(spacing: 10){
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
                CustomTextFieldView(content: $Login.email, placeholder: "Email", type: .nonSecure)
                    .keyboardType(.emailAddress)
                CustomTextFieldView(content: $Login.password, placeholder: "Password", type: .secure)
                RegularButtonView(text: "Login", textColor: .white, buttonColor: Login.signInButton ? .gray : .red) {
                    Login.signIn()
                    withAnimation(.spring()) {
                        Session.inProgress = true
                    }
                }
                .disabled(Login.signInButton)
                RegularButtonView(symbolImage: "applelogo", text: "Continue with apple", textColor: .white, buttonColor: .black) {}
                RegularButtonView(image: Image("google"), text: "Continue with Google", textColor: .white, buttonColor: Color(#colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1))) {}
                    .disabled(true)
                    .overlay(GoogleButton().opacity(0.011))
                
                VStack {
                    HStack {
                        Text("Don't have an account?")
                        Text("Create an account")
                            .foregroundColor(.red)
                            .onTapGesture {
                                presentSignUpSheet.toggle()
                            }
                    }
                    Text("OR")
                    Text("Continue as guest")
                        .foregroundColor(.red)
                        .onTapGesture {
                            Session.signInAnonymously()
                        }
                }
                .font(.subheadline)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $presentSignUpSheet) {
                SignUpView(SignUp: SignUpViewModel(), presentSignUpSheet: $presentSignUpSheet)
                    .environmentObject(Session)
            }
            .padding([.leading, .trailing], UIScreen.padding)
            .blur(radius: Session.inProgress ? 30 : 0)
        }
    }
}

