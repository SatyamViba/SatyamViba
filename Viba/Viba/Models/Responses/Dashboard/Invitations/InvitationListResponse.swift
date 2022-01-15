//
//  InvitationListResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/12/21.
//

import Foundation

struct  InvitationListResponse: Decodable {
    let data: InvitationListResponseData
    let hasNext: Bool
    let total: Int
}

// MARK: - InvitationListResponseElement
struct InvitationListResponseElement: Decodable {
    let id, name, phone, purpose: String?
    let start, end: Date?
    let clockin: ClockinObj?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, phone, purpose, start, end, image
        case clockin
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.purpose = try container.decodeIfPresent(String.self, forKey: .purpose)
        self.start = try container.decodeIfPresent(String.self, forKey: .start)?.toDate
        self.end = try container.decodeIfPresent(String.self, forKey: .end)?.toDate
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.clockin = try container.decodeIfPresent(ClockinObj.self, forKey: .clockin)
    }
}

// MARK: - Clockin
struct ClockinObj: Decodable {
    let id: String?
    let clockedOutAt, clockedInAt: Date?
    let temperature: Temperature?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case clockedOutAt = "clocked_out_at"
        case clockedInAt = "clocked_in_at"
        case temperature
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.clockedInAt = try container.decodeIfPresent(String.self, forKey: .clockedInAt)?.toDate
        self.clockedOutAt = try container.decodeIfPresent(String.self, forKey: .clockedOutAt)?.toDate
        self.temperature = try container.decodeIfPresent(Temperature.self, forKey: .temperature)
    }
}

typealias InvitationListResponseData = [InvitationListResponseElement]
