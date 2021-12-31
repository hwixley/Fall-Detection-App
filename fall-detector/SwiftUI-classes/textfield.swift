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
            .foregroundColor(.white)
            .background(.gray)
            .cornerRadius(10)
            .frame(height: 40)
    }
}
