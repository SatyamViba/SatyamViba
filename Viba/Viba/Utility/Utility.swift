//
//  Utility.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import Foundation

class Utility {
    static func getWish() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 0..<4:
            return "Hello"
        case 4..<12:
            return "Good morning"
        case 12..<16:
            return "Good afternoon"
        case 16..<24:
            return "Good evening"
        default:
            return "Hello"
        }
    }
}
