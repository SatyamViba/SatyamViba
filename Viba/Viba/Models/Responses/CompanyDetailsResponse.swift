//
//  CompanyDetailsResponse.swift
//  Viba
//
//  Created by Satyam Sutapalli on 12/11/21.
//

import Foundation

struct CompanyDetailsResponse: Decodable {
    let companyName, id: String
    let brandLogo: String
    let brandTitle: String

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case id = "_id"
        case brandLogo = "brand_logo"
        case brandTitle = "brand_title"
    }
}
