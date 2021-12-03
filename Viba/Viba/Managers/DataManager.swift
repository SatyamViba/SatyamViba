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

    private var _usrImage: String?

    var usrImage: String? {
        get {
            return _usrImage
        }
        set {
            _usrImage = newValue
        }
    }

    private var _userId = ""
    var userId: String {
        get {
            return _userId
        }
        set {
            _userId = newValue
        }
    }
    
    func clear() {
        usrImage = ""
    }
}
