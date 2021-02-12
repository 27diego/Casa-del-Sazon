//
//  HomeView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var restaurant: RestaurantViewModel
    init(restaurant: RestaurantViewModel) {
        self.restaurant = restaurant
    }
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
        .environmentObject(restaurant)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
