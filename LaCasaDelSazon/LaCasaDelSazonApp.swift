//
//  LaCasaDelSazonApp.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

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
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil {
                print(err?.localizedDescription ?? "some error")
                return
            }
            
            let authenticationVM = AuthenticationViewModel.shared
            
            authenticationVM.isSignedIn = true
            User.saveLogedUser(email: res?.user.email, name: res?.user.displayName, identifier: (res?.user.uid)!, context: PersistenceController.shared.container.viewContext)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
