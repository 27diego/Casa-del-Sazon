//
//  MockData.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/24/21.
//

import Foundation

struct OrderItem {
    let title: String
    let description: String
    let prereqs: Prereqs
    let options: Options
    let price: Double
    
    struct Prereqs: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let prereqs: [Prereq]
        
        struct Prereq: Identifiable, Hashable {
            let id = UUID()
            let title: String
            let description: String
            let price: Double
        }
    }
    
    struct Options: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let options: [Option]
        
        struct Option: Identifiable, Hashable {
            let id = UUID()
            let title: String
            let description: String
            let price: Double
        }
    }
    static let prerequisitesList = Prereqs(title: "Prerequisites", prereqs: [Prereqs.Prereq(title: "Black Whole Beans", description: "", price: 0.00), Prereqs.Prereq(title: "Pickled Carrots", description: "", price: 0.00), Prereqs.Prereq(title: "Mild Tomato Salsa", description: "", price: 0.00), Prereqs.Prereq(title: "No Beans", description: "", price: 0.00), Prereqs.Prereq(title: "Small Chips and Guacamole 8 oz.", description: "", price: 7.75), Prereqs.Prereq(title: "No Rice", description: "", price: 0.00), Prereqs.Prereq(title: "Cilantro", description: "", price: 0.00), Prereqs.Prereq(title: "Mexican Rice", description: "", price: 0.00)])
    
    static let optionsList = Options(title: "Toppings & Add ons", options: [
        Options.Option(title: "Black Whole Beans", description: "Pork meat cooked in our original homemade green sauce", price: 0.00), Options.Option(title: "Pickled Carrots", description: "", price: 0.00), Options.Option(title: "Mild Tomato Salsa", description: "", price: 0.00), Options.Option(title: "No Beans", description: "", price: 0.00), Options.Option(title: "Small Chips and Guacamole 8 oz.", description: "", price: 7.75), Options.Option(title: "No Rice", description: "", price: 0.00), Options.Option(title: "Cilantro", description: "", price: 0.00), Options.Option(title: "Mexican Rice", description: "", price: 0.00)])
    
    static let item = OrderItem(title: "Burritos", description: "Homemade tortilla chips topped with cheese, pico de gallo, and your choice of shredded chicken, shredded beef or simply plain", prereqs: prerequisitesList, options: optionsList, price: 15.99)
}
