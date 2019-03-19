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
    var iterationCount: Int = 0
    
    var trainButtonSelected:Bool = false
    
    var pipeline: GestureRecognitionPipeline?
    let vector = VectorFloat()

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
    
    override func viewDidAppear(_ animated: Bool) {
        startAccellerometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerManager.stop()
    }
    
    func startAccellerometer() {

        accelerometerManager.start( handler: { (deviceMotion) -> Void in
            
            let gestureClass = self.gestureSelector.selectedSegmentIndex
            
            //Add the accellerometer data to a vector, which is how we'll store the classification data
 
            self.graphView.addData([deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z])
            
            if (self.trainButton.isSelected == true) {
//                self.iterationCount += 1
//                print (self.iterationCount)
                self.vector.pushBack(deviceMotion.userAcceleration.x)
                self.vector.pushBack(deviceMotion.userAcceleration.y)
                self.vector.pushBack(deviceMotion.userAcceleration.z)
                self.vector.pushBack(deviceMotion.rotationRate.x)
                self.vector.pushBack(deviceMotion.rotationRate.y)
                self.vector.pushBack(deviceMotion.rotationRate.z)
                //if self.iterationCount == 20 {
                    self.pipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), self.vector)
                    self.vector = VectorFloat
                
                    self.iterationCount = 0
                //}
            }
        })
    }
    
    func TrainBtnPressed(_ sender: Any) {
        trainButton.isSelected = true
        vector.clear()
    }
    
    func TrainBtnReleased(_ sender: Any) {
        trainButton.isSelected = false
    }
  
    @IBAction func savePipeline(_ sender: Any) {
        // Set URL for saving the pipeline to
        let documentsUrlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsPipelineUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let tempPipelineDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")

        
        //create Temp directory if it does not exist
        let tempDirectoryString = documentsUrlString + "/Temp"
        var objectBool: ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: tempDirectoryString, isDirectory: &objectBool)
        if !isExist {
            do {
                try FileManager.default.createDirectory(atPath: tempDirectoryString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                let userAlert = UIAlertController(title: "Error", message: "Failed to create temp directory", preferredStyle: .alert)
                self.present(userAlert, animated: true, completion: { _ in })
                let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                userAlert.addAction(cancel)
            }
        }
        
        //Save current pipeline and training data as a CSV file to temp before deleting previous
        let pipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainPipeline.grt")
        let pipelineTempSaveResult = self.pipeline?.save(pipelineTempURL)
        if !pipelineTempSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        // Save the training data as a CSV file to temp directory
        let classificiationDataPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainingPipelineData.csv")
        let classificationTempPipelineSaveResult = self.pipeline?.saveClassificationData(classificiationDataPipelineTempURL)
        if !classificationTempPipelineSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        

        
        let pipelineURL = documentsPipelineUrl.appendingPathComponent("trainPipeline.grt")
        let classificiationPipelineDataURL = documentsPipelineUrl.appendingPathComponent("trainingPipelineData.csv")
        

        
        //if pipelineTempSaveResult ?? false, classificationTempPipelineSaveResult ?? false {
            // Remove the pipeline if it already exists if temp save is ok
            let _ = try? FileManager.default.removeItem(at: pipelineURL)
            let _ = try? FileManager.default.removeItem(at: classificiationPipelineDataURL)
            
            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempURL, to: pipelineURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataPipelineTempURL, to: classificiationPipelineDataURL)
//        }
        

        
    }
    
    @IBAction func showUserMode(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "UserModeMain", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "UserModeMainViewController") as? UserModeMainViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    

}

