//
//  AuthResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/11/21.
//

import Foundation

struct AuthResponse: Decodable {
    let msg, token: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let image: String
    let id, role: String
    let pusher: Pusher

    enum CodingKeys: String, CodingKey {
        case image
        case id = "_id"
        case role, pusher
    }
}

// MARK: - Pusher
struct Pusher: Decodable {
    let appID, cluster: String

    enum CodingKeys: String, CodingKey {
        case appID = "app_id"
        case cluster
    }
}
