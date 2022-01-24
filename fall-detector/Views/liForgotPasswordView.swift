//
//  liForgotPasswordView.swift
//  fall-detector
//
//  Created by Harry Wixley on 24/01/2022.
//

import SwiftUI

struct liForgotPasswordView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct liForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        liForgotPasswordView()
    }
}
