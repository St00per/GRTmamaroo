
//
//  PredictionViewController.swift
//  GRT-iOS-HelloWorld
//
//  Created by Nicholas Arner on 8/22/17.
//  Copyright © 2017 Nicholas Arner. All rights reserved.
//

import UIKit
import GRTiOS
import SwiftR

class PredictionViewController: UIViewController {
    
    @IBOutlet var carRideCountLabel: UILabel!
    @IBOutlet var kangarooCountLabel: UILabel!
    @IBOutlet var treeSwingCountLabel: UILabel!
    @IBOutlet var rockAByeCountLabel: UILabel!
    @IBOutlet var waveCountLabel: UILabel!
    
    
    @IBOutlet weak var graphView: SRMergePlotView! {
        didSet {
            graphView.title = "Accelerometer Data"
            graphView.totalSecondsToDisplay = 0.5
        }
    }

    var carRideCount: UInt = 0
    var kangarooCount: UInt = 0
    var treeSwingCount: UInt = 0
    var rockAByeCount: UInt = 0
    var waveCount: UInt = 0
    
    fileprivate let accelerometerManager = AccelerometerManager()

    var currentClassLabel = 0 as UInt
    var labelUpdateTime = Date.timeIntervalSinceReferenceDate
    let vector = VectorDouble()
    var pipeline: GestureRecognitionPipeline?
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.pipeline = appDelegate.pipeline!

        //initPipeline()
        graphView.totalChannelsToDisplay = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        performGesturePrediction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerManager.stop()
        resetGestureCount()
    }
    
    func resetGestureCount() {
        carRideCountLabel.text = "CarRide: "
        kangarooCountLabel.text = "Kangaroo: "
        treeSwingCountLabel.text = "TreeSwing: "
        rockAByeCountLabel.text = "Rock-a-bye: "
        waveCountLabel.text = "Wave: "
        
        
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
            self.vector.clear()
            self.vector.pushBack(deviceMotion.userAcceleration.x)
            self.vector.pushBack(deviceMotion.userAcceleration.y)
            self.vector.pushBack(deviceMotion.userAcceleration.z)
            self.vector.pushBack(deviceMotion.rotationRate.x)
            self.vector.pushBack(deviceMotion.rotationRate.y)
            self.vector.pushBack(deviceMotion.rotationRate.z)
            
            //Use the incoming accellerometer data to predict what the performed gesture class is
            self.pipeline?.predict(self.vector)

            DispatchQueue.main.async {
                self.updateGestureCountLabels(gesture: (self.pipeline?.predictedClassLabel)!)
                self.graphView.addData([deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z])
            }
            
        }
    }
    
    func updateGestureCountLabels(gesture: UInt) {
        
        if gesture == 0 {
            //do nothing
        } else if (gesture == 1) {
            carRideCount += 1
            let carRideCountVal = String(carRideCount)
            carRideCountLabel.text = ("CarRide: " + carRideCountVal)
        } else if (gesture == 2) {
            kangarooCount += 1
            let kangarooCountVal = String(kangarooCount)
            kangarooCountLabel.text = ("Kangaroo: " + kangarooCountVal)
        } else if (gesture == 3) {
            treeSwingCount += 1
            let treeSwingCountVal = String(treeSwingCount)
            treeSwingCountLabel.text = ("TreeSwing: " + treeSwingCountVal)
        } else if (gesture == 4) {
            rockAByeCount += 1
            let rockAByeCountVal = String(rockAByeCount)
            rockAByeCountLabel.text = ("RockABye: " + rockAByeCountVal)
        } else if (gesture == 5) {
            waveCount += 1
            let waveCountVal = String(waveCount)
            waveCountLabel.text = ("Wave: " + waveCountVal)
        }
    }
}
