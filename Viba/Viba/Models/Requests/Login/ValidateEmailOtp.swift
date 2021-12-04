//
//  ValidateEmailOtp.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import Foundation

struct ValidateEmailOtp: Encodable {
    let email, emailOtp: String

    enum CodingKeys: String, CodingKey {
        case email
        case emailOtp = "email_otp"
    }
}
