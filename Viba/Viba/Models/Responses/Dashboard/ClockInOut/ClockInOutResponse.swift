//
//  ClockInOut.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import Foundation

// MARK: - ClockInOutResponse
struct ClockInOutResponse: Decodable {
    let clockedOutAt: String?
    let clockedInAt: String?
    let mode: Mode?
    let clockedInStatus: String?

    enum CodingKeys: String, CodingKey {
        case clockedOutAt = "clocked_out_at"
        case clockedInAt = "clocked_in_at"
        case mode
        case clockedInStatus = "clocked_in_status"
    }
}
