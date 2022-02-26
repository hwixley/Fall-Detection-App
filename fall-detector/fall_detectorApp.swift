//
//  fall_detectorApp.swift
//  fall-detector
//
//  Created by Harry Wixley on 31/12/2021.
//

import SwiftUI
import Firebase

@main
struct fall_detectorApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var polarManager = PolarBleSdkManager()
    @ObservedObject var coremotionData = CoreMotionData()
    
    init() {
        FirebaseApp.configure()
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(MyColours.p0)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(MyColours.p0).darker(by: 30)
        UIPickerView.appearance().tintColor = UIColor(MyColours.p0)
        UIProgressView.appearance().tintColor = UIColor(MyColours.p0)
        UILabel.appearance().tintColor = UIColor(MyColours.p0)
    }
    
    var body: some Scene {
        WindowGroup {
            switch appState.inappState.page {
            case .entry:
                EntryView()
                    .environmentObject(appState)
            case .login:
                LoginView()
                    .environmentObject(appState)
            case .resetpass:
                liForgotPasswordView()
                    .environmentObject(appState)
            case .register:
                RegisterView()
                    .environmentObject(appState)
            case .register1:
                Register1View()
                    .environmentObject(appState)
            case .register2:
                Register2View()
                    .environmentObject(appState)
            case .register3:
                Register3View()
                    .environmentObject(appState)
            case .main:
                MainView()
                    .environmentObject(appState)
                    .environmentObject(polarManager)
                    .environmentObject(coremotionData)
                    .onAppear {
                        if self.appState.inappState.fallDetection && !self.coremotionData.started {
                            self.coremotionData.start()
                        }
                    }
            case .account:
                mnAccountView()
                    .environmentObject(appState)
            case .about:
                mnAboutView()
                    .environmentObject(appState)
            case .help:
                mnHelpView()
                    .environmentObject(appState)
            case .settings:
                mnSettingsView()
                    .environmentObject(appState)
            }
        }
    }
}
