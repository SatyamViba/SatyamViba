//
//  ClockInOut.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import Foundation

struct ClockInOutResponse: Encodable {
    let clockedOutAt, id, userID, accountID: String
    let clockedInAt: String
    let geoLocation: GeoLocation
    let mode: Mode
    let clockedInStatus: String

    enum CodingKeys: String, CodingKey {
        case clockedOutAt = "clocked_out_at"
        case id = "_id"
        case userID = "user_id"
        case accountID = "account_id"
        case clockedInAt = "clocked_in_at"
        case geoLocation = "geo_location"
        case mode
        case clockedInStatus = "clocked_in_status"
    }
}

// MARK: - Clock
struct Clock: Encodable {
    let lat, lng: Double
}

// MARK: - Mode
struct Mode: Encodable {
    let clockin, clockout: String
}
