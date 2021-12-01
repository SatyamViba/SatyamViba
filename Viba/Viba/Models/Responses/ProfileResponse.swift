//
//  ProfileResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import Foundation

struct ProfileResponse: Decodable {
    let role, status, id: String
    let firstName, lastName, email, phone: String
    let dob, joined, approvedAt: Date?
    let gender: String
    let image: String
    let customID, department, profileResponseDescription: String
    let account: Account

    var fullName: String {
        return firstName + " " + lastName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case role, status, joined, email, phone, dob, gender
        case image
        case approvedAt = "approved_at"
        case customID = "custom_id"
        case department
        case profileResponseDescription = "description"
        case account
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.role = try container.decode(String.self, forKey: .role)
        self.status = try container.decode(String.self, forKey: .status)
        self.id = try container.decode(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.dob = try container.decode(String.self, forKey: .dob).toDate
        self.joined = try container.decode(String.self, forKey: .joined).toDate
        self.approvedAt = try container.decode(String.self, forKey: .approvedAt).toDate
        self.gender = try container.decode(String.self, forKey: .gender)
        self.image = try container.decode(String.self, forKey: .image)
        self.customID = try container.decode(String.self, forKey: .customID)
        self.department = try container.decode(String.self, forKey: .department)
        self.profileResponseDescription = try container.decode(String.self, forKey: .profileResponseDescription)
        self.account = try container.decode(Account.self, forKey: .account)
    }
}

// MARK: - Account
struct Account: Decodable {
    let id, companyName, code: String
    let brandLogo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case companyName = "company_name"
        case code
        case brandLogo = "brand_logo"
    }
}
