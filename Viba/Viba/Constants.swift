//
//  Constants.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit

enum Colors {
    case vibaRed
    case vibaGreen
    case gradientBlue
    case btnBackground
    case floatPlaceholderColor
    case lightLabelColor
    case transparentBtnColor
    case textFieldBorderColor
    case btnSelected
    case btnUnselected
}

extension Colors {
    var value: UIColor {
        switch self {
        case .vibaRed:
            return UIColor("#FF0968")
        case .vibaGreen:
            return UIColor("#598941")
        case .gradientBlue:
            return UIColor("#8000FF")
        case .btnBackground:
            return UIColor("#FF0968")
        case .floatPlaceholderColor:
            return UIColor("#747474")
        case .lightLabelColor:
            return UIColor("#D0D0D0")
        case .transparentBtnColor:
            return UIColor("#FF0062")
        case .textFieldBorderColor:
            return UIColor("#747474")
        case .btnSelected:
            return UIColor("#8000FF")
        case .btnUnselected:
            return UIColor("#F2F2F2")
        }
    }
}

enum NetworkPath: String {
    // Login
    case loginWithEmail = "auth/send-email-otp/emp-mobile"
    case loginWithSms = "auth/send-otp/emp-mobile"
    case validateEmailOtp = "auth/validate-email-otp"
    case validateSmsOtp = "auth/validate-otp"
    // Registration
    case validateCompanyCode = "auth/validate-account-code"
    case registerStep1 = "users/create-s1"
    case uploadUserImage = "users/create-s2/"    // append account_id
    case validateRegistrationOtps = "auth/validate-otp-values"
    case resendRegistrationSmsOtp = "auth/resend-sms-otp"
    case resendRegisrtrationEmailOtp = "auth/resend-email-otp"
    // Dashboard
    // ClockInOut
    case isOutsideOrg = "users/is-outside-organization"
    case clockIn = "checkins/clock-in"
    case clockOut = "checkins/clock-out"
    case clockInOutListByDate = "checkins/get-by-date?date=" // 2021-11-26

    // Invitations
    case createInvitation = "invitations"
    case invitationsByDate = "invitations/get-by-date?page_index=1&page_size=100&date=" // 2021-12-08
    // Profile
    case currentUser = "users/me"
}

enum API: String {
    case baseUrl = "http://3.144.103.250:3000/api/v1/"
}

enum RequestMethod: String {
    case post
    case get
    case put
    case delete
    case head
}

enum ErrorCode: Int {
    case noNetwork = 1001
    case userAuthFailed = 1002
    case searverFailuer = 1003
    case badRequest = 1004
    case tokenInvalid = 1005
    case parsingIssue = 1006
}

extension Notification.Name {
    static let signOut = Notification.Name("SignOut")
    static let locationPermissionStatus = Notification.Name("LocationPermissionStatus")
//    static let userLoggedIn = Notification.Name("userLoggedIn")
//    static let notification3 = Notification.Name("notification3")
}

enum UserDefaultsKeys {
    case firstTime
    case companyId
    case selectedMenu
    case token

    var value: String {
        switch self {
        case .firstTime:
            return "FirstTime"
        case .companyId:
            return "CompanyId"
        case .selectedMenu:
            return "SelectedRow"
        case .token:
            return "Token"
        }
    }
}
