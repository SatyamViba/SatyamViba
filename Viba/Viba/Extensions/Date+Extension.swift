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

    var toDateDisplayFormat: String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd-MMM-yyyy"
        return dtFormatter.string(from: self)
    }

    var toTimeDisplayFormat: String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "hh:mm a"
        return dtFormatter.string(from: self)
    }

    var toApiFormat: String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        return dtFormatter.string(from: self)
    }

    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    func setTimeAndFormat(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = hour
        components.minute = minute
        components.second = 0

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)

        let tempDate = calendar.date(from: components)!
        return formatter.string(from: tempDate)
    }
}
