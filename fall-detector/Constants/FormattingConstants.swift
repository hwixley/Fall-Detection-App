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
    
    static let p0 = Color(red: 187/255, green: 134/255, blue: 252/255, opacity: 1)
    static let p1 = Color(red: 55/255, green: 0/255, blue: 179/255, opacity: 1)
    
    static let t0 = Color(white: 1, opacity: 0.87)
    static let t1 = Color(white: 1, opacity: 0.6)
    static let t2 = Color(white: 1, opacity: 0.3)
    
    static let g_colours = [p0, p1]
    static let g = Gradient(colors: g_colours)
    static let g0 = LinearGradient(gradient: g, startPoint: .leading, endPoint: .trailing)
    static let g0_r = RadialGradient(gradient: Gradient(colors: [p0, p1]), center: .center, startRadius: 2, endRadius: 650)
    static let gb = LinearGradient(gradient: Gradient(colors: [MyColours.b0]), startPoint: .leading, endPoint: .trailing)
}
