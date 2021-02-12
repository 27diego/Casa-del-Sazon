//
//  ExploreViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import Foundation

class RestaurantViewModel: ObservableObject {
    let firestoreService: FirestoreService
    private var restaurantId: String
    
    var categories: [Categories] = .init()
    
    init(id: String){
        firestoreService = FirestoreService.shared
        self.restaurantId = id
        
        setUpCategories()
    }
    
    private func setUpCategories(){
        categories = firestoreService.setCategories(for: restaurantId)
        print("Calling here")
    }
}
