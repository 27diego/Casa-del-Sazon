//
//  ExploreViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import Foundation

class Restaurant: ObservableObject {
    let firestoreService: FirestoreService
    private var restaurantId: String
    
    init(id: String){
        firestoreService = FirestoreService.shared
        self.restaurantId = id
        setUpCategories()
    }
    
    private func setUpCategories(){
        firestoreService.setCategories(for: restaurantId)
    }
}
