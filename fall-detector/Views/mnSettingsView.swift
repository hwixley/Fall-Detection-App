//
//  mnSettingsView.swift
//  fall-detector
//
//  Created by Harry Wixley on 06/01/2022.
//

import SwiftUI
import CoreLocation

struct mnSettingsView: View {
    @EnvironmentObject var appState: AppState

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section("Fall Detection Model") {
                            CustLabel(title: "Type of Model:", value: "CNN")
                            CustLabel(title: "Features Used:", value: "All")
                            CustLabel(title: "Metric:", value: "high TPR")
                        }
                        Button("send text") {
                            sendMessage(contact: Person(id: "", name: "Harry", phone: "+4407484111141", isOnFirebase: true)) { response in
                                if response {
                                    print("fukc yea")
                                } else {
                                    print("shit no")
                                }
                            }
                        }
                    }
                }
                .modifier(NavigationBarStyle(title: "Settings", page: .main, hideBackButton: false, appState: appState))
            }
            .modifier(BackgroundStack(appState: appState, backPage: .main))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

struct mnSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        mnSettingsView()
    }
}

