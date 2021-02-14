//
//  LocationChooserViewModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation
import MapKit
import SwiftUI
import Combine
import CoreData

class LocationChooserViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.506900, longitude: -121.763223), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
    @Published var selectedRestaurant: String = ""
    @Published var menuSize: CGFloat = .zero
    @Published var menuPosition: CGFloat = .zero
    @Published var expandedMenu: Bool = false
    @Published var restaurantIsSelected: Bool = false {
        didSet {
            if restaurantIsSelected == false {
                checkList()
            }
        }
    }
    
    private var cancellable: AnyCancellable?
    
    private var user: User?
    private var context = PersistenceController.shared.container.viewContext
    
    init(){
        checkRestaurant()
    }
    
    private func checkList() {
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        if let results = try? context.fetch(request) {
            if results.count == 0 {
                FirestoreService.shared.updateRestaurants()
                print("Updating with Firestore, \(results.count)")
            }
        }
    }
    
    private func setupPublisher() {
        cancellable = $expandedMenu
            .sink(receiveValue: { res in
                if res == true {
                    withAnimation {
                        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.506900, longitude: -121.763223), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
                        
                        self.selectedRestaurant = ""
                    }
                }
            })
    }
    
    func checkRestaurant() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = []
        
        if let user = try? context.fetch(request).first {
            if let restaurantId = user.restaurantId {
                selectedRestaurant = restaurantId
                self.restaurantIsSelected = true
                return
            }
            else {
                self.user = user
            }
        }
        setupPublisher()
        checkList()
    }
    
    func confirmRestaurant(){
        if let user = self.user {
            user.restaurantId = selectedRestaurant
            do {
                try context.save()
            } catch {
                print("Could not save to Core Data")
                if context.hasChanges {
                    context.rollback()
                }
            }
        }
        restaurantIsSelected = true
    }
}

