//
//  StatsView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataWrangler: DataWrangler
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        VStack {
                            Text("BIOMETRICS")
                                .modifier(DefaultText(size: 20))
                            
                            Divider()
                            
                            CustLabel(title: "Average heart rate", value: " BPM")
                        }
                        .padding(.all, 10)
                        .background(MyColours.b1)
                    }
                    .cornerRadius(20)
                    
                    VStack {
                        VStack {
                            Text("FALL DETECTION")
                                .modifier(DefaultText(size: 20))
                            
                            Divider()
                            
                            CustLabel(title: "# Falls detected:", value: "")
                            CustLabel(title: "TPR:", value: "%")
                            CustLabel(title: "FPR:", value: "%")
                        }
                        .padding(.all, 10)
                        .background(MyColours.b1)
                    }
                    .cornerRadius(20)
                }
                .padding(.all, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: nil))
            .modifier(NavigationBarStyle(title: "Stats", page: .entry, hideBackButton: true, appState: appState))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
