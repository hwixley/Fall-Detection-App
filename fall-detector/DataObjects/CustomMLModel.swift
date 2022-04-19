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
import simd

class CustomMLModel: ObservableObject {
    var interpreter: Interpreter? = nil
    
    init() {
        do {
            let modelPath = Bundle.main.path(forResource: "resnet152-ws20-lag0", ofType: "tflite")
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
                //print(data.count)
                try self.interpreter!.copy(data, toInputAt: 0)
                //print(11)
                try self.interpreter!.invoke()
                //print(12)
                let outputResult = try self.interpreter!.output(at: 0)
                //print(outputResult)
                
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
            //print(outputTensor!)
            let probs = UnsafeMutableBufferPointer<Float>.allocate(capacity: 2)
            outputTensor!.data.copyBytes(to: probs)
            print(probs.first)
            print(probs.last)
            print(probs.first! - probs.last!)
            //print(probs.prefix(10))
            
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
    var window_size = 20
    var lag : Int
    var features : String
    var architecture: String
    var num_features : Int
    var intvl_size : Int
    var dummy_ftrs : Int
    var xMin : [Double]
    var xMax : [Double]
    
    init(lag: Int = 0, architecture: String, features: String, xMin: [Double], xMax: [Double]) {
        self.features = features
        self.lag = lag
        self.architecture = architecture
        
        if features == "polar" {
            self.window_size = 20
            self.num_features = 75
            self.intvl_size = 73
            self.dummy_ftrs = 0
            //self.num_features = 28
            //self.intvl_size = 73
            //self.dummy_ftrs = 52
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
    let polarNoLagResNet = ModelVersion(architecture: "ResNet", features: "polar", xMin: [13.869628458498, 15.1484584980237, 14.7087272727273, 14.1692173913043, 13.3812490118577, 12.5506877470356, 13.486766798419, 13.0210750988142, 11.6257075098814, 12.5177707509881, 14.0577391304348, 13.8186719367589, 13.035604743083, -534.842750988142, -535.218324110672, -535.299272727273, -535.386909090909, -535.530197628459, -535.441185770751, -535.765217391304, -535.85147826087, -535.640679841897, -535.972885375494, -535.779557312253, -535.339272727273, -534.96842687747, -535.218861660079, -535.355241106719, -535.309628458498, -535.380268774704, -535.428316205534, -534.923747035573, -534.902466403162, 44.5650434782609, 44.8540869565217, 44.9171067193676, 44.9575652173913, 45.2377075098814, 45.3663873517787, 45.1595889328063, 45.6040948616601, 45.3842371541502, 45.295209486166, 45.0436996047431, 44.589581027668, 44.5603794466403, 44.6172015810277, 44.6806324110672, 44.5016442687747, 44.6940869565217, 44.6733280632411, 44.2416600790514, 44.2734229249012, -7.1636837944664, -7.42477470355731, -6.88463241106719, -6.64303557312253, -6.76001581027668, -7.41671146245059, -7.91503557312253, -8.34175494071146, -7.81313833992095, -8.55073517786561, -8.96651383399209, -8.15538339920949, -8.19946245059289, -8.32118577075099, -8.22534387351779, -7.69791304347826, -6.96061660079051, -6.96207114624506, -6.55751778656127, -6.6941976284585, 358.27143083004, 74.2222766798419], xMax: [0.551009860206141, 0.555457019642265, 0.554433028542082, 0.550943017237576, 0.551847724628931, 0.537736988818329, 0.542676636490151, 0.544985269825148, 0.541833510462016, 0.542505697517187, 0.539394810149004, 0.542422791269824, 0.551095332787668, 0.358034758431194, 0.357144884560117, 0.35915183383254, 0.360128352809616, 0.3623900680328, 0.362951843233761, 0.364535046721416, 0.363858204856489, 0.36329310077997, 0.360287095649491, 0.359239830191649, 0.359652071392224, 0.358447960533373, 0.357455085468163, 0.358940314499407, 0.360258212522374, 0.359494437386686, 0.358543162990441, 0.359311972882075, 0.357244663520417, 0.234890336183132, 0.236227389475644, 0.234722569910209, 0.234141964824408, 0.234135840231986, 0.234013592032741, 0.23367766737981, 0.236094581689345, 0.236726601289074, 0.233211341368072, 0.231146932327592, 0.23284135191292, 0.232174230420918, 0.233311060279121, 0.230734713815625, 0.230288405081395, 0.234587520064434, 0.233748115404628, 0.237173138285406, 0.236553269213289, 0.358208170438006, 0.355183430812648, 0.354779928683378, 0.35670663249839, 0.354549923417859, 0.355219921162656, 0.354053825799873, 0.358919565860534, 0.357952050578454, 0.360415008112617, 0.359081920995718, 0.355667863709108, 0.354981954422557, 0.357628647200003, 0.355784289787676, 0.355650212868175, 0.358812022421555, 0.360142349715021, 0.358256985516227, 0.358085814285356, 0.0127590639532689, 0.00278170334523276])
    
    let polarNoLagCNN = ModelVersion(architecture: "CNN", features: "polar", xMin: [-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-19733.0,-7872.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7957.0,-7905.0,-7957.0,-7943.0,-7957.0,-7957.0,-7474.0,-7067.0,-7698.0,-7914.0,-7988.0,-7988.0,-7778.0,-7485.0,-7960.0,-7519.0,-6595.0,-7689.0,-7988.0,-7988.0,-7988.0,-7988.0,-7287.0,-6070.0,-5641.0,-5178.0,-7820.0,-7988.0,-7988.0,-7988.0,-7973.0,-7240.0,-7101.0,-7973.0,-7973.0,-7973.0,-7972.0,-7973.0,-7973.0,-7973.0,-6762.0,-6715.0,-7157.0,-6478.0,-7001.0,-7349.0,-7288.0,-7429.0,-7058.0,-7320.0,0.0,0.0], xMax: [19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,19730.0,5958.0,7686.0,7721.0,7612.0,7845.0,6092.0,7183.0,6464.0,7906.0,4567.0,5611.0,5645.0,5244.0,4204.0,3168.0,2982.0,4548.0,3145.0,6305.0,5606.0,6483.0,4820.0,4735.0,7309.0,6747.0,7317.0,6225.0,7214.0,6225.0,5132.0,7996.0,7996.0,7996.0,7971.0,6901.0,6040.0,7354.0,7944.0,6097.0,5775.0,6472.0,5572.0,4640.0,4918.0,6768.0,5599.0,5321.0,6302.0,6867.0,6431.0,6193.0,6674.0,6271.0,6537.0,7273.0,7488.0,8000.0,8000.0,7744.0,7582.0,195.0,94.0])
    //static let coremotionNoLag = ModelVersion(features: "coremotion", architecture: "CNN", xMin: [], xMax: [])
    //static let allNoLag = ModelVersion(features: "all", architecture: "CNN", xMin: [], xMax: [])
    //static let polar100Lag = ModelVersion(lag: 100, architecture: "CNN", features: "polar", xMin: [], xMax: [])
    //static let coremotion100Lag = ModelVersion(lag: 100, features: "coremotion", xMin: [], xMax: [])
    let all200LagCNN = ModelVersion(lag: 200, architecture: "CNN", features: "all", xMin: [-19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -19733.0, -7872.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7957.0, -7905.0, -7957.0, -7943.0, -7957.0, -7957.0, -7474.0, -7067.0, -7698.0, -7914.0, -7988.0, -7988.0, -7778.0, -7485.0, -7960.0, -7519.0, -5671.0, -7689.0, -7988.0, -7988.0, -7988.0, -7988.0, -7287.0, -6070.0, -5641.0, -5178.0, -7820.0, -7988.0, -7988.0, -7988.0, -7973.0, -7240.0, -7101.0, -7973.0, -7973.0, -7973.0, -7972.0, -7973.0, -7973.0, -7973.0, -6762.0, -6715.0, -7157.0, -6478.0, -7001.0, -7349.0, -7288.0, -7429.0, -7058.0, -7320.0, -6.04580926895142, -6.70586061477661, -6.69966077804565, -9.54668617248535, -14.1094083786011, -11.360408782959, -0.999957799911499, -0.996072292327881, -0.999709129333496, -101.438079833984, -66.4756088256836, -63.7047119140625, -3.14155947696207, -1.57040479353079, -3.14101491937983, -359.597382426262, 170.0, 72.0], xMax: [19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 19730.0, 5958.0, 7686.0, 7721.0, 7612.0, 7845.0, 6092.0, 7183.0, 6464.0, 7906.0, 4567.0, 5611.0, 5645.0, 5244.0, 4204.0, 3168.0, 2982.0, 4548.0, 3145.0, 6305.0, 5606.0, 6483.0, 4820.0, 4735.0, 7309.0, 6747.0, 7317.0, 6225.0, 7214.0, 6225.0, 5132.0, 7996.0, 7996.0, 7996.0, 7971.0, 6901.0, 6040.0, 7354.0, 7944.0, 6097.0, 5775.0, 6472.0, 5572.0, 4640.0, 4918.0, 6768.0, 5599.0, 5321.0, 6302.0, 6867.0, 6431.0, 6193.0, 6674.0, 6271.0, 6537.0, 7273.0, 7488.0, 8000.0, 8000.0, 7744.0, 7582.0, 5.019299507141110, 6.908624649047850, 6.438325881958010, 13.310121536254900, 16.45182991027830, 9.35778522491455, 0.9994904398918150, 0.9999999403953550, 0.9997871518135070,  50.75470733642580, 73.22154235839840, 65.48968505859380, 3.1413975712009600, 1.4821364471197100, 3.141467851955360, 359.64590135216700, 195.0, 94.0])
    
    func getModel(arch: String, features: String, lag: Int) -> ModelVersion {
        return self.polarNoLagResNet
        /*if lag == 0 {
            if arch == "CNN" {
                if features == "all" {
                    return nil
                } else if features == "polar" {
                    return self.polarNoLagCNN
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            } else if arch == "LSTM" {
                if features == "all" {
                    return nil
                } else if features == "polar" {
                    return nil
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            }
        } else if lag == 100 {
            if arch == "CNN" {
                if features == "all" {
                    return nil
                } else if features == "polar" {
                    return nil
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            } else if arch == "LSTM" {
                if features == "all" {
                    return nil
                } else if features == "polar" {
                    return nil
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            }
        } else if lag == 200 {
            if arch == "CNN" {
                if features == "all" {
                    return self.all200LagCNN
                } else if features == "polar" {
                    return nil
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            } else if arch == "LSTM" {
                if features == "all" {
                    return nil
                } else if features == "polar" {
                    return nil
                } else if features == "coremotion" {
                    return nil
                } else if features == "acc" {
                    return nil
                } else if features == "ecg" {
                    return nil
                }
            }
        }
        return nil*/
    }
}
