//
//  CheckInOrgResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/12/21.
//

import Foundation

// MARK: - CheckInOrgResponse
struct CheckInOrgResponse: Decodable {
    let outsideOrg: Bool

    enum CodingKeys: String, CodingKey {
        case outsideOrg = "outside_org"
    }
}
