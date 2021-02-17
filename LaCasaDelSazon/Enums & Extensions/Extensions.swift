//
//  UIScreenExtension.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/1/21.
//

import SwiftUI

// MARK: - UI Screen Extensions
extension UIScreen {
    static var screenWidth: CGFloat = UIScreen.main.bounds.width
    static var screenHeight: CGFloat = UIScreen.main.bounds.height
    static var padding: CGFloat = 16
}

// MARK: - Stromg Extensions
extension String {
    func removeByAll(characters:[Character]) -> String {
        return String(self.filter({!characters.contains($0)}))
    }
}

// MARK: - Date Extensions
extension Date {
    static func getTodaysDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        
        return dayInWeek
    }
}

// MARK: - Double Extension
//extension Double {
//    func removeZerosFromEnd() -> String {
//        let number = String(self)
//        let firstAndLast = number.components(separatedBy: ".")
//        if firstAndLast.count < 2 {
//            return number
//        }
//        
//        
//    }
//}
