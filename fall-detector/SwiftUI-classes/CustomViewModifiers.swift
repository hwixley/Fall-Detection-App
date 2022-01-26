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
    @ObservedObject var appState: AppState
    let backPage: Page?
    
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth, alignment: .top)
            .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                        .onEnded({ value in
                if backPage != nil {
                    if value.translation.width > 0 {
                        appState.inappState.page = backPage!
                    }
                }
            }))
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
    var color: Color? = nil
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color ?? textcolor)
            .font(Font.custom(fontfamily, size: size))
    }
}

struct ClassicText: ViewModifier {
    var height: CGFloat? = nil
    var width: CGFloat? = nil
    var color: Color? = nil
    
    func body(content: Content) -> some View {
        content
            .modifier(HPadding(pad: 10))
            .modifier(DefaultText(size: 25, color: color))
            .frame(width: width ?? UIScreen.screenWidth - 20, height: height, alignment: .center)
            .multilineTextAlignment(.leading)
    }
}

struct ClassicButtonText: ViewModifier {
    var width: CGFloat? = nil
    var color: Color? = nil
    
    func body(content: Content) -> some View {
        content
            .modifier(ClassicText(height: 70, width: width ?? UIScreen.screenWidth - 20, color: color))
            .multilineTextAlignment(.center)
    }
}

struct ClassicSubButtonText: ViewModifier {
    var width: CGFloat? = nil
    
    func body(content: Content) -> some View {
        content
            .modifier(ClassicText(height: 50, width: width ?? UIScreen.screenWidth - 20))
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
