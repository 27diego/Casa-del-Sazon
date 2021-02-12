//
//  ExploreView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @EnvironmentObject var LocationChooser: LocationChooserViewModel
    @EnvironmentObject var Restaurant: RestaurantViewModel
    @State var menuSelection: String = "Menu"
    
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
                    MenuView()
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
