//
//  ClockInOut.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import Foundation

struct ClockInOut: Codable {
    let geoLocation: GeoLocation

    enum CodingKeys: String, CodingKey {
        case geoLocation = "geo_location"
    }
}

// MARK: - GeoLocation
struct GeoLocation: Codable {
    let lat, lng: Double
}
