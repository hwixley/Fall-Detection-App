//
//  RegisterView.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/01/2022.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    
    @State var name: String = ""
    @State var yob = 0
    @State var height: String = ""
    @State var weight: String = ""
    @State var is_female = 0
    @State var showErr = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MyColours.b1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section(header: Text("About You")) {
                            Textfield(title: "*Name", contentType: UITextContentType.name, keyboardType: UIKeyboardType.asciiCapable, labelWidth: 90, output: $name)
                            HStack(spacing: 10) {
                                Text("*Year of Birth")
                                    .modifier(LabelText())
                                    .frame(width: 90, alignment: .trailing)
                                Picker(selection: $yob, label: Text("")) {
                                    ForEach(0..<MyData.years.count) { idx in
                                        Text(String(MyData.years[idx])).tag(idx)
                                    }
                                }
                                .tint(MyColours.p0)
                            }
                            Textfield(title: "*Height (cm)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $height)
                            Textfield(title: "*Weight (kg)", contentType: UITextContentType.oneTimeCode, keyboardType: UIKeyboardType.numberPad, labelWidth: 90, output: $weight)
                            HStack(spacing: 0) {
                                Text("*Gender")
                                    .modifier(LabelText())
                                    .frame(width: 90, alignment: .trailing)
                                Picker("*Gender", selection: $is_female) {
                                    Text("Male")
                                        .modifier(LabelText())
                                        .tag(0)
                                    Text("Female")
                                        .modifier(LabelText())
                                        .tag(1)
                                }
                                .frame(height: 30)
                                .modifier(HPadding(pad: 10))
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            if showErr {
                                Warning(text: "Please fill in all the required fields")
                            }
                        }
                    }
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        if name != "" && height != "" && weight != "" {
                            showErr = false
                            MyData.user = User(id: "", name: name, email: "", password: "", phone: "", yob: MyData.years[yob], height: Int(height)!, weight: Int(weight)!, is_female: is_female == 0 ? false : true, medical_conditions: "", contacts: [])
                            appState.inappState.page = .register1
                        } else {
                            showErr = true
                        }
                    }) {
                        MainButton(title: "Next", image: "")
                    }
                    .buttonStyle(ClassicButtonStyle(useGradient: true))
                }
                .modifier(NavigationBarStyle(title: "Register", page: .entry, hideBackButton: false, appState: appState))
                .padding(.bottom, 10)
            }
            .modifier(BackgroundStack(appState: appState, backPage: .entry))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
