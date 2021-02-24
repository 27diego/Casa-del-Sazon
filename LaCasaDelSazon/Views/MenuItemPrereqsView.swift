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
                    
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(Array(options)) { collection in
                            Text(collection.title)
                            ForEach(Array(collection.options ?? Set<MenuItemOption>())) { option in
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    CheckBoxOption(option: option)
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
                                    RadioOption(prereq: prereq)
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


struct RadioOption: View {
    var prereq: MenuItemPrerequisite
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.gray)
                    .frame(width: 18, height: 18)
                
                Text(prereq.title)
                    .font(.callout)
                
                if prereq.price != 0 {
                    Spacer()
                    Text("\(prereq.price)")
                        .font(.footnote)
                }
            }
            HStack(alignment: .bottom) {
                Text(prereq.overview)
                    .font(.footnote)
            }
        }
        .padding(.trailing)
    }
}

struct CheckBoxOption: View {
    var option: MenuItemOption
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.gray)
                    .frame(width: 18, height: 18)
                
                Text(option.title)
                    .font(.callout)
                
                Spacer()
                
                if option.price != 0 {
                    Spacer()
                    Text("\(option.price)")
                        .font(.footnote)
                }
            }
            HStack(alignment: .bottom) {
                Text(option.overview)
                    .font(.footnote)
            }
        }
        .padding(.trailing)
    }
}
