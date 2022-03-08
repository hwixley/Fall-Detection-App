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
    
    @State var name: String = MyData.user == nil ? "" : MyData.user!.name
    @State var yob = MyData.user == nil ? 0 : MyData.years.firstIndex(of: MyData.user!.yob) ?? 0
    @State var height: String = MyData.user == nil ? "" : String(MyData.user!.height)
    @State var weight: String = MyData.user == nil ? "" : String(MyData.user!.weight)
    @State var is_female = MyData.user == nil ? 0 : (MyData.user!.is_female ? 1 : 0)
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
                        .modifier(SectionStyle())
                    }
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        if name != "" && height != "" && weight != "" {
                            showErr = false
                            if MyData.user == nil {
                                MyData.user = User(id: "", name: name, email: "", password: "", phone: "", yob: MyData.years[yob], height: Int(height)!, weight: Int(weight)!, is_female: is_female == 0 ? false : true, medical_conditions: "", contacts: [], notif: false)
                            } else {
                                MyData.user!.name = name
                                MyData.user!.yob = MyData.years[yob]
                                MyData.user!.height = Int(height)!
                                MyData.user!.weight = Int(weight)!
                                MyData.user!.is_female = is_female == 0 ? false : true
                            }
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
