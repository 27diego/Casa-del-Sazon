//
//  MenuItemPrereqsView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/17/21.
//

import SwiftUI

struct MenuItemPrereqsView: View {
    @EnvironmentObject var restaurant: RestaurantViewModel
    @FetchRequest var options: FetchedResults<MenuItemOptionsCollection>
    var itemId: String
    @Binding var presentSheet: Bool
    
    init(itemId: String, presentSheet: Binding<Bool>) {
        self.itemId = itemId
        self._presentSheet = presentSheet
        
        _options = FetchRequest(fetchRequest: MenuItemOptionsCollection.fetchByMenuItem(id: itemId))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Button("go back") {
                    presentSheet.toggle()
                }
                .onAppear {
                    restaurant.checkOptionsAndPrerequisites(for: itemId)
                }
             
                Divider()
                
                ScrollView {
                    VStack {
                        ForEach( Array(options.first?.options ?? Set<MenuItemOption>()) ) { item in
                            Text(item.title)
                        }
                    }
                }
                
                
                Divider()
                
                
            }
        }
    }
}

