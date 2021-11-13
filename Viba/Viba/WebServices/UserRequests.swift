//
//  UserRequests.swift
//  Viba
//
//  Created by Satyam Sutapalli on 12/11/21.
//

import Foundation

class UserRequests {
    // MARK: - Login
    static func authenticteWithEmail(id: String, onCompletion handler: @escaping ((Result<Bool, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateEmailOtp.rawValue, params: EmailAuthentication(email: id), methodType: .post, completion: handler)
    }

    static func authenticteWithSms(id: String, onCompletion handler: @escaping ((Result<Bool, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateSmsOtp.rawValue, params: SmsAuthentication(phone: id), methodType: .post, completion: handler)
    }

    static func validateSmsOTP(otp: String, phone: String, onCompletion handler: @escaping ((Result<Bool, Error>) -> Void)) {

    }

    static func validateEmailOTP(otp: String, email: String, onCompletion handler: @escaping ((Result<Bool, Error>) -> Void)) {

    }

    // MARK: - Registration
    static func validateCompany(code: String, onCompletion handler: @escaping ((Result<CompanyDetails, Error>) -> Void)) {
        // handler(.failure(NSError(domain: "com.viba.viba", code: 324, userInfo: ["some": "some"])))
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateCompanyCode.rawValue, params: Company(code: code), methodType: .post, completion: handler)
    }

    static func registerUser(params: RegisterUserStep1, onCompletion handler: @escaping ((Result<Bool, Error>) -> Void)) {
        handler(.failure(NSError(domain: "com.viba.viba", code: 324, userInfo: ["some": "some"])))
        // NetworkManager.shared.fetchResponse(urlString: NetworkPath.registerStep1.rawValue, params: params, methodType: .post, completion: handler)
    }
}
