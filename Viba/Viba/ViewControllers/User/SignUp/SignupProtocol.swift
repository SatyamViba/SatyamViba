//
//  SignupProtocol.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import Foundation

enum SignupScreens {
    case employeeDetails
    case verify
    case faceCapture
}

protocol SignupProtocol: AnyObject {
    func didFinish(screen: SignupScreens)
    func selectDate(onCompletion: @escaping ((Date) -> Void))
}
