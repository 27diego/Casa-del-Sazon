//
//  ContentView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var Session: SessionService
    var body: some View {
        LoginView(login: LoginViewModel())
    }
}
