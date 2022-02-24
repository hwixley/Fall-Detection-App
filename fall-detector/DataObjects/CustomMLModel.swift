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

struct CustomMLModel {
    var interpreter: Interpreter? = nil
    
    init() {
        guard let modelPath = Bundle.main.path(forResource: "model", ofType: "tflite") else { return }
        
        do {
            self.interpreter = try Interpreter(modelPath: modelPath)
            try interpreter!.allocateTensors()
        } catch {
            print("error time")
        }
    }
    
    func test(data: Data) -> Tensor? {
        if self.interpreter != nil {
            do {
                try self.interpreter!.copy(data, toInputAt: 0)
                try self.interpreter!.invoke()
                
                let outputResult = try self.interpreter!.output(at: 0)
                return outputResult
                
            } catch {
                print("error time")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func predict(data: Data) -> Bool? {
        let outputTensor = test(data: data)
        
        if outputTensor != nil {
            let maxVal = outputTensor!.data.max()
            
            if maxVal != nil {
                let idx = outputTensor!.data.firstIndex(of: maxVal!)
                return idx == 1
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
