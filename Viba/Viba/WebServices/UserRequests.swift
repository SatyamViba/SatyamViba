//
//  UserRequests.swift
//  Viba
//
//  Created by Satyam Sutapalli on 12/11/21.
//

import Foundation

class UserRequests {
    // MARK: - Login
    static func authenticate(type: AuthType, id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        switch type {
        case .email:
            authenticateWithEmail(id: id, onCompletion: handler)
        case .mobile:
            authenticateWithSms(id: id, onCompletion: handler)
        }
    }
    static func authenticateWithEmail(id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.loginWithEmail.rawValue, params: EmailAuthentication(email: id), methodType: .post, completion: handler)
    }

    static func authenticateWithSms(id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.loginWithSms.rawValue, params: SmsAuthentication(phone: id), methodType: .post, completion: handler)
    }

    static func validateOtp(type: AuthType, id: String, otp: String, onCompletion handler: @escaping ((Result<AuthResponse, Error>) -> Void)) {
        switch type {
        case .email:
            validateEmailOTP(otp: otp, email: id, onCompletion: handler)
        case .mobile:
            validateSmsOTP(otp: otp, phone: id, onCompletion: handler)
        }
    }

    static func validateSmsOTP(otp: String, phone: String, onCompletion handler: @escaping ((Result<AuthResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateSmsOtp.rawValue, params: ValidateSMSOtp(phone: phone, smsOtp: otp), methodType: .post, completion: handler)
    }

    static func validateEmailOTP(otp: String, email: String, onCompletion handler: @escaping ((Result<AuthResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateEmailOtp.rawValue, params: ValidateEmailOtp(email: email, emailOtp: otp), methodType: .post, completion: handler)

    }

    // MARK: - Registration
    static func validateCompany(code: String, onCompletion handler: @escaping ((Result<CompanyDetails, Error>) -> Void)) {
        // handler(.failure(NSError(domain: "com.viba.viba", code: 324, userInfo: ["some": "some"])))
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateCompanyCode.rawValue, params: Company(code: code), methodType: .post, completion: handler)
    }

    static func registerUser(params: RegisterUserStep1, onCompletion handler: @escaping ((Result<UserRegistrrationDetails, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.registerStep1.rawValue, params: params, methodType: .post, completion: handler)
    }

    static func validateRegistrationOtps(email: String, phone: String, userId: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        let paramObj = ValidateRegistraionOTP(smsOtp: phone, emailOtp: email, userID: userId)
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateRegistrationOtps.rawValue, params: paramObj, methodType: .post, completion: handler)
    }

    static func resendSmsOtp(userId: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.resendRegistrationSmsOtp.rawValue, params: ResendRegistrationOtp(userID: userId), methodType: .post, completion: handler)
    }

    static func resendEmailOtp(userId: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.resendRegisrtrationEmailOtp.rawValue, params: ResendRegistrationOtp(userID: userId), methodType: .post, completion: handler)
    }
}