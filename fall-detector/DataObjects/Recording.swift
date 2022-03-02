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
    
    init(idx: Int, p_ecg: [Double]? = nil, p_acc_x: [Double]? = nil, p_acc_y: [Double]? = nil, p_acc_z: [Double]? = nil, acc: Coord? = nil, gyr: Coord? = nil, gra: Coord? = nil, mag: Coord? = nil, att: Coord? = nil, dh: Double? = nil) {
        self.idx = idx
        self.p_ecg = p_ecg == nil ? [] : p_ecg!
        if p_ecg != nil {
            assert(p_ecg!.count == 13)
        }
        if p_acc_x != nil {
            assert(p_acc_x!.count == 20)
            self.p_acc_x = p_acc_x!
        }
        if p_acc_y != nil {
            assert(p_acc_y!.count == 20)
            self.p_acc_y = p_acc_y!
        }
        if p_acc_z != nil {
            assert(p_acc_z!.count == 20)
            self.p_acc_z = p_acc_z!
        }
        self.acc_x = acc == nil ? nil : acc!.x
        self.acc_y = acc == nil ? nil : acc!.y
        self.acc_z = acc == nil ? nil : acc!.z
        self.gyr_x = gyr == nil ? nil : gyr!.x
        self.gyr_y = gyr == nil ? nil : gyr!.y
        self.gyr_z = gyr == nil ? nil : gyr!.z
        self.gra_x = gra == nil ? nil : gra!.x
        self.gra_y = gra == nil ? nil : gra!.y
        self.gra_z = gra == nil ? nil : gra!.z
        self.mag_x = mag == nil ? nil : mag!.x
        self.mag_y = mag == nil ? nil : mag!.y
        self.mag_z = mag == nil ? nil : mag!.z
        self.att_roll = att == nil ? nil : att!.x
        self.att_pitch = att == nil ? nil : att!.y
        self.att_yaw = att == nil ? nil : att!.z
        self.delta_heading = dh == nil ? nil : dh!
    }
    
    func getVector() -> [Double] {
        if MyData.fallModel.features == "all" {
            if isCMValid() && isPolarValid() {
                let vec =  p_ecg + p_acc_x + p_acc_y + p_acc_z + [acc_x!, acc_y!, acc_z!, gyr_x!, gyr_y!, gyr_z!, gra_x!, gra_y!, gra_z!, mag_x!, mag_y!, mag_z!, att_roll!, att_pitch!, att_yaw!, delta_heading!]
                //print(vec)
                let numerator = zip(vec, Constants.x_min1.prefix(MyData.fallModel.intvl_size)).map(-)
                //print(numerator)
                let denominator = zip(Constants.x_max1.prefix(MyData.fallModel.intvl_size), Constants.x_min1.prefix(MyData.fallModel.intvl_size)).map(-)
                //print(denominator)
                return zip(numerator, denominator).map(/)
            } else {
                return []
            }
        } else {
            if isPolarValid() {
                let vec =  p_ecg + p_acc_x + p_acc_y + p_acc_z
                //print(vec)
                let numerator = zip(vec, Constants.x_min2.prefix(MyData.fallModel.intvl_size)).map(-)
                //print(numerator)
                let denominator = zip(Constants.x_max2.prefix(MyData.fallModel.intvl_size), Constants.x_min2.prefix(MyData.fallModel.intvl_size)).map(-)
                //print(denominator)
                return zip(numerator, denominator).map(/)
            } else {
                return []
            }
        }
    }
    
    func isCMValid() -> Bool {
        return acc_x != nil && acc_y != nil && acc_z != nil && gyr_x != nil && gyr_y != nil && gyr_z != nil && gra_x != nil && gra_y != nil
    }
    
    func isPolarValid() -> Bool {
        return self.p_ecg.count == 13 && self.p_acc_x.count == 20 && self.p_acc_y.count == 20 && self.p_acc_z.count == 20
    }
}

struct Window {
    let id = NSUUID().uuidString
    var intervals: [DataInterval]
                
    func finalWindow() -> [Double] {
        var output : [Double] = []
        for i in self.intervals {
            output = output + i.getVector()
        }
        return output
    }
}
