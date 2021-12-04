//
//  RegisterUser.swift
//  Viba
//
//  Created by Satyam Sutapalli on 12/11/21.
//

import Foundation

struct RegisterUser: Encodable {
    let dob, gender, email, accountID: String
    let firstName, lastName, phone: String

    enum CodingKeys: String, CodingKey {
        case dob, gender, email
        case accountID = "account_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
    }
}
