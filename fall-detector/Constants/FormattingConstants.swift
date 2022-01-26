//
//  FormattingConstants.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import Foundation
import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

public struct MyColours {
    static let b0 = Color(red: 27/255, green: 27/255, blue: 27/255, opacity: 1)
    static let b1 = Color(red: 36/255, green: 36/255, blue: 36/255, opacity: 1)
    static let b2 = Color(red: 51/255, green: 51/255, blue: 51/255, opacity: 1)
    static let b3 = Color(red: 68/255, green: 68/255, blue: 68/255, opacity: 1)

    static let p0 = Color(red: 187/255, green: 134/255, blue: 252/255, opacity: 1)
    static let p0_t = Color(red: 187/255, green: 134/255, blue: 252/255, opacity: 0.75)
    static let p1 = Color(red: 55/255, green: 0/255, blue: 179/255, opacity: 1)
    static let p2 = Color(red: 150/255, green: 107/255, blue: 202/255)
    
    static let blue0 = Color(red: 104/255, green: 136/255, blue: 190/255, opacity: 1)
    static let blue0_t = Color(red: 104/255, green: 136/255, blue: 190/255, opacity: 0.75)
    
    static let t0 = Color(white: 1, opacity: 0.87)
    static let t1 = Color(white: 1, opacity: 0.6)
    static let t2 = Color(white: 1, opacity: 0.3)
    
    static let g_colours = [p0, blue0]
    static let g = Gradient(colors: g_colours)
    static let g0 = LinearGradient(gradient: g, startPoint: .leading, endPoint: .trailing)
    static let g0_t = LinearGradient(gradient: Gradient(colors: [p0_t, blue0_t]), startPoint: .leading, endPoint: .trailing)
    static let g0_r = RadialGradient(gradient: Gradient(colors: [p0, p1]), center: .center, startRadius: 2, endRadius: 650)
    static let gb = LinearGradient(gradient: Gradient(colors: [MyColours.b0]), startPoint: .leading, endPoint: .trailing)
    static let gb2 = LinearGradient(gradient: Gradient(colors: [MyColours.b3]), startPoint: .leading, endPoint: .trailing)
    static let gp0 = LinearGradient(gradient: Gradient(colors: [MyColours.p2]), startPoint: .leading, endPoint: .trailing)
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
