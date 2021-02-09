//
//  ExploreView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @State var selectedCategory: String = "all"
    @State var menuSelection: String = "Menu"
    
    var body: some View {
        VStack {
            HStack {
                Text("Menu")
                    .bold()
                    .opacity(menuSelection == "Menu" ? 1 : 0.4)
                    .onTapGesture {
                        menuSelection = "Menu"
                    }
                
                Spacer()
                
                Text("Reservations")
                    .bold()
                    .opacity(menuSelection == "Reservations" ? 1 : 0.4)
                    .onTapGesture {
                        menuSelection = "Reservations"
                    }
            }
            .font(.largeTitle)
            .padding([.leading, .trailing], UIScreen.padding)
            
            MenuCategoriesView(selectedCategory: $selectedCategory)
        }
        .animation(.default)
    }
}


struct MenuCategoriesView: View {
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @Binding var selectedCategory: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
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
