//
//  OrderViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/24/21.
//

import Foundation

class OrderViewModel: ObservableObject, Order {
    internal var cart: [OrderItem : Int] = .init()
    @Published private(set) var selectedItem: OrderItem?
    
    @Published var numberOfItems: Int = 0
    @Published var overallPrice: Double = 0.0
    
    func addItem(item: MenuItem) {
        let newOrderItem = OrderItem(title: item.title, price: item.price, options: .init(), prereqs: .init())
        selectedItem = newOrderItem
    }
    
    func addOption(_ option: MenuItemOption, limit: Int) {
        if var item = selectedItem {
            item.modifyOptions(option, limit: limit)
        }
    }
    
    func addPrereq(_ prereq: MenuItemPrerequisite, limit: Int) {
        if var item = selectedItem {
            item.modifyPrerequisites(prereq, limit: limit)
        }
    }
    
    func addToCart(quantity: Int) {
        guard let item = selectedItem else { return }
        if cart[item] != nil {
            cart[item]! += quantity
        }
        else {
            cart[item] = 1
        }
        
        overallPrice += (item.price * Double(quantity))
        numberOfItems += quantity
        selectedItem = nil
    }
    
    func deleteFromCart(item: OrderItem) {
        guard let cartItem = cart[item] else { return }
        numberOfItems -= cartItem
        overallPrice -= (item.price * Double(cartItem))
        cart.removeValue(forKey: item)
    }
    
    func confirmCart() {
        // MARK: - Point of Sale code here
        clearCart()
        clearItem()
    }
    
    func clearCart() {
        cart = [:]
    }
    
    func clearItem() {
        selectedItem = nil
    }
    
    func selectedItemContainsContainsPrereq(title: String) -> Bool {
        if let item = selectedItem {
            if item.prereqs.contains(where: { prereq in prereq.title == title }) {
                return true
            }
        }
        
        return false
    }
    
    func selectedItemContainsContainsOption(title: String) -> Bool {
        if let item = selectedItem {
            if item.options.contains(where: { option in option.title == title }) {
                return true
            }
        }
        
        return false
    }
}

struct OrderItem: Hashable {
    internal init(title: String, price: Double, options: Set<OrderItem.OrderAddons>, prereqs: Set<OrderItem.OrderAddons>) {
        self.title = title
        self.price = price
        self.overAllPrice = price
        self.options = options
        self.prereqs = prereqs
    }
    
    let title: String
    let price: Double
    var overAllPrice: Double
    var options: Set<OrderAddons>
    var prereqs: Set<OrderAddons>
    
    struct OrderAddons: Hashable {
        let title: String
        let price: Double
    }
    
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.title == rhs.title && lhs.price == rhs.price && lhs.options == rhs.options && lhs.prereqs == rhs.prereqs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(price)
        hasher.combine(options)
        hasher.combine(prereqs)
    }
    
    // MARK: - Make generic
    
    mutating func modifyOptions(_ option: MenuItemOption, limit: Int) {
        let optionExists = options.contains(where: { orderOption in orderOption.title == option.title })
        print("entering function \(options.count), \(limit), \(optionExists)")
        if options.count < limit && !optionExists  {
            let newOption = OrderAddons(title: option.title, price: option.price)
            print("should be adding")
            options.insert(newOption)
            overAllPrice += newOption.price
        }
        else if optionExists {
            let item = options.firstIndex(where: { setOption in setOption.title == option.title })
            if let item = item {
                print("should be removing")
                options.remove(at: item)
                overAllPrice -= option.price
            }
        }
    }
    
    mutating func modifyPrerequisites(_ prereq: MenuItemPrerequisite, limit: Int) {
        let prereqExists = prereqs.contains(where: { orderPrepreq in orderPrepreq.title == prereq.title })
        if prereqs.count < limit && !prereqExists  {
            let newPrereq = OrderAddons(title: prereq.title, price: prereq.price)
            prereqs.insert(newPrereq)
            overAllPrice += newPrereq.price
        }
        else if prereqExists {
            let item = prereqs.firstIndex(where: { setPrereq in setPrereq.title == prereq.title })
            if let item = item {
                prereqs.remove(at: item)
                overAllPrice -= prereq.price
            }
        }
    }
}


protocol Order {
     // identifier : (order, quantity)
    var cart: [OrderItem : Int] { get set }
    var numberOfItems: Int { get set }
    
    var selectedItem: OrderItem? { get }
    var overallPrice: Double { get set }
    
    // add or delete items on cart
    func addItem(item: MenuItem) -> Void
    func addOption(_ option: MenuItemOption, limit: Int) -> Void
    func addPrereq(_ prereq: MenuItemPrerequisite, limit: Int) -> Void
    func addToCart(quantity: Int) -> Void
    func deleteFromCart(item: OrderItem) -> Void
    func confirmCart() -> Void
    func clearCart() -> Void
    func clearItem() -> Void
    
}
