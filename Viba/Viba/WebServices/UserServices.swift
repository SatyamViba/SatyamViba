//
//  UserServices.swift
//  Viba
//
//  Created by Satyam Sutapalli on 12/11/21.
//

import Foundation

class UserServices {
    // MARK: - Sign In
    static func authenticate(type: AuthType, id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        switch type {
        case .email:
            authenticateWithEmail(id: id, onCompletion: handler)
        case .mobile:
            authenticateWithSms(id: id, onCompletion: handler)
        }
    }

    private static func authenticateWithEmail(id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.loginWithEmail.rawValue, params: EmailAuthentication(email: id), methodType: .post, completion: handler)
    }

    private static func authenticateWithSms(id: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.loginWithSms.rawValue, params: SmsAuthentication(phone: id), methodType: .post, completion: handler)
    }

    static func validateOtp(type: AuthType, id: String, otp: String, onCompletion handler: @escaping ((Result<LoginOTPResponse, Error>) -> Void)) {
        switch type {
        case .email:
            validateEmailOTP(otp: otp, email: id, onCompletion: handler)
        case .mobile:
            validateSmsOTP(otp: otp, phone: id, onCompletion: handler)
        }
    }

    private static func validateSmsOTP(otp: String, phone: String, onCompletion handler: @escaping ((Result<LoginOTPResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateSmsOtp.rawValue, params: ValidateSMSOtp(phone: phone, smsOtp: otp), methodType: .post, completion: handler)
    }

    private static func validateEmailOTP(otp: String, email: String, onCompletion handler: @escaping ((Result<LoginOTPResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateEmailOtp.rawValue, params: ValidateEmailOtp(email: email, emailOtp: otp), methodType: .post, completion: handler)

    }

    // MARK: - Sign Up
    static func validateCompany(code: String, onCompletion handler: @escaping ((Result<CompanyDetailsResponse, Error>) -> Void)) {
        // handler(.failure(NSError(domain: "com.viba.viba", code: 324, userInfo: ["some": "some"])))
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.validateCompanyCode.rawValue, params: Company(code: code), methodType: .post, completion: handler)
    }

    static func registerUser(params: RegisterUser, onCompletion handler: @escaping ((Result<UserRegistrrationDetails, Error>) -> Void)) {
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

    static func uploadPic(userId: String, image: String, onCompletion handler: @escaping ((Result<GeneralResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.uploadUserImage.rawValue + userId, params: UploadUserImage(image: image), methodType: .put, completion: handler)
    }
}
