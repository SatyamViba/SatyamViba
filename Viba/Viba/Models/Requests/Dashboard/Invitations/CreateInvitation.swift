//
//  CreateInvitation.swift
//  Viba
//
//  Created by Satyam Sutapalli on 07/12/21.
//

import Foundation

// MARK: - CreateInvitation
struct CreateInvitation: Encodable {
    let name, email, phone, purpose: String
    let start, end: String
}
