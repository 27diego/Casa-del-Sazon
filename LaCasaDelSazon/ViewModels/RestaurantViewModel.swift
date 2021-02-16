//
//  ExploreViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import Foundation
import CoreData

class RestaurantViewModel: ObservableObject {
    let firestoreService: FirestoreService = FirestoreService.shared
    @Published var restaurantId: String = "" {
        didSet {
            setUpCategories()
        }
    }
    let context = PersistenceController.shared.container.viewContext
    
    private func setUpCategories(){
        let request = Restaurant.fetchByIdentifier(restaurantId)
        if let restaurant = try? context.fetch(request).first {
            if restaurant.menuItemCategories?.count ?? 0 == 0 {
                print("Fetching for restaurant: \(restaurant)")
                firestoreService.updateCategories()
            }
            else {
                print("Has categories")
            }
        }
    }
}
