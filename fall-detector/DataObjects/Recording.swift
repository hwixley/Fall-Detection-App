//
//  Recording.swift
//  fall-detector
//
//  Created by Harry Wixley on 21/01/2022.
//

import Foundation

struct Recording {
    var p_ecg: [Double]
    var p_hr: [Double]
    var p_contact: [Bool]
    var p_acc_x: [Double]
    var p_acc_y: [Double]
    var p_acc_z: [Double]
    var acc_x: [Double]
    var acc_y: [Double]
    var acc_z: [Double]
    var gyr_x: [Double]
    var gyr_y: [Double]
    var gyr_z: [Double]
    var gra_x: [Double]
    var gra_y: [Double]
    var gra_z: [Double]
    var mag_x: [Double]
    var mag_y: [Double]
    var mag_z: [Double]
    var att_roll: [Double]
    var att_pitch: [Double]
    var att_yaw: [Double]
    var delta_heading: [Double]
}

struct DataInterval {
    var id = NSUUID().uuidString
    var idx: Int
    var p_ecg: [Double] = [] //13
    var p_acc_x: [Double] = [] //20
    var p_acc_y: [Double] = [] //20
    var p_acc_z: [Double] = [] //20
    var acc_x: Double? = nil
    var acc_y: Double? = nil
    var acc_z: Double? = nil
    var gyr_x: Double? = nil
    var gyr_y: Double? = nil
    var gyr_z: Double? = nil
    var gra_x: Double? = nil
    var gra_y: Double? = nil
    var gra_z: Double? = nil
    var mag_x: Double? = nil
    var mag_y: Double? = nil
    var mag_z: Double? = nil
    var att_roll: Double? = nil
    var att_pitch: Double? = nil
    var att_yaw: Double? = nil
    var delta_heading: Double? = nil
    
    func getVector() -> [Double] {
        if isValid() {
            //let mrgDbl = [acc_x!, acc_y!, acc_z!, gyr_x!, gyr_y!, gyr_z!, gra_x!, gra_y!, gra_z!, mag_x!, mag_y!, mag_z!, att_roll!, att_pitch!, att_yaw!, delta_heading!]
            return p_ecg + p_acc_x + p_acc_y + p_acc_z // + mrgDbl
        } else {
            return []
        }
    }
    
    func isValid() -> Bool {
        return p_ecg.count == 13 && p_acc_x.count == 20 && p_acc_y.count == 20 && p_acc_z.count == 20 //&& acc_x != nil && acc_y != nil && acc_z != nil && gyr_x != nil && gyr_y != nil && gyr_z != nil && gra_x != nil && gra_y != nil
    }
}
