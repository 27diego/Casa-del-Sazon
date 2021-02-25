//
//  OrderViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/24/21.
//

import Foundation

class OrderViewModel: ObservableObject {
    
}

struct OrderItem {
    let title: String
    let options: [OrderAddons]
    let prereqs: [OrderAddons]
    
    struct OrderAddons {
        let title: String
        let price: Double
    }
}
