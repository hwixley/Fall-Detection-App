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
    var lag = 0
    var features = "polar"
    var num_features = 28
    var intvl_size = 73
    var dummy_ftrs = 52
}

