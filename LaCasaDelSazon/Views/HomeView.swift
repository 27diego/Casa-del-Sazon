//
//  HomeView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var restaurant: RestaurantViewModel = RestaurantViewModel()
    var restaurantId: String
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
        .onAppear {
            restaurant.restaurantId = restaurantId
        }
        .navigationBarBackButtonHidden(true)
        .environmentObject(restaurant)
    }
}
