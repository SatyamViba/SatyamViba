//
//  AuthResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

struct LoginOTPResponse: Decodable {
    let msg, token: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let image: String?
    let id, role: String
    let pusher: Pusher
    let firstName, lastName: String

    var fullName: String {
        return firstName + " " + lastName
    }

    enum CodingKeys: String, CodingKey {
        case image
        case id = "_id"
        case role, pusher
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - Pusher
struct Pusher: Decodable {
    let apiKey, cluster: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case cluster
    }
}
