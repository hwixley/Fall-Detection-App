//
//  CustomViewModifiers.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import Foundation
import SwiftUI

public let fontfamily = "DIN Alternate Bold"
private let textcolor = MyColours.t0

//MARK: Stacks

struct FullBackgroundStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            .background(MyColours.g0_r)
    }
}

struct BackgroundStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth, alignment: .top)
    }
}


//MARK: Padding

struct HPadding: ViewModifier {
    var pad: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.trailing, pad)
            .padding(.leading, pad)
    }
}

struct VPadding: ViewModifier {
    var pad: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.top, pad)
            .padding(.bottom, pad)
    }
}


//MARK: Text

struct DefaultText: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(textcolor)
            .font(Font.custom(fontfamily, size: size))
    }
}

struct ClassicText: ViewModifier {
    var height: CGFloat? = nil
    
    func body(content: Content) -> some View {
        content
            .modifier(HPadding(pad: 10))
            .modifier(DefaultText(size: 25))
            .frame(width: UIScreen.screenWidth - 20, height: height, alignment: .center)
            .multilineTextAlignment(.leading)
    }
}

struct ClassicButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(ClassicText(height: 70))
            .multilineTextAlignment(.center)
    }
}

struct ClassicSubButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(ClassicText(height: 50))
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
