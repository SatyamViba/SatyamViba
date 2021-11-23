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
            return self
        }
        
        return result
    }

    func add(days: Int) -> Date {
        guard let result =  Calendar.current.date(byAdding: .day, value: days, to: self) else {
            return self
        }

        return result
    }

    func subtract(days: Int) -> Date {
        guard let result =  Calendar.current.date(byAdding: .day, value: -(days), to: self) else {
            return self
        }

        return result
    }

    func formatToDateTime() -> String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return dtFormatter.string(from: self)
    }

    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
      }

      func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
      }

      func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
      }
}
