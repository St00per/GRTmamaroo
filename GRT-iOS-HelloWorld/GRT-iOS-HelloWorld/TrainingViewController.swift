//
//  TrainingViewController.swift
//  GRT-iOS-HelloWorld
//
//  Created by Nicholas Arner on 8/17/17.
//  Copyright © 2017 Nicholas Arner. All rights reserved.
//

import UIKit
import GRTiOS
import SwiftR

class TrainingViewController: UIViewController {

    @IBOutlet var gestureSelector: UISegmentedControl!
    @IBOutlet var trainButton: UIButton!
    @IBOutlet weak var graphView: SRMergePlotView! {
        didSet {
            graphView.title = "Accelerometer Data"
            graphView.totalSecondsToDisplay = 0.5
        }
    }
    
    fileprivate let accelerometerManager = AccelerometerManager()
    fileprivate var currentFilePath: String!
    fileprivate var currentFileHandle: FileHandle?
    
    var trainButtonSelected:Bool = false
    var pipeline: GestureRecognitionPipeline?

    fileprivate var anotherDataTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        trainButton.addTarget(self, action:#selector(TrainBtnPressed(_:)), for: .touchDown);
        trainButton.addTarget(self, action:#selector(TrainBtnReleased(_:)), for: .touchUpInside);
        
        graphView.totalChannelsToDisplay = 3

        //Create an instance of a GRT pipeline
        self.pipeline = appDelegate.pipeline!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAccellerometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerManager.stop()
    }
    
    func startAccellerometer() {

        accelerometerManager.start( handler: { (deviceMotion) -> Void in
            let gestureClass = self.gestureSelector.selectedSegmentIndex

            //Add the accellerometer data to a vector, which is how we'll store the classification data
            let vector = VectorFloat()
            vector.clear()
            vector.pushBack(deviceMotion.userAcceleration.x)
            vector.pushBack(deviceMotion.userAcceleration.y)
            vector.pushBack(deviceMotion.userAcceleration.z)
            vector.pushBack(deviceMotion.magneticField.field.x)
            vector.pushBack(deviceMotion.magneticField.field.y)
            vector.pushBack(deviceMotion.magneticField.field.z)
            vector.pushBack(deviceMotion.gravity.x)
            vector.pushBack(deviceMotion.gravity.y)
            vector.pushBack(deviceMotion.gravity.z)
            
//            print("x", x)
//            print("y", y)
//            print("z", z)
//            print("Gesture class is %@", gestureClass);
            self.graphView.addData([deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z])
            
            if (self.trainButton.isSelected == true) {
                self.pipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
            }
        })
    }
    
    func TrainBtnPressed(_ sender: Any) {
        trainButton.isSelected = true
    }
    
    func TrainBtnReleased(_ sender: Any) {
        trainButton.isSelected = false
    }
  
    
    @IBAction func savePipeline(_ sender: Any) {
        // Set URL for saving the pipeline to
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pipelineURL = documentsUrl.appendingPathComponent("train.grt")
        
        // Remove the pipeline if it already exists
        let _ = try? FileManager.default.removeItem(at: pipelineURL)

        let pipelineSaveResult = self.pipeline?.save(pipelineURL)
        if !pipelineSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        
        // Save the training data as a CSV file
        let classificiationDataURL = documentsUrl.appendingPathComponent("trainingData.csv")

        let _ = try? FileManager.default.removeItem(at: classificiationDataURL)

        let classificationSaveResult = self.pipeline?.saveClassificationData(classificiationDataURL)
        
        if !classificationSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
    }
    
//    @IBAction func shareData(_ sender: UIButton) {
//
//        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        let pipelineURL = documentsUrl.appendingPathComponent("train.grt")
//        let classificiationDataURL = documentsUrl.appendingPathComponent("trainingData.csv")
//
//        do {
//
//            let pipelineURL = NSURL(fileURLWithPath: String(pipelineURL))
//            let classificationDataURL = NSURL(fileURLWithPath: <#T##String#>)
//            let objectsToShare = [fileURL,]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//            self.presentViewController(activityVC, animated: true, completion: nil)
//
//        } catch {
//            print("cannot write file")
//            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//        }
//
//    }
}

