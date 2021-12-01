//
//  ProfileRequests.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import Foundation

class ProfileRequests {
    static func currentUser(onCompletion handler: @escaping ((Result<ProfileResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.currentUser.rawValue, params: EmptyRequest(), methodType: .get, completion: handler)
    }
}
