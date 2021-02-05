//
//  ExploreViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import Foundation

class Restaurant: ObservableObject {
    private var restaurantId: String
    
    init(id: String){
        self.restaurantId = id
    }
}
