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
        getureIsRecognized = true
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
            if deviceMotion.userAcceleration.z >= 0.3 || deviceMotion.userAcceleration.z <= -0.3 {
                self.frequencyCount += 1
            }
            
            //Use the incoming accellerometer data to predict what the performed gesture class is
            if !self.getureIsRecognized {
                self.pipeline?.predict(self.vector)
                DispatchQueue.main.async {
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
    
    func patternCheck() -> String {
        guard let maxCount = gestureCounts.max() else { return "" }
        let gestureIndex = gestureCounts.firstIndex{ $0 == maxCount }
        
        switch gestureIndex {
        case 0:
            return "CarRide"
        case 1:
            return "Kangaroo"
        case 2:
            return "TreeSwing"
        case 3:
            return "RockABye"
        case 4:
            return "Wave"
        default:
            return ""
        }
    }
    
    func speedCheck(pattern: String) -> Int {
        let speedIndex = Double(frequencyCount)/predictionTime
        let speedValue = pattern
        switch speedValue {
        case "CarRide":
            switch speedIndex {
            case 0..<5:
                return 1
            case 5..<10:
                return 2
            case 10..<15:
                return 3
            case 15..<20:
                return 4
            case 20..<500:
                return 5
            default:
                return 0
            }
        case "Kangaroo":
            switch speedIndex {
            case 0..<5:
                return 1
            case 5..<10:
                return 2
            case 10..<15:
                return 3
            case 15..<20:
                return 4
            case 20..<500:
                return 5
            default:
                return 0
            }
        case "TreeSwing":
            switch speedIndex {
            case 0..<5:
                return 1
            case 5..<10:
                return 2
            case 10..<15:
                return 3
            case 15..<20:
                return 4
            case 20..<500:
                return 5
            default:
                return 0
            }
        case "RockABye":
            switch speedIndex {
            case 0..<5:
                return 1
            case 5..<10:
                return 2
            case 10..<15:
                return 3
            case 15..<20:
                return 4
            case 20..<500:
                return 5
            default:
                return 0
            }
        case "Wave":
            switch speedIndex {
            case 0..<5:
                return 1
            case 5..<10:
                return 2
            case 10..<15:
                return 3
            case 15..<20:
                return 4
            case 20..<500:
                return 5
            default:
                return 0
            }
        default:
            return 0
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
        
        if frequencyCount > 350 || predictionTime > 9 {
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
        if ((gestureCounts.max() ?? 0) - sortedArray[3] >= 3 && predictionTime > 3) || (gestureCounts.max() ?? 0) >= 7 {
            accelerometerManager.stop()
            getureIsRecognized = true
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PatternDetected", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PatternDetectedViewController") as? PatternDetectedViewController else {
                return
            }
            desVC.detectedPattern = patternCheck()
            desVC.patternSpeed = speedCheck(pattern: patternCheck())
            show(desVC, sender: nil)
        }
    }
    
    
    
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
