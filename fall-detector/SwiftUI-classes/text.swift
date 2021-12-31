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
            .frame(width: 350, height: 60)
            .font(.system(size: 25, weight: .bold, design: .default))
        
    }
}

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .font(.largeTitle)
    }
}

struct SubtitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .font(.subheadline)
    }
}
