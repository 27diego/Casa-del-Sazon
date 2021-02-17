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
    @FetchRequest var menuItems: FetchedResults<MenuItem>

    init(restaurantId: String) {
        self._menuItems = FetchRequest(fetchRequest: MenuItem.fetchByRestaurant(id: restaurantId))
    }

    var body: some View {
        VStack {
            MenuCategoriesView(selectedCategory: $selectedCategory, id: restaurant.restaurantId)

            ScrollView {
                VStack(spacing: 50) {
                    ForEach(Array(menuItems)){ item in
                        MenuItemView(menuItem: item)
                    }
                }
            }
        }
    }
}

struct MenuCategoriesView: View {
    @Binding var selectedCategory: String
    @FetchRequest var categories: FetchedResults<MenuItemCategory>

    init(selectedCategory: Binding<String>, id: String) {
        self._selectedCategory = selectedCategory
        self._categories = FetchRequest(fetchRequest: MenuItemCategory.fetchByRestaurant(id: id))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(Array(categories)) { category in
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


struct MenuItemView: View {
    var menuItem: MenuItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(menuItem.title)
                    .font(.title2)
                Spacer()
                    .frame(height: 15)
                Text(menuItem.overview)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(menuItem.price)")
                Spacer()
                    .frame(height: 50)
                Image(systemName: "heart")
            }
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: UIScreen.screenWidth)
    }
}
