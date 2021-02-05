//
//  SettingsView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var Authentication: AuthenticationViewModel
    var body: some View {
        Form {
            Section {
                Button("Sign Out") {
                    Authentication.signOut()
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
