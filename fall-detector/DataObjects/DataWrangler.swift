//
//  DataWrangler.swift
//  fall-detector
//
//  Created by Harry Wixley on 01/03/2022.
//

import Foundation
import CoreMotion
import AVFoundation
import TensorFlowLite
import CoreML

class DataWrangler: ObservableObject {
    let polarManager = PolarBleSdkManager()
    let motionManager = CMMotionManager()
    let mlModel = CustomMLModel()
    
    var started = false
    var timer : Timer? = nil
    var intvlIdx = 0
    
    var lastHeading = -999.0
    
    @Published var intervals : [DataInterval] = []
    @Published var currWindow : Data? = nil
    
    func start() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
        
        DispatchQueue.main.async {
            if (self.motionManager.isDeviceMotionAvailable) {
                self.motionManager.deviceMotionUpdateInterval = 0.1
                self.motionManager.showsDeviceMovementDisplay = true
            }
        }
        self.started = true
    }
    
    func stop() {
        self.motionManager.stopDeviceMotionUpdates()
        self.timer!.invalidate()
        self.timer = nil
        self.started = false
    }
    
    @objc func updateTimer() {
        if MyData.fallModel.features == "all" {
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { data, error in
                guard let motionData = data, error == nil else {
                    return
                }
                
                let acc = Coord(x: motionData.userAcceleration.x, y: motionData.userAcceleration.y, z: motionData.userAcceleration.z)
                let gyr = Coord(x: motionData.rotationRate.x, y: motionData.rotationRate.y, z: motionData.rotationRate.z)
                let gra = Coord(x: motionData.gravity.x, y: motionData.gravity.y, z: motionData.gravity.z)
                let mag = Coord(x: motionData.magneticField.field.x, y: motionData.magneticField.field.y, z: motionData.magneticField.field.z)
                let att = Coord(x: motionData.attitude.pitch, y: motionData.attitude.roll, z: motionData.attitude.yaw)
                
                var dhe = 0.0
                if self.lastHeading == -999 {
                    self.lastHeading = motionData.heading
                } else {
                    dhe = Double(motionData.heading - self.lastHeading)
                    self.lastHeading = motionData.heading
                }
                if self.polarManager.deviceConnectionState == .connected(self.polarManager.deviceId) && self.polarManager.isRecording && self.polarManager.ecg.count >= 13 && self.polarManager.acc_x.count >= 20 && self.polarManager.acc_y.count >= 20 && self.polarManager.acc_z.count >= 20 {
                    self.intervals.append(DataInterval(idx: self.intvlIdx, p_ecg: Array(self.polarManager.ecg.prefix(13)), p_acc_x: Array(self.polarManager.acc_x.prefix(20)), p_acc_y: Array(self.polarManager.acc_y.prefix(20)), p_acc_z: Array(self.polarManager.acc_z.prefix(20)), acc: acc, gyr: gyr, gra: gra, mag: mag, att: att, dh: dhe))
                } else {
                    //print(NSDate.now)
                    //print(self.polarManager.isRecording)
                    //print(self.polarManager.ecg.count)
                    //print(sle.f)
                    self.intervals.append(DataInterval(idx: self.intvlIdx, acc: acc, gyr: gyr, gra: gra, mag: mag, att: att, dh: dhe))
                }
                self.intvlIdx += 1
                
                let data = self.getData()
                if data != nil {
                    let pred = self.mlModel.predict(data: data!)
                    //print("MODEL PREDICTION")
                    print(pred ?? "nil")
                    if pred != nil && pred! {
                        AudioServicesPlayAlertSound(SystemSoundID(1321))
                    }
                }
            }
        } else {
            if self.polarManager.deviceConnectionState == .connected(self.polarManager.deviceId) && self.polarManager.isRecording && self.polarManager.ecg.count >= 13 && self.polarManager.acc_x.count >= 20 && self.polarManager.acc_y.count >= 20 && self.polarManager.acc_z.count >= 20 {
                self.intervals.append(DataInterval(idx: self.intvlIdx, p_ecg: Array(self.polarManager.ecg.suffix(13)), p_acc_x: Array(self.polarManager.acc_x.suffix(20)), p_acc_y: Array(self.polarManager.acc_y.suffix(20)), p_acc_z: Array(self.polarManager.acc_z.suffix(20))))
            }
            self.intvlIdx += 1
            
            let data = self.getData()
            //print(data)
            if data != nil {
                let pred = self.mlModel.predict(data: data!)
                //print("MODEL PREDICTION")
                print(pred ?? "nil")
                if pred != nil && pred! {
                    AudioServicesPlayAlertSound(SystemSoundID(1321))
                }
            }
        }
    }
    
    func getIntervals() -> [DataInterval] {
        if self.intervals.count >= Constants.windowSize {
            let data = Array(self.intervals.prefix(Constants.windowSize))
            self.intervals.remove(at: 0)
            return data
        } else {
            return []
        }
    }
    
    func getData() -> Data? {
        let winIntvls = self.getIntervals()
        
        var output : [Double] = []
        for intvl in winIntvls {
            let vec = intvl.getVector()
            if vec.count == MyData.fallModel.intvl_size {
                output = output + vec
            } else {
                output = []
                break
            }
        }
        //print(output)
        let user_num = zip([Double(MyData.user!.height), Double(MyData.user!.weight)], Constants.x_min2.suffix(2)).map(-)
        let user_den = zip(Constants.x_max2.suffix(2), Constants.x_min2.suffix(2)).map(-)
        let user_stats = zip(user_num, user_den).map(/)
        output = output + user_stats + Array(repeating: 0.0, count: MyData.fallModel.dummy_ftrs)
        //print(output)
        //print("output count:")
        //print(output.count)
        //let out = output.map { UInt8($0) }
        if output.count == MyData.fallModel.num_features*MyData.fallModel.num_features {
            var finalData = Data()
            for i in 0..<MyData.fallModel.num_features {
                let idx = i*MyData.fallModel.num_features
                let row = Array(output[idx..<idx+MyData.fallModel.num_features]).map { Float($0) }
                //let bytes = [Double](repeating: 0, count: 30)
                //SystemMisc.memoryCopy(bytes, 0, row, 0, 3600)
                finalData.append(Data(bytes: row, count: MyData.fallModel.num_features*4))
                /*for el in row {
                    let elementSize = MemoryLayout.size(ofValue: el)
                    var bytes = [Double](repeating: 0, count: elementSize)
                    memcpy(bytes, el, elementSize)
                    finalData.append(bytes)
                }*/
                //memcpy(&amp;bytes, &amp;row, elementSize)
                /*do {
                    let rowData = try Data(buffer: UnsafeBufferPointer<Float>(MLMultiArray(row)))
                    finalData.append(rowData)
                } catch let error {
                    print(error.localizedDescription)
                    return nil
                }*/
            }
            //guard var out = try? MLMultiArray(shape: [1,1,30,30], dataType: .float32) else {
            //   return MLMultiArray()
            //}
            return finalData
        } else {
            return nil
        }
    }
}
