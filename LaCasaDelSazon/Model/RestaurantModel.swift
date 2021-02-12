//
//  RestaurantModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/10/21.
//

import Foundation
import MapKit

struct RestaurantModel: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let image: String
    let name: String
    let address: String
    let openingTime: String
    let closingTime: String
}
