//
//  text.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

private let fontfamily = "DIN Alternate Bold"
private let textcolor = Color.white

struct DefaultText: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(textcolor)
            .font(Font.custom(fontfamily, size: size))
    }
}

struct ClassicButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText(size: 25))
            .frame(width: UIScreen.screenWidth, height: 70, alignment: .center)
            .multilineTextAlignment(.center)
    }
}

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText(size: 40))
            .multilineTextAlignment(.center)
    }
}

struct SubtitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(DefaultText(size: 20))
    }
}

struct LabelText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(SubtitleText())
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
