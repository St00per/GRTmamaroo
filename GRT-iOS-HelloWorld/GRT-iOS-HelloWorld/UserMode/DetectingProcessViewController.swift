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
    
    var carRideCount: UInt = 0
    var kangarooCount: UInt = 0
    var treeSwingCount: UInt = 0
    var rockAByeCount: UInt = 0
    var waveCount: UInt = 0
    var currentClassLabel = 0 as UInt
    var labelUpdateTime = Date.timeIntervalSinceReferenceDate
    var predictionTime: Double = 0
    var startCountTime: Double = 0
    var gestureCounts: [Int] = [0,0,0,0,0]
    var frequencyCount: Int = 0
    let vector = VectorDouble()
    var pipeline: GestureRecognitionPipeline?
    fileprivate let accelerometerManager = AccelerometerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.pipeline = appDelegate.pipeline!
        
        initPipeline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        accelerometerManager.stop()
        resetGestureCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetGestureCount()
        frequencyCount = 0
    }
    
    func resetGestureCount() {
        carRideCount = 0
        kangarooCount = 0
        treeSwingCount = 0
        rockAByeCount = 0
        waveCount = 0
    }
    
    func initPipeline() {
        
        //Load the GRT pipeline and the training data files from the documents directory
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let pipelineURL = documentsUrl.appendingPathComponent("train.grt")
        let classificiationDataURL = documentsUrl.appendingPathComponent("trainingData.csv")
        
        let pipelineResult:Bool = pipeline!.load(pipelineURL)
        let classificationDataResult:Bool = pipeline!.loadClassificationData(classificiationDataURL)
        
        if pipelineResult == false {
            let userAlert = UIAlertController(title: "Error", message: "Couldn't load pipeline", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
            self.present(userAlert, animated: true, completion: { _ in })
        }
        
        if classificationDataResult == false {
            let userAlert = UIAlertController(title: "Error", message: "Couldn't load classification data", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
            
            //If the files have been loaded successfully, we can train the pipeline, and then start real-time gesture prediction
        else if (classificationDataResult && pipelineResult) {
            pipeline?.train()
            performGesturePrediction()
        }
    }
    
    func performGesturePrediction() {
        accelerometerManager.start { (deviceMotion) -> Void in
            self.predictionTime += 0.01
            //print(self.predictionTime)
            self.vector.clear()
            self.vector.pushBack(deviceMotion.userAcceleration.x)
            self.vector.pushBack(deviceMotion.userAcceleration.y)
            self.vector.pushBack(deviceMotion.userAcceleration.z)
            self.vector.pushBack(deviceMotion.rotationRate.x)
            self.vector.pushBack(deviceMotion.rotationRate.y)
            self.vector.pushBack(deviceMotion.rotationRate.z)
            if deviceMotion.userAcceleration.z >= 1 || deviceMotion.userAcceleration.z <= -1 {
                self.frequencyCount += 1
            }
            
            //Use the incoming accellerometer data to predict what the performed gesture class is
            self.pipeline?.predict(self.vector)
            
            DispatchQueue.main.async {
                self.updateGestureCountLabels(gesture: (self.pipeline?.predictedClassLabel)!)
                
                
            }
            
        }
    }
    
    func updateGestureCountLabels(gesture: UInt) {
        
        if gesture == 0 {
            //do nothing
        } else if (gesture == 1) {
            carRideCount += 1
            gestureCounts[0] += 1
        } else if (gesture == 2) {
            kangarooCount += 1
            gestureCounts[1] += 1
        } else if (gesture == 3) {
            treeSwingCount += 1
            gestureCounts[2] += 1
        } else if (gesture == 4) {
            rockAByeCount += 1
            gestureCounts[3] += 1
        } else if (gesture == 5) {
            waveCount += 1
            gestureCounts[4] += 1
        }
        //print ("CAR RIDE: \(carRideCount) KANGAROO: \(kangarooCount) TREESWING: \(treeSwingCount) ROCKABYE: \(rockAByeCount) WAVE: \(waveCount)/n")
//        if kangarooCount == 1 {
//            startCountTime = predictionTime
//        }
        if kangarooCount >= 5 {
            accelerometerManager.stop()
            //print("FREQUENCY: \(frequencyCount)")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PatternDetected", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PatternDetectedViewController") as? PatternDetectedViewController else {
                return
            }
            desVC.patternSpeed = speedCheck()
            desVC.detectedPattern = "Kangaroo"
            show(desVC, sender: nil)
        }
    }
    
    func speedCheck() -> Int {
        if frequencyCount > 0 && frequencyCount < 20 {
            return 1
        }
        if frequencyCount > 20 && frequencyCount < 50 {
            return 2
        }
        if frequencyCount > 50 && frequencyCount < 100 {
            return 3
        }
        if frequencyCount > 100 && frequencyCount < 200 {
            return 4
        }
        if frequencyCount > 200 {
            return 5
        }
        return 0
    }
    
    func patternSpeedCalculation() -> Int {
        let incrementSpeed = Double(kangarooCount)/(predictionTime-startCountTime)
        print (incrementSpeed)
        return Int(incrementSpeed)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
