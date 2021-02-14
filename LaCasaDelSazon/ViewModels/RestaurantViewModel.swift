//
//  ExploreViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import Foundation
import CoreData

class RestaurantViewModel: ObservableObject {
    let firestoreService: FirestoreService
    var restaurantId: String
    let context = PersistenceController.shared.container.viewContext
    
    init(id: String){
        firestoreService = FirestoreService.shared
        self.restaurantId = id
        
        setUpCategories()
    }
    
    private func setUpCategories(){
        let request = Restaurant.fetchByIdentifier(restaurantId)
        if let restaurant = try? context.fetch(request).first {
            if restaurant.menuItemCategories?.count ?? 0 < 0 {
                firestoreService.updateCategories(for: self.restaurantId)
            }
        }
    }
}
