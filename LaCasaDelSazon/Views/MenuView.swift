//
//  MenuView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/12/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var restaurant: RestaurantViewModel
    @State var selectedCategory: String = "all"
    @ObservedObject var firestore = FirestoreService.shared
    var body: some View {
        VStack {
            MenuCategoriesView(selectedCategory: $selectedCategory, id: restaurant.restaurantId)
            
            ScrollView {
                VStack {
                    ForEach(firestore.menuItems){ item in
                        Text(item.id ?? "No Id")
                    }
                }
            }
        }
    }
}

struct MenuCategoriesView: View {
    @Binding var selectedCategory: String
    @FetchRequest var restaurant: FetchedResults<Restaurant>
    
    init(selectedCategory: Binding<String>, id: String) {
        self._selectedCategory = selectedCategory
        self._restaurant = FetchRequest(fetchRequest: Restaurant.fetchByIdentifier(id))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(Array(restaurant.first?.menuItemCategories ?? Set<MenuItemCategory>())) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category.category ? "all" : category.category
                    }, label: {
                        Text(category.category)
                            .fontWeight(.light)
                            .foregroundColor(selectedCategory == category.category ? .blue : .black)
                            .padding(10)
                            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9843137255, alpha: 1)))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(selectedCategory == category.category ? Color.blue : Color.black, lineWidth: 3)
                                    .overlay(
                                        Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(selectedCategory == category.category ? Color.blue : Color.black), alignment: .top
                                    ).cornerRadius(5)
                            )
                    })
                }
            }
            .padding([.leading, .trailing], UIScreen.padding)
        }
    }
}
