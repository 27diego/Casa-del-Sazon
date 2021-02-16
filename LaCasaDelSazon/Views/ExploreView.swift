//
//  ExploreView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @State var menuSelection: String = "Menu"
    @EnvironmentObject var restaurant: RestaurantViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Menu")
                    .bold()
                    .opacity(menuSelection == "Menu" ? 1 : 0.4)
                    .onTapGesture {
                        withAnimation(.default){
                            menuSelection = "Menu"
                        }
                    }
                
                Spacer()
                
                Text("Reservations")
                    .bold()
                    .opacity(menuSelection == "Reservations" ? 1 : 0.4)
                    .onTapGesture {
                        withAnimation(.default){
                            menuSelection = "Reservations"
                        }
                    }
            }
            .font(.largeTitle)
            .padding([.leading, .trailing], UIScreen.padding)
            
            Group {
                if menuSelection == "Menu" {
                    MenuView(restaurantId: restaurant.restaurantId)
                }
                else {
                    ReservationView()
                }
            }
            .transition(.slide)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
