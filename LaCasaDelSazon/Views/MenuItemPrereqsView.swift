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
    @FetchRequest var prereqs: FetchedResults<MenuItemPrerequisiteCollection>
    var itemId: String
    @Binding var presentSheet: Bool
    
    init(itemId: String, presentSheet: Binding<Bool>) {
        self.itemId = itemId
        self._presentSheet = presentSheet
        
        _options = FetchRequest(fetchRequest: MenuItemOptionsCollection.fetchByMenuItem(id: itemId))
        _prereqs = FetchRequest(fetchRequest: MenuItemPrerequisiteCollection.fetchByMenuItem(id: itemId))
    }
    
    var body: some View {
        VStack() {
            VStack {
                Button("go back") {
                    presentSheet.toggle()
                }
                .onAppear {
                    restaurant.checkOptionsAndPrerequisites()
                }
                
                ScrollView {
                    Text("Options")
                        .font(.title2)
                    
                    VStack(alignment: .leading){
                        ForEach(Array(options)) { collection in
                            Text(collection.title)
                            ForEach(Array(collection.options ?? Set<MenuItemOption>())) { option in
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    Text("\(option.title) --- \(option.price)")
                                }
                            }
                        }

                        Text("Prerequisites")
                            .font(.title2)
                        ForEach(Array(prereqs)) { collection in
                            Text(collection.title)
                            ForEach(Array(collection.prerequisites ?? Set<MenuItemPrerequisite>())) { prereq in
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    Text("\(prereq.title) --- \(prereq.price)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
}

