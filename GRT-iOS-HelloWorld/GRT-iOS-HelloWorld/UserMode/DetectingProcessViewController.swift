//
//  DetectingProcessViewController.swift
//  mamaroo
//
//  Created by Kirill Shteffen on 19/02/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit
import GRTiOS
import SwiftR

class DetectingProcessViewController: UIViewController {

    var currentClassLabel = 0 as UInt
    var labelUpdateTime = Date.timeIntervalSinceReferenceDate
    var predictionTime: Double = 0
    var getureIsRecognized = false
    var gestureCounts: [Int] = [0,0,0,0,0]
    var frequencyCount: Int = 0
    let vector = VectorDouble()
    var pipeline: GestureRecognitionPipeline?
    fileprivate let accelerometerManager = AccelerometerManager()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var countsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.pipeline = appDelegate.pipeline!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        performGesturePrediction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        accelerometerManager.stop()
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        frequencyCount = 0
        gestureCounts = [0,0,0,0,0]
        getureIsRecognized = false
        predictionTime = 0
    }

    
    func performGesturePrediction() {
        accelerometerManager.start { (deviceMotion) -> Void in
            if self.frequencyCount > 1 {
                self.predictionTime += 0.01
            }
            self.vector.clear()
            self.vector.pushBack(deviceMotion.userAcceleration.x)
            self.vector.pushBack(deviceMotion.userAcceleration.y)
            self.vector.pushBack(deviceMotion.userAcceleration.z)
            self.vector.pushBack(deviceMotion.rotationRate.x)
            self.vector.pushBack(deviceMotion.rotationRate.y)
            self.vector.pushBack(deviceMotion.rotationRate.z)
            if deviceMotion.userAcceleration.z >= 0.4 || deviceMotion.userAcceleration.z <= -0.4 {
                self.frequencyCount += 1
            }
            
            //Use the incoming accellerometer data to predict what the performed gesture class is
            self.pipeline?.predict(self.vector)
            DispatchQueue.main.async {
                if !self.getureIsRecognized {
                    self.updateGestureCounts(gesture: (self.pipeline?.predictedClassLabel)!)
                }
            }
        }
    }
    
    func updateCountLabels() {
        let counts = countsView.subviews
        
        for index in 0..<counts.count {
            if let label = counts[index] as? UILabel {
                label.text = String(gestureCounts[index])
            }
        }
        
    }
    
    func updateGestureCounts(gesture: UInt) {
        activityIndicator.startAnimating()
        if gesture == 0 {
            //do nothing
        } else if (gesture == 1) {
            gestureCounts[0] += 1
        } else if (gesture == 2) {
            gestureCounts[1] += 1
        } else if (gesture == 3) {
            gestureCounts[2] += 1
        } else if (gesture == 4) {
            gestureCounts[3] += 1
        } else if (gesture == 5) {
            gestureCounts[4] += 1
        }
        print (gestureCounts)
        updateCountLabels()
        
        if frequencyCount > 350 || predictionTime > 8 {
            accelerometerManager.stop()
            getureIsRecognized = true
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PatternDetected", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PatternDetectedViewController") as? PatternDetectedViewController else {
                return
            }
            desVC.patternSpeed = 0
            desVC.detectedPattern = "Error"
            show(desVC, sender: nil)
        }
        
        let sortedArray = gestureCounts.sorted()
        if (gestureCounts.max() ?? 0) - sortedArray[3] >= 3 {
            accelerometerManager.stop()
            getureIsRecognized = true
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PatternDetected", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PatternDetectedViewController") as? PatternDetectedViewController else {
                return
            }
            desVC.patternSpeed = speedCheck()
            desVC.detectedPattern = patternCheck()
            show(desVC, sender: nil)
        }
    }
    
    func speedCheck() -> Int {
        let speedIndex = Double(frequencyCount)/predictionTime
        if speedIndex > 0 && speedIndex < 5 {
            return 1
        }
        if speedIndex > 5 && speedIndex < 10 {
            return 2
        }
        if speedIndex > 10 && speedIndex < 15 {
            return 3
        }
        if speedIndex > 15 && speedIndex < 20 {
            return 4
        }
        if speedIndex > 20 {
            return 5
        }
        return 0
    }
    
    func patternCheck() -> String {
        guard let maxCount = gestureCounts.max() else { return "" }
        let gestureIndex = gestureCounts.firstIndex{ $0 == maxCount }
        if gestureIndex == 0 {
            return "CarRide"
        }
        if gestureIndex == 1 {
            return "Kangaroo"
        }
        if gestureIndex == 2 {
            return "TreeSwing"
        }
        if gestureIndex == 3 {
            return "RockABye"
        }
        if gestureIndex == 4 {
            return "Wave"
        }
        return ""
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
