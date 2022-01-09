//
//  CheckInOutListPerDayResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation

// MARK: - CheckInOutListPerDayResponse
struct CheckInOutListPerDayResponse: Decodable {
    var activities: [Activity]
    let checkin: CheckinObj?
}

// MARK: - Activity
struct Activity: Decodable {
    let id: String?
    let clockedOutAt, clockedInAt: Date?
    let mode: Mode?
    let temperature: Temperature?

    enum CodingKeys: String, CodingKey {
        case clockedOutAt = "clocked_out_at"
        case id = "_id"
        case clockedInAt = "clocked_in_at"
        case mode
        case temperature
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clockedOutAt = try container.decodeIfPresent(String.self, forKey: .clockedOutAt)?.toDate
        self.id = try container.decode(String.self, forKey: .id)
        self.clockedInAt = try container.decodeIfPresent(String.self, forKey: .clockedInAt)?.toDate
        self.mode = try container.decodeIfPresent(Mode.self, forKey: .mode)
        self.temperature = try container.decodeIfPresent(Temperature.self, forKey: .temperature)
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

// MARK: - Checkin
struct CheckinObj: Decodable {
    let userID, id, accountID: String?
    let clockedInStatus: String?
    let mode: Mode?
    let clockedOutAt, clockedInAt: Date?
    let geoLocation: GeoLocationObj?
    let hours: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case id = "_id"
        case accountID = "account_id"
        case clockedInAt = "clocked_in_at"
        case clockedInStatus = "clocked_in_status"
        case clockedOutAt = "clocked_out_at"
        case mode
        case geoLocation = "geo_location"
        case hours
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.accountID = try container.decodeIfPresent(String.self, forKey: .accountID)
        self.clockedInAt = try container.decodeIfPresent(String.self, forKey: .clockedInAt)?.toDate
        self.clockedOutAt = try container.decodeIfPresent(String.self, forKey: .clockedOutAt)?.toDate
        self.clockedInStatus = try container.decodeIfPresent(String.self, forKey: .clockedInStatus)
        self.mode = try container.decodeIfPresent(Mode.self, forKey: .mode)
        self.geoLocation = try container.decodeIfPresent(GeoLocationObj.self, forKey: .geoLocation)
        self.hours = try container.decodeIfPresent(String.self, forKey: .hours)
    }
}

// MARK: - GeoLocation
struct GeoLocationObj: Decodable {
    let clockin: Clockin?
    let clockout: Clockin?
}

// MARK: - Clockin
struct Clockin: Decodable {
    let lat, lng: Double?
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
