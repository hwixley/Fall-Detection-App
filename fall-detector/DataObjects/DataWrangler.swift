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
    var lastPred = false
    var past_predictions : [Bool] = []
    
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
        /*if MyData.fallModel.features == "all" {
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
                if data != nil && data!.count == 6000 {
                    let pred = self.mlModel.predict(data: data!)

                    if pred != nil {
                        if pred! {
                            AudioServicesPlayAlertSound(SystemSoundID(1321))
                            if !self.lastPred {
                                
                            }
                        }
                        //self.lastPred = pred!
                    }
                }
            }
        } else {*/
        if MyData.fallModel.features == "polar" {
            if self.polarManager.deviceConnectionState == .connected(self.polarManager.deviceId) && self.polarManager.isRecording && self.polarManager.ecg.count >= 13 && self.polarManager.acc_x.count >= 20 && self.polarManager.acc_y.count >= 20 && self.polarManager.acc_z.count >= 20 {
                let ecg = Array(self.polarManager.ecg.suffix(260))
                let accx = Array(self.polarManager.acc_x.suffix(400))
                let accy = Array(self.polarManager.acc_y.suffix(400))
                let accz = Array(self.polarManager.acc_z.suffix(400))
                
                
                //self.intvlIdx += 1
                if ecg.count == 260 && accx.count == 400 && accy.count == 400 && accz.count == 400 {
                    
                    let data = self.getAllData(ecg: ecg, accx: accx, accy: accy, accz: accz)
                    let pred = self.mlModel.predict(data: data)
                    
                    //print("MODEL PREDICTION")
                    print(pred ?? "nil")
                    
                    if pred != nil {
                        self.past_predictions.append(pred!)
                    }
                    if self.past_predictions.count > 20 {
                        self.past_predictions.remove(at: 0)
                        
                        var fall_count = 0
                        var non_fall_count = 0
                        for past_pred in self.past_predictions {
                            if past_pred {
                                fall_count += 1
                            } else {
                                non_fall_count += 1
                            }
                        }
                        
                        print(fall_count - non_fall_count)
                        
                        if pred! && fall_count > 15 {
                            AudioServicesPlayAlertSound(SystemSoundID(1321))
                        }
                    }
                    //self.intervals.append(DataInterval(idx: self.intvlIdx, p_ecg: Array(self.polarManager.ecg.suffix(13)), p_acc_x: Array(self.polarManager.acc_x.suffix(20)), p_acc_y: Array(self.polarManager.acc_y.suffix(20)), p_acc_z: Array(self.polarManager.acc_z.suffix(20))))
                }
            }

            //}
        }
    }
    
    func getAllData(ecg: [Double], accx: [Double], accy: [Double], accz: [Double]) -> Data {
        
        var finalData = Data()
        
        //var output : [[Double]] = []

        for i in 0..<20 {
            let vec = Array(ecg[i*13..<i*13 + 13]) + Array(accx[i*20..<i*20 + 20]) + Array(accy[i*20..<i*20 + 20]) + Array(accz[i*20..<i*20 + 20])
            
            var intvl_output : [Double] =  []
            
            if vec.count == MyData.fallModel.intvl_size {
                //output = output + vec + [Double(MyData.user!.height), Double(MyData.user!.weight)]
                intvl_output = vec + [Double(MyData.user!.height), Double(MyData.user!.weight)]
            } else {
                intvl_output = []
                break
            }
            //print(intvl_output.count)
            
            let intvl_num = zip(intvl_output, MyData.fallModel.xMin).map(-)
            let intvl_den = zip(intvl_num, MyData.fallModel.xMax).map(/)
            
            //output.append(intvl_den)
            let rowData = Array(intvl_den).map{ Float($0) }
            //print(rowData.count)
            //print(type(of: rowData))
            
            //output.append(contentsOf: rowData)
            finalData.append(Data(bytes: rowData, count: rowData.count*4))
        }
        
        return finalData
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
    
    func getData() -> Data {
        let winIntvls = self.getIntervals()
        
        var finalData = Data()
        
        //var output : [[Double]] = []
        for intvl in winIntvls {
            let vec = intvl.getVector()
            
            var intvl_output : [Double] =  []
            
            if vec.count == MyData.fallModel.intvl_size {
                //output = output + vec + [Double(MyData.user!.height), Double(MyData.user!.weight)]
                intvl_output = vec + [Double(MyData.user!.height), Double(MyData.user!.weight)]
            } else {
                intvl_output = []
                break
            }
            //print(intvl_output.count)
            
            let intvl_num = zip(intvl_output, MyData.fallModel.xMin).map(-)
            let intvl_den = zip(intvl_num, MyData.fallModel.xMax).map(/)
            
            //output.append(intvl_den)
            let rowData = Array(intvl_den).map{ Float($0) }
            //print(rowData.count)
            //print(type(of: rowData))
            
            //output.append(contentsOf: rowData)
            finalData.append(Data(bytes: rowData, count: rowData.count*4))
        }
        
        return finalData
        
        //print(type(of: finalData))
        /*print(winIntvls.count)
        //print()
        print(finalData.count)
        
        //var finalFinalData = Data()
        //finalFinalData.append(finalData)
        
        //var final*/
        //print(output.count)
        
        /*
        if output.count == MyData.fallModel.window_size {
             var finalData = Data()
             for i in 0..<MyData.fallModel.window_size {
                 let intvl = output[i].map { Float($0) }
                 //let row = Array(output[idx..<idx+MyData.fallModel.intvl_size]).map { Float($0) }
                 let reshaped = [[intvl]]
                 finalData.append(Data(bytes: intvl, count: MyData.fallModel.num_features*4))
             }
             return finalData
                        
        } else {
            //print(MyData.fallModel.window_size)
            //print(MyData.fallModel.intvl_size)
            //print("returning nil...")
            return nil
        }*/
        
        /*
        print("BYTE SIZE")
        print(finalData.count)
        
        return finalData*/
        
        
        /*
        let user_num = zip([Double(MyData.user!.height), Double(MyData.user!.weight)], MyData.fallModel.xMin.suffix(2)).map(-)
        let user_den = zip(MyData.fallModel.xMax.suffix(2), MyData.fallModel.xMin.suffix(2)).map(-)
        let user_stats = zip(user_num, user_den).map(/)
        output = output + user_stats + Array(repeating: 0.0, count: MyData.fallModel.dummy_ftrs)

        if output.count == MyData.fallModel.num_features*MyData.fallModel.num_features {
            var finalData = Data()
            for i in 0..<MyData.fallModel.num_features {
                let idx = i*MyData.fallModel.num_features
                let row = Array(output[idx..<idx+MyData.fallModel.num_features]).map { Float($0) }
                finalData.append(Data(bytes: row, count: MyData.fallModel.num_features*4))
            }
            return finalData
        } else {
            return nil
        }
        */
    }
}
