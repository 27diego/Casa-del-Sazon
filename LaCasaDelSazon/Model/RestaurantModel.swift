//
//  RestaurantModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation
import MapKit
import FirebaseFirestoreSwift

struct RestaurantModel: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let image: String
    let name: String
    let address: String
    let openingTime: String
    let closingTime: String
}

struct FSRestaurant: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var phone: String
    var address: FSAddress
    var schedule: FSSchedule
}

struct FSAddress: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var city: String
    var state: String
    var street: String
    var zip: String
    var longitude: Int
    var latitude: Int
}

struct FSSchedule: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var Sunday: String
    var Monday: String
    var Tuesday: String
    var Wednesday: String
    var Thursday: String
    var Friday: String
    var Saturday: String
}
