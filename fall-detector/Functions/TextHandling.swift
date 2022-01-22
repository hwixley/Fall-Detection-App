//
//  TextHandling.swift
//  fall-detector
//
//  Created by Harry Wixley on 22/01/2022.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidPass(_ pass: String) -> Bool {
    return NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[0-9]).{8,}$").evaluate(with: pass)
}
