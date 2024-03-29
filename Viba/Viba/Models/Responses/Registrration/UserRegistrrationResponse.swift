//
//  UserRegistrrationDetails.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

struct UserRegistrrationResponse: Decodable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
