//
//  CategoryModel.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/12/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Categories: Codable, Identifiable {
    @DocumentID var id: String?
    var category: String
    var restaurant: [String]
}