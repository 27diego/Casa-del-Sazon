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
    init() {
        persistenceController = PersistenceController.shared
        FirebaseApp.configure()
    }
    


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// MARK: - Traditional route, safer??

//This goes inside struct
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
