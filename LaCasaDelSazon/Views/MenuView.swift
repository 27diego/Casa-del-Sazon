//
//  MenuView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/12/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var restaurant: RestaurantViewModel
    @FetchRequest var menuItems: FetchedResults<MenuItem>
    
    @State var selectedCategory = "all"
    @State var presentSheet = false
    @State var selectedItem = ""
    
    init(restaurantId: String) {
        self._menuItems = FetchRequest(fetchRequest: MenuItem.fetchByRestaurant(id: restaurantId))
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CartButtonView()
                }
                .padding()
            }
            .padding()
            .zIndex(1)
            
            VStack {
                MenuCategoriesView(selectedCategory: $selectedCategory, id: restaurant.restaurantId)
                Spacer()
                    .frame(height: 20)
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(Array(menuItems)){ item in
                            MenuItemView(menuItem: item)
                                .onTapGesture {
                                    restaurant.selectedItem = item.identifier ?? "no id"
                                    if item.hasOptions || item.hasPrerequisites {
                                        presentSheet.toggle()
                                    }
                                }
                                .fullScreenCover(isPresented: $presentSheet) {
                                    LazyView(MenuItemPrereqsView(itemId: restaurant.selectedItem, presentSheet: $presentSheet).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
                                }
                        }
                        Spacer()
                            .frame(height: 10)
                    }
                    .padding(.horizontal, 5)
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
            .padding(.horizontal, UIScreen.padding)
        }
    }
}


struct MenuItemView: View {
    var menuItem: MenuItem
    @State var tapped = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(menuItem.title)
                            .bold()
                        if menuItem.overview != "" {
                            Spacer()
                                .frame(height: 20)
                            Text(menuItem.overview)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(menuItem.price)")
                    .font(.system(size: 14))
                Spacer()
                    .frame(height: menuItem.overview != "" ? 40 : 20)
                Image(systemName: "suit.heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(tapped ? .red : Color(.systemGray3))
                    .onTapGesture {
                        tapped.toggle()
                    }
            }
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)))
        .cornerRadius(7)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct CartButtonView: View {
    @State var tapped = false
    var body: some View {
        Image(systemName: "cart")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .background(Circle().foregroundColor(.green).frame(width: 50, height: 50).background(Circle().stroke(lineWidth: 3).foregroundColor(.green).frame(width: 60, height: 60)))
            .onTapGesture {
                tapped.toggle()
            }
            .sheet(isPresented: $tapped) {
                Button("Go Back") {
                    tapped.toggle()
                }
            }
    }
}
