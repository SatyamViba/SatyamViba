//
//  CheckInOutListPerDayResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation

// MARK: - CheckInOutListPerDayElement
struct CheckInOutListPerDayElement: Decodable {
    let clockedOutAt: Date?
    let id: String?
    let temperature: Temperature?
    let clockedInAt: Date?
    let mode: Mode?

    enum CodingKeys: String, CodingKey {
        case clockedOutAt = "clocked_out_at"
        case id = "_id"
        case temperature
        case clockedInAt = "clocked_in_at"
        case mode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clockedOutAt = try container.decodeIfPresent(String.self, forKey: .clockedOutAt)?.toDate
        self.id = try container.decode(String.self, forKey: .id)
        self.temperature = try container.decodeIfPresent(Temperature.self, forKey: .temperature)
        self.clockedInAt = try container.decode(String.self, forKey: .clockedInAt).toDate
        self.mode = try container.decodeIfPresent(Mode.self, forKey: .mode)
    }
}

// MARK: - Mode
struct Mode: Decodable {
    let clockin, clockout: Clock?
}

enum Clock: String, Decodable {
    case viba = "VIBA"
    case wfh = "WFH"
    case wfo = "WFO"
}

// MARK: - Temperature
struct Temperature: Decodable {
    let value: Double?
    let measure: String?

    var displayValue: String {
        if let val = value, let units = measure {
            return String(format: "%1.2f", val) + " " + units
        }

        return "-"
    }
}

typealias CheckInOutListPerDayResponse = [CheckInOutListPerDayElement]
