//
//  ContentView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var authentication: AuthenticationViewModel
    @State var isSheetOpen = false
    var body: some View {
//        if authentication.isSignedIn && isSheetOpen == false {
//            LocationChooserView()
//        }
//        else {
//            LoginView(isSheetOpen: $isSheetOpen)
//        }
        
        ExploreView()
    }
}
