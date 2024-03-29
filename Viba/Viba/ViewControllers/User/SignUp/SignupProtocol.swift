//
//  SignupProtocol.swift
//  Viba
//
//  Created by Satyam Sutapalli on 10/11/21.
//

import UIKit

enum SignupScreens {
    case companyDetails
    case employeeDetails
    case verify
    case faceCapture(String)
}

protocol SignupProtocol: AnyObject {
    func didFinish(screen: SignupScreens)
    func selectDate(onCompletion: @escaping ((Date) -> Void))
    func showFaceView(onCompletion: @escaping ((FaceCropResult) -> Void))
}
