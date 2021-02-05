//
//  HomeView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var RestaurantVM: Restaurant
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Image(systemName: "safari")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
