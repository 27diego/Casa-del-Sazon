//
//  LaCasaDelSazonApp.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI

@main
struct LaCasaDelSazonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LocationChooserView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
