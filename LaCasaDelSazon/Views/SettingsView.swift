//
//  SettingsView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var Session: SessionService
    var body: some View {
        Form {
            Section {
                Button("Sign Out") {
                    Session.signOut()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
