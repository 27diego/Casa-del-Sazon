//
//  StringExtensions.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/5/21.
//

import Foundation

extension String {
    func removeByAll(characters:[Character]) -> String {
        return String(self.filter({!characters.contains($0)}))
    }
}
