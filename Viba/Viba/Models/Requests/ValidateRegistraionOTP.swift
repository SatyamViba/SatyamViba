//
//  ValidateRegistraionOTP.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

struct ValidateRegistraionOTP: Encodable {
    let smsOtp, emailOtp, userID: String

    enum CodingKeys: String, CodingKey {
        case smsOtp = "sms_otp"
        case emailOtp = "email_otp"
        case userID = "user_id"
    }
}
