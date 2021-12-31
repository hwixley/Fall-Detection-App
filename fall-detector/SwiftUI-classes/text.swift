//
//  text.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

public let fontfamily = "DIN Alternate Bold"
public let textcolor = Color.white

struct DefaultText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(textcolor)
            .padding()
    }
}

struct ClassicButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText())
            .frame(width: UIScreen.screenWidth, height: 70, alignment: .center)
            .font(Font.custom(fontfamily, size: 25))
            .multilineTextAlignment(.center)
    }
}

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText())
            .font(Font.custom(fontfamily, size: 40))
            .multilineTextAlignment(.center)
    }
}

struct SubtitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText())
            .font(Font.custom(fontfamily, size: 20))
    }
}
