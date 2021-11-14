//
//  ResendRegistrationOtp.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

struct ResendRegistrationOtp: Encodable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
