//
//  CoreMotionManager.swift
//  WatchGRT
//
//  Created by M J on 02/12/15.
//  Copyright © 2015 jahnen. All rights reserved.
//  Modified by Nick Arner
//

import Foundation
import CoreMotion

class AccelerometerManager {
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    
    init() {
        motionQueue.name = "CoreMotion"
        
        motionManager.accelerometerUpdateInterval = 1/60.0
    }
    
    func start(handler: @escaping (_ deviceMotion: CMDeviceMotion) -> Void) {
        
       
        motionManager.startDeviceMotionUpdates(to: motionQueue) {
            (data, error) in
            guard let data = data else { return }
            handler(data)
        }
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}
