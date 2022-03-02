//
//  MLModel.swift
//  fall-detector
//
//  Created by Harry Wixley on 24/02/2022.
//

import Foundation
import Firebase
import TensorFlowLiteC
import CoreML
import UIKit
import TensorFlowLite

class CustomMLModel: ObservableObject {
    var interpreter: Interpreter? = nil
    
    init() {
        do {
            let modelPath = Bundle.main.path(forResource: "polar-window10-lag0-cnn-tf", ofType: "tflite")
            self.interpreter = try Interpreter(modelPath: modelPath!)
            try interpreter!.allocateTensors()
        } catch let error {
            print("error time")
            print(error.localizedDescription)
        }
    }
    
    private func test(data: Data) -> Tensor? {
        if self.interpreter != nil {
            do {
                //print(10)
                try self.interpreter!.copy(data, toInputAt: 0)
                //print(11)
                try self.interpreter!.invoke()
                //print(12)
                let outputResult = try self.interpreter!.output(at: 0)
                return outputResult
                
            } catch let error {
                print("error time")
                print(error.localizedDescription)
                return nil
            }
        } else {
            print("oo")
            return nil
        }
    }
    
    func predict(data: Data) -> Bool? {
        let outputTensor = test(data: data)
        
        if outputTensor != nil {
            //print(0)
            print(outputTensor!)
            let probs = UnsafeMutableBufferPointer<Float>.allocate(capacity: 2)
            outputTensor!.data.copyBytes(to: probs)
            print(probs.first)
            print(probs.last)
            print(probs.prefix(10))
            
            let didFall = probs.last! >= probs.first!
            return didFall
            
            /*if maxVal != nil {
                let idx = outputTensor!.data.firstIndex(of: maxVal!)
                return idx == 1
            } else {
                print(1)
                return nil
            }*/
        } else {
            print(2)
            return nil
        }
    }
}


struct ModelVersion {
    var window_size = 10
    var lag : Int
    var features : String
    var num_features : Int
    var intvl_size : Int
    var dummy_ftrs : Int
    var xMin : [Double]
    var xMax : [Double]
    
    init(lag: Int = 0, features: String, xMin: [Double], xMax: [Double]) {
        self.features = features
        self.lag = lag
        
        if features == "polar" {
            self.num_features = 28
            self.intvl_size = 73
            self.dummy_ftrs = 52
        } else if features == "coremotion" {
            self.num_features = -1
            self.intvl_size = -1
            self.dummy_ftrs = -1
        } else {
            self.num_features = 30
            self.intvl_size = 89
            self.dummy_ftrs = 8
        }
        self.xMin = xMin
        self.xMax = xMax
    }
}

struct Models {
    static let polarNoLag = ModelVersion(features: "polar", xMin: [-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-7872.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7905.0,-7957.0,-7943.0,-7957.0,-7957.0,-7474.0,-7067.0,-7698.0,-7914.0,-7988.0,-7988.0,-7778.0,-7485.0,-7960.0,-7519.0,-6595.0,-7689.0,-7988.0,-7988.0,-7988.0,-7988.0,-7287.0,-6070.0,-5641.0,-5178.0,-7820.0,-7988.0,-7988.0,-7988.0,-7973.0,-7240.0,-7101.0,-7973.0,-7973.0,-7973.0,-7972.0,-7973.0,-7973.0,-7973.0,-6762.0,-6715.0,-7157.0,-6478.0,-7001.0,-7349.0,-7288.0,-7429.0,-7058.0,-7320.0,0.0,0.0], xMax: [19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,5958.0,7686.0,7721.0,7612.0,7845.0,6092.0,7183.0,6464.0,7906.0,4567.0,5611.0,5645.0,5244.0,4204.0,3168.0,2982.0,4548.0,3145.0,6305.0,5606.0,6483.0,4820.0,4735.0,7309.0,6747.0,7317.0,6225.0,7214.0,6225.0,5132.0,7996.0,7996.0,7996.0,7971.0,6901.0,6040.0,7354.0,7944.0,6097.0,5775.0,6472.0,5572.0,4640.0,4918.0,6768.0,5599.0,5321.0,6302.0,6867.0,6431.0,6193.0,6674.0,6271.0,6537.0,7273.0,7488.0,8000.0,8000.0,7744.0,7582.0,195.0,94.0])
    static let coremotionNoLag = ModelVersion(features: "coremotion", xMin: [], xMax: [])
    static let allNoLag = ModelVersion(features: "all", xMin: [], xMax: [])
    static let polar100Lag = ModelVersion(lag: 100, features: "polar", xMin: [], xMax: [])
    static let coremotion100Lag = ModelVersion(lag: 100, features: "coremotion", xMin: [], xMax: [])
    static let all200Lag = ModelVersion(lag: 200, features: "all", xMin: [-19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -7872.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7905.0, -7957.0, -7943.0, -7957.0, -7957.0, -7474.0, -7067.0, -7698.0, -7914.0, -7988.0, -7988.0, -7778.0, -7485.0, -7960.0, -7519.0, -5671.0, -7689.0, -7988.0, -7988.0, -7988.0, -7988.0, -7287.0, -6070.0, -5641.0, -5178.0, -7820.0, -7988.0, -7988.0, -7988.0, -7973.0, -7240.0, -7101.0, -7973.0, -7973.0, -7973.0, -7972.0, -7973.0, -7973.0, -7973.0, -6762.0, -6715.0, -7157.0, -6478.0, -7001.0, -7349.0, -7288.0, -7429.0, -7058.0, -7320.0, -6.04580926895142, -6.70586061477661, -6.69966077804565, -9.54668617248535, -14.1094083786011, -11.360408782959, -0.999957799911499, -0.996072292327881, -0.999709129333496, -101.438079833984, -66.4756088256836, -63.7047119140625, -3.14155947696207, -1.57040479353079, -3.14101491937983, -359.597382426262, 170.0, 72.0], xMax: [19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 5958.0, 7686.0, 7721.0, 7612.0, 7845.0, 6092.0, 7183.0, 6464.0, 7906.0, 4567.0, 5611.0, 5645.0, 5244.0, 4204.0, 3168.0, 2982.0, 4548.0, 3145.0, 6305.0, 5606.0, 6483.0, 4820.0, 4735.0, 7309.0, 6747.0, 7317.0, 6225.0, 7214.0, 6225.0, 5132.0, 7996.0, 7996.0, 7996.0, 7971.0, 6901.0, 6040.0, 7354.0, 7944.0, 6097.0, 5775.0, 6472.0, 5572.0, 4640.0, 4918.0, 6768.0, 5599.0, 5321.0, 6302.0, 6867.0, 6431.0, 6193.0, 6674.0, 6271.0, 6537.0, 7273.0, 7488.0, 8000.0, 8000.0, 7744.0, 7582.0, 5.019299507141110, 6.908624649047850, 6.438325881958010, 13.310121536254900, 16.45182991027830, 9.35778522491455, 0.9994904398918150, 0.9999999403953550, 0.9997871518135070,  50.75470733642580, 73.22154235839840, 65.48968505859380, 3.1413975712009600, 1.4821364471197100, 3.141467851955360, 359.64590135216700, 195.0, 94.0])
}
