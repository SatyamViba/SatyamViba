//
//  Date+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

extension Date {
    func removing(years: Int) -> Date {
        guard let result =  Calendar.current.date(byAdding: .year, value: -(years), to: self) else {
            return Date()
        }
        
        return result
    }
}
