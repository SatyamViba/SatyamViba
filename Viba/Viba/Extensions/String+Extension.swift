//
//  String+Extension.swift
//  Viba
//
//  Created by Satyam Sutapalli on 13/11/21.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format: "SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }

    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{10}$"
        let testPhone = NSPredicate(format: "SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }

    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"   // 2021-12-01T08:44:42.912Z
        return dateFormatter.date(from: self)
    }
}
