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
    @Published var selectedItem = ""
    @Published var restaurantId = "" {
        didSet {
            setUpCategories()
            setUpMenuItems()
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
    
    private func setUpMenuItems() {
        if MenuItem.isEmpty(for: restaurantId, context: context) {
            print("Fetching menu items for restaurant: \(restaurantId)")
            firestoreService.updateMenuItems(for: restaurantId)
        }
        else {
            print("Has Menu Items")
        }
    }
    
    func checkOptionsAndPrerequisites() {
        firestoreService.getMenuItemPrerequisites(for: selectedItem)
        firestoreService.getMenuItemOptions(for: selectedItem)
    }
    
    func check() {
        let request = MenuItemPrerequisiteCollection.fetchByMenuItem(id: selectedItem)
        if let results = try? context.fetch(request) {
            results.forEach { result in
                print(result.title)
                print("sub list: ")
                result.prerequisites?.forEach({ prereq in
                    print(prereq.title)
                })
            }
        }
    }
}
