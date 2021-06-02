//
//  MenuItemPrereqsView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/17/21.
//

import SwiftUI

struct MenuItemPrereqsView: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var restaurant: RestaurantViewModel
    @FetchRequest var options: FetchedResults<MenuItemOptionsCollection>
    @FetchRequest var prereqs: FetchedResults<MenuItemPrerequisiteCollection>
    
    @Binding var presentSheet: Bool
    
    @State var quantity = 1
    var menuItem: MenuItem
    
    init(menuItem: MenuItem, presentSheet: Binding<Bool>) {
        self.menuItem = menuItem
        self._presentSheet = presentSheet
        
        _options = FetchRequest(fetchRequest: MenuItemOptionsCollection.fetchByMenuItem(id: menuItem.identifier ?? "No ID"))
        _prereqs = FetchRequest(fetchRequest: MenuItemPrerequisiteCollection.fetchByMenuItem(id: menuItem.identifier ?? "No ID"))
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text(menuItem.title)
                    .font(.title2)
                    .bold()
                    
                Spacer()
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .onTapGesture {
                        presentSheet.toggle()
                    }
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if menuItem.overview != "" {
                        Spacer()
                            .frame(height: 5)
                        Text(menuItem.overview)
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        
                        Spacer()
                            .frame(height: 10)
                    }
                    
                    ForEach(prereqs){ collection in
                        Text(collection.title)
                            .font(.headline)
                            .bold()
                                                
                        Divider()
                        
                        ForEach(Array(collection.prerequisites ?? Set<MenuItemPrerequisite>())) { prereq in
                            RadioOption(prereq: prereq, limit: collection.allowedPrerequisites)
                        }
                    }
                    
                    ForEach(options) { collection in
                        Text(collection.title)
                            .font(.headline)
                            .bold()
                        
                        Divider()
                        
                        ForEach(Array(collection.options ?? Set<MenuItemOption>())) { option in
                            CheckBoxOption(option: option, limit: collection.allowedOptions)
                        }
                    }
                    
                    HStack {
                        HStack {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            }) {
                                Image(systemName: "minus")
                            }
                            Spacer()
                            Text("\(quantity)")
                            Spacer()
                            Button(action: {  quantity += 1 }) {
                                Image(systemName: "plus")
                            }
                        }
                        .padding()
                        .frame(width: UIScreen.screenWidth * 0.3)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                        
                        
                        Button(action: {
                            orderVM.addToCart(quantity: quantity)
                            presentSheet.toggle()
                        }){
                            Text("Add to Cart $\(orderVM.selectedItem.overAllPrice.removeZerosFromEnd())")
                                .bold()
                                .padding()
                        }
                        .frame(width: UIScreen.screenWidth*0.6)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                    }
                    .foregroundColor(.black)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            restaurant.checkOptionsAndPrerequisites()
            orderVM.addItem(item: menuItem)
        }
        .onDisappear {
            orderVM.clearItem()
        }
    }
}


struct RadioOption: View {
    @EnvironmentObject var orderVM: OrderViewModel
    
    var prereq: MenuItemPrerequisite
    var limit: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .foregroundColor(orderVM.selectedItemContainsContainsPrereq(title: prereq.title) ? .blue : .gray)
                    .frame(width: 18, height: 18)
                    .overlay(Circle().foregroundColor(.white).frame(width: orderVM.selectedItemContainsContainsPrereq(title: prereq.title) ? 9 : 16, height: orderVM.selectedItemContainsContainsPrereq(title: prereq.title) ? 9 : 16))
                
                Text(prereq.title)
                    .font(.callout)
                
                if prereq.price != 0 {
                    Spacer()
                    Text("$\(prereq.price.removeZerosFromEnd())")
                        .font(.footnote)
                }
            }
            HStack(alignment: .bottom) {
                Text(prereq.overview)
                    .font(.footnote)
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                orderVM.addPrereq(prereq, limit: limit)
            }
        }
        .padding(.trailing)
    }
}

struct CheckBoxOption: View {
    @EnvironmentObject var orderVM: OrderViewModel
    
    var option: MenuItemOption
    var limit: Int

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(lineWidth: 2)
                    .foregroundColor(orderVM.selectedItemContainsContainsOption(title: option.title) ? .blue : .gray)
                    .frame(width: 18, height: 18)
                    .overlay(Image(systemName: "checkmark").resizable().aspectRatio(contentMode: .fit).foregroundColor(orderVM.selectedItemContainsContainsOption(title: option.title) ? .blue : .white).frame(width: 13, height: 13))
                
                Text(option.title)
                    .font(.callout)
                
                Spacer()
                
                if option.price != 0 {
                    Spacer()
                    Text("$\(option.price.removeZerosFromEnd())")
                        .font(.footnote)
                }
            }
            HStack(alignment: .bottom) {
                Text(option.overview)
                    .font(.footnote)
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                orderVM.addOption(option, limit: limit)
            }
        }
        .padding(.trailing)
    }
}
