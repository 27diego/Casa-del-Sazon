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
    let AuthenticationVM = AuthenticationViewModel.shared
    
    init() {
        persistenceController = PersistenceController.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(AuthenticationVM)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    let AuthenticationVM = AuthenticationViewModel.shared
    let firestoreService = FirestoreService.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
        
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
    
        withAnimation(.spring()) {
            AuthenticationVM.inProgress = true
        }
        
        if let error = error {
            AuthenticationVM.handleFirebaseErrr(error: error as NSError)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (res, err) in
            if let error = error {
                self.AuthenticationVM.handleFirebaseErrr(error: error as NSError)
                return
            }
            
            self.AuthenticationVM.isSignedIn = true
            User.saveLogedUser(email: res?.user.email, name: res?.user.displayName, identifier: (res?.user.uid)!, context: PersistenceController.shared.container.viewContext)
            self.firestoreService.addUser(name: (res?.user.displayName)!, phone: "", UID: (res?.user.uid)!)
            self.AuthenticationVM.inProgress = false
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
