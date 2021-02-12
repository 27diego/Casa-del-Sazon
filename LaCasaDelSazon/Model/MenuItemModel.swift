//
//  MenuModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/12/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FSMenuItem: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var categories: [String]
    var description: String
    var favorites: Int
    var hasOptions: Bool
    var hasPrerequisites: Bool
    var image: Data?
    var ingredients: [String]?
    var orders: Int
    var price: Double
    var restaurant: [String]
    var timeForCompletion: Double?
    var title: String
    var type: String
}

struct FSMenuItemPrerequisite: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var allowedPrerequisites: Int
    var forItems: [String]
    var prerequisites: [ItemPrerequisite]
    var title: String
}

struct ItemPrerequisite: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var description: String
    var price: Double
    var title: String
}


struct FSMenuItemOptions: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var allowedOptions: Int
    var forItems: [String]
    var options: [ItemOptions]
    var title: String
}

struct ItemOptions: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var description: String
    var price: Double
    var title: String
}