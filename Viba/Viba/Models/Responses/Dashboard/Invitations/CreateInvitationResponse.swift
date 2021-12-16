//
//  CreateInvitationResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 07/12/21.
//

import Foundation

// MARK: - CreateInvitationResponse
struct CreateInvitationResponse: Decodable {
    let cancelled: Bool?
    let visitorID: String?
    let id, name, email, phone: String?
    let purpose, createdBy: String?
    let start, end: Date?
    let versionID: String?
    let qrCode: String?

    enum CodingKeys: String, CodingKey {
        case cancelled
        case visitorID = "visitor_id"
        case id = "_id"
        case name, email, phone, purpose, start, end
        case createdBy = "created_by"
        case versionID = "version_id"
        case qrCode = "qr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cancelled = try container.decodeIfPresent(Bool.self, forKey: .cancelled)
        self.visitorID = try container.decodeIfPresent(String.self, forKey: .visitorID)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.purpose = try container.decodeIfPresent(String.self, forKey: .purpose)
        self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
        self.versionID = try container.decodeIfPresent(String.self, forKey: .versionID)
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode)
        self.start = try container.decodeIfPresent(String.self, forKey: .start)?.toDate
        self.end = try container.decodeIfPresent(String.self, forKey: .end)?.toDate
    }
}
