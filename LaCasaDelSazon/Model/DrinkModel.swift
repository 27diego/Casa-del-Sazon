//
//  DrinkModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/12/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FSDrink: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var categories: [String]
    var description: String
    var hasPrerequisites: Bool
    var price: Double
    var restaurant: [String]
    var title: String
    var type: String
}

struct FSDrinkPrerequisites: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var allowedPrerequisites: Int
    var forItems: [String]
    var prerequisites: [FSDrinkPrerequisite]
    var title: String
}

 struct FSDrinkPrerequisite: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var description: String
    var price: Double
    var title: String
}
