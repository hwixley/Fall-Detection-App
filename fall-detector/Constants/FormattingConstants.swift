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
    static let b0 = Color(red: 27/256, green: 27/256, blue: 27/256, opacity: 1)
    static let b1 = Color(red: 36/256, green: 36/256, blue: 36/256, opacity: 1)
    static let b2 = Color(red: 51/256, green: 51/256, blue: 51/256, opacity: 1)
    
    static let t0 = Color(white: 1, opacity: 0.87)
    static let t1 = Color(white: 1, opacity: 0.6)
    static let t2 = Color(white: 1, opacity: 0.3)
    
    static let g_colours = [Color.purple, Color.blue]
    static let g = Gradient(colors: g_colours)
    static let g0 = LinearGradient(gradient: g, startPoint: .leading, endPoint: .trailing)
    static let g0_s = LinearGradient(gradient: g, startPoint: .trailing, endPoint: .leading)
    static let gb = LinearGradient(gradient: Gradient(colors: [MyColours.b0]), startPoint: .leading, endPoint: .trailing)
}
