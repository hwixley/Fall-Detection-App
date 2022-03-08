//
//  HomeView.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/01/2022.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    //@EnvironmentObject var polarManager: PolarBleSdkManager
    //@EnvironmentObject var coremotionData: CoreMotionData
    @EnvironmentObject var dataWrangler: DataWrangler
    @EnvironmentObject var mlModel: CustomMLModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                
                VStack {
                    DetectorView(appState: self.appState, dataWrangler: self.dataWrangler)
                        .cornerRadius(20)
                    
                    ConnectionView(appState: self.appState, dataWrangler: self.dataWrangler)
                        .cornerRadius(20)
                    
                    if self.dataWrangler.polarManager.deviceConnectionState == .connected(self.dataWrangler.polarManager.deviceId) {
                        LiveMovementView(appState: self.appState, dataWrangler: self.dataWrangler)
                            .cornerRadius(20)
                    }
                }
                .padding(.all, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: nil))
            .modifier(NavigationBarStyle(title: "Home", page: .entry, hideBackButton: true, appState: appState))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState(inappState: InAppState()))
    }
}
