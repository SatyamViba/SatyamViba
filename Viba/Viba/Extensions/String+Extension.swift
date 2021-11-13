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
      let regularExpressionForPhone = "^\\d{12}$"
      let testPhone = NSPredicate(format: "SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}
