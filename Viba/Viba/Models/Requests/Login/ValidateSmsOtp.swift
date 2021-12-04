//
//  ValidateSmsOtp.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import Foundation

struct ValidateSMSOtp: Encodable {
    let phone, smsOtp: String

    enum CodingKeys: String, CodingKey {
        case phone
        case smsOtp = "sms_otp"
    }
}
