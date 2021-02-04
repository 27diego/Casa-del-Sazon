//
//  LaCasaDelSazonApp.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI
import Firebase
import GoogleSignIn
import SwiftUI

@main
struct LaCasaDelSazonApp: App {
    let persistenceController: PersistenceController
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let authenticationVM = AuthenticationViewModel.shared
    
    init() {
        persistenceController = PersistenceController.shared
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authenticationVM)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        let authenticationVM = AuthenticationViewModel.shared
        
        
        withAnimation(.spring()) {
            authenticationVM.inProgress = true
        }
        
        if let error = error {
            authenticationVM.handleFirebaseErrr(error: error as NSError)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (res, err) in
            if let error = error {
                authenticationVM.handleFirebaseErrr(error: error as NSError)
                return
            }
            
            
            
            authenticationVM.isSignedIn = true
            User.saveLogedUser(email: res?.user.email, name: res?.user.displayName, identifier: (res?.user.uid)!, context: PersistenceController.shared.container.viewContext)
            authenticationVM.inProgress = false
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
