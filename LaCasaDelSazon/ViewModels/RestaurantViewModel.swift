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
        if MenuItemCategory.isEmpty(for: restaurantId, using: context){
            print("Fetching for restaurant: \(restaurantId)")
            firestoreService.updateCategories(for: restaurantId)
        }
        else {
            print("Has categories")
        }
    }
}
