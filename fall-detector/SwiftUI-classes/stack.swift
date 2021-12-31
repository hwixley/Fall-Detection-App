//
//  stack.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

struct BackgroundStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            .background(.black)
    }
}
