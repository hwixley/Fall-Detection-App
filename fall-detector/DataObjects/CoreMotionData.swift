//
//  CoreMotionData.swift
//  fall-detector
//
//  Created by Harry Wixley on 24/02/2022.
//

import Foundation
import CoreMotion

class CoreMotionData : ObservableObject {
    let motionManager = CMMotionManager()
    var started = false
    var timer : Timer? = nil
    
    var acc : [Coord] = []
    var gyr : [Coord] = []
    var gra : [Coord] = []
    var mag : [Coord] = []
    var att : [Coord] = [] // x = pitch , y = roll , z = yaw
    var dhe : [Float32] = []
    
    var lastHeading = -999.0
    
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
        self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { data, error in
            guard let motionData = data, error == nil else {
                return
            }
            
            self.acc.append(Coord(x: motionData.userAcceleration.x, y: motionData.userAcceleration.y, z: motionData.userAcceleration.z))
            self.gyr.append(Coord(x: motionData.rotationRate.x, y: motionData.rotationRate.y, z: motionData.rotationRate.z))
            self.gra.append(Coord(x: motionData.gravity.x, y: motionData.gravity.y, z: motionData.gravity.z))
            self.mag.append(Coord(x: motionData.magneticField.field.x, y: motionData.magneticField.field.y, z: motionData.magneticField.field.z))
            self.att.append(Coord(x: motionData.attitude.pitch, y: motionData.attitude.roll, z: motionData.attitude.yaw))
            
            if self.lastHeading == -999 {
                self.dhe.append(0.0)
                self.lastHeading = motionData.heading
            } else {
                self.dhe.append(Float32(motionData.heading - self.lastHeading))
                self.lastHeading = motionData.heading
            }
        }
    }
}

struct Coord {
    var x: Float32
    var y: Float32
    var z: Float32
    
    init(x: Double, y: Double, z: Double) {
        self.x = Float32(x)
        self.y = Float32(y)
        self.z = Float32(z)
    }
}
