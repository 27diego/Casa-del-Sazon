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
    @Published var restaurantIsSelected: Bool = false
    
    private var cancellable: AnyCancellable?
    
    private var user: User?
    private var context = PersistenceController.shared.container.viewContext
    
    // MARK: - Current active restaurants
    var restaurants: [RestaurantModel] = [
        RestaurantModel(id: "Sazon438", coordinate: .init(latitude: 36.67086, longitude: -121.65594), image: "SazonLogo", name: "La Casa Del Sazon 2", address: "438 Salinas St, Salinas, CA", openingTime: "11", closingTime: "9pm"),
        RestaurantModel(id: "Sazon22", coordinate: .init(latitude: 36.66314, longitude: -121.65870), image: "SazonLogo", name: "La Casa Del Sazon", address: "22 W Romie Ln, Salinas, CA", openingTime: "11", closingTime: "8pm"),
        RestaurantModel(id: "Sazon431", coordinate: .init(latitude: 36.59892, longitude: -121.89333), image: "SazonExpressLogo", name: "Sazon Express", address: "431 Tyler St, Monterey, CA", openingTime: "4", closingTime: "9pm")
    ]
    
    init(){
        checkRestaurant()
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

