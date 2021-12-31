//
//  text.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

struct ClassicButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .frame(width: UIScreen.screenWidth, height: 70, alignment: .center)
            .font(Font.custom("DIN Alternate Bold", size: 25))
            .multilineTextAlignment(.center)
    }
}

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .font(Font.custom("DIN Alternate Bold", size: 40))
            .multilineTextAlignment(.center)
    }
}

struct SubtitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .font(Font.custom("DIN Alternate Bold", size: 20))
    }
}
