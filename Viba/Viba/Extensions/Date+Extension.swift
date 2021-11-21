//
//  Date+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

extension Date {
    func subtract(years: Int) -> Date {
        guard let result =  Calendar.current.date(byAdding: .year, value: -(years), to: self) else {
            return Date()
        }
        
        return result
    }

    func formatToDateTime() -> String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return dtFormatter.string(from: self)
    }
}
