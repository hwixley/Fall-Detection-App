//
//  Register3View.swift
//  fall-detector
//
//  Created by Harry Wixley on 26/02/2022.
//

import SwiftUI
import UserNotifications

struct Register3View: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    
                }
                .modifier(NavigationBarStyle(title: "Finishing Up", page: .register2, hideBackButton: true, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .register2))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                print("Permission granted: \(granted)")
                self.appState.inappState.notifAuth = granted
                // 1. Check if permission granted
                guard granted else { return }
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.appState.inappState.page = .main
            }
        }
    }
}

struct Register3View_Previews: PreviewProvider {
    static var previews: some View {
        Register3View()
    }
}
