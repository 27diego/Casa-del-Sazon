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
    @Binding var isSheetOpen: Bool
    
    var body: some View {
        NavigationView {
            ZStack{
                if authentication.inProgress {
                    ProgressView()
                        .zIndex(50)
                }
                
                if authentication.showError {
                    VStack{
                        Spacer()
                        NotificationBanner(text: authentication.error)
                    }
                    .zIndex(100)
                }
                ScrollView(showsIndicators: false){
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
                        CustomTextFieldView(content: $authentication.signInEmail, placeholder: "Email", type: .nonSecure)
                            .keyboardType(.emailAddress)
                        CustomTextFieldView(content: $authentication.signInPassword, placeholder: "Password", type: .secure)
                        RegularButtonView(text: "Login", textColor: .white, buttonColor: authentication.signInButton ? .gray : .red) {
                            authentication.signIn()
                            withAnimation(.spring()) {
                                authentication.inProgress = true
                            }
                        }
                        .disabled(authentication.signInButton)
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
                                    authentication.signInAnonymously()
                                }
                        }
                        .font(.subheadline)
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .sheet(isPresented: $presentSignUpSheet, onDismiss: {
                    isSheetOpen = false
                }) {
                    SignUpView(presentSignUpSheet: $presentSignUpSheet, isSheetOpen: $isSheetOpen)
                        .environmentObject(authentication)
                }
                .padding([.leading, .trailing], UIScreen.padding)
                .blur(radius: authentication.inProgress ? 30 : 0)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            authentication.signInPublishers()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isSheetOpen: .constant(false))
    }
}
