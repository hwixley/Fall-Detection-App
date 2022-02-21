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
    
    @State var modelChoice: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.g0.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        /*Section("Fall Detection Model") {
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
                        }*/
                        Section("Energy/Cellular Usage") {
                            Text("You can choose whether the ML fall detection model should be executed on your phone or in the cloud based on your energy/cellular requirements.\nExecuting on your phone results in higher energy consumption, and executing in the cloud results in higher cellular data consumption.")
                                .modifier(DefaultText(size: 18, color: MyColours.t1))
                            
                            HStack(spacing: 10) {
                                Text("Model Execution")
                                    .modifier(LabelText())
                                    .frame(width: 90, alignment: .trailing)
                                Picker("Model Execution", selection: $modelChoice) {
                                    Text("Cloud")
                                        .modifier(LabelText())
                                        .tag(0)
                                    Text("Phone")
                                        .modifier(LabelText())
                                        .tag(1)
                                }
                                .frame(height: 40)
                                .modifier(HPadding(pad: 5))
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .modifier(VPadding(pad: 5))
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

