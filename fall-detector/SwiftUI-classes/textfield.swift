//
//  textfield.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import Foundation
import SwiftUI

struct ClassicTextfield: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(SubtitleText())
            .textFieldStyle(.roundedBorder)
            .background(.gray)
            .cornerRadius(12)
    }
}

struct PlaceholderStyle: ViewModifier {
    var input: String
    var placeholder: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if input.isEmpty {
                Text(placeholder)
                    .background(.gray)
                    .foregroundColor(.white)
            } else {
                Text(input)
                    .background(.gray)
                    .foregroundColor(.white)
            }
            
            content
                .modifier(ClassicTextfield())
        }
    }
}
