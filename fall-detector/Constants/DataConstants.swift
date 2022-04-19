//
//  Data.swift
//  fall-detector
//
//  Created by Harry Wixley on 22/01/2022.
//

import Foundation

struct MyData {
    static var user: User? = nil
    
    static var polarDeviceID = "9F8BF424"
    
    static let currYear = Int(Calendar.current.component(.year, from: Date()))
    static let years: [Int] = Array(currYear-100...currYear-1).reversed()
    static var fallModel = Models().getModel(arch: "ResNet", features: "polar", lag: 0)
    
    static let apn = APNHandling()
}
