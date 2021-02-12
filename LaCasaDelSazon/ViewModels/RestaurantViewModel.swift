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
    
    @Published var categories: [FSCategories] = .init()
    
    init(id: String){
        firestoreService = FirestoreService.shared
        self.restaurantId = id
        
        setUpCategories()
    }
    
    private func setUpCategories(){
        firestoreService.setCategories(for: restaurantId){ categories in
            self.categories = categories
        }
    }
}
