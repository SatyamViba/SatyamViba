//
//  DataManager.swift
//  Viba
//
//  Created by Satyam Sutapalli on 03/12/21.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}

    var usrImage: String?
    var userId: String?
    var fullName: String?

    func clear() {
        usrImage = nil
        userId = nil
        fullName = nil
    }
}
