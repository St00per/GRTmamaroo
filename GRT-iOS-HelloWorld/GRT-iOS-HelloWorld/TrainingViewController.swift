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
    
    //var pipeline: GestureRecognitionPipeline?
    //var verticalPipeline: GestureRecognitionPipeline?
    var fastPipeline: GestureRecognitionPipeline?
    
    var trainStart: Bool = false
    var gestureClass: Int = 0
    
    var serialQueue = DispatchQueue(label: "Sync_queue");
    
    fileprivate var anotherDataTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        trainButton.addTarget(self, action:#selector(TrainBtnPressed(_:)), for: .touchDown);
        trainButton.addTarget(self, action:#selector(TrainBtnReleased(_:)), for: .touchUpInside);
        
        graphView.totalChannelsToDisplay = 3
        
        //Create an instance of a GRT pipeline
        //self.pipeline = appDelegate.pipeline!
        //self.verticalPipeline = appDelegate.verticalPipeline!
        self.fastPipeline = appDelegate.fastPipeline!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAccellerometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerManager.stop()
    }
    
    func startAccellerometer() {
        accelerometerManager.start( handler: { [unowned self] (deviceMotion) -> Void in
            let gestureClass = self.gestureClass
            
            //Add the accellerometer data to a vector, which is how we'll store the classification data
            self.graphView.addData([deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z])
            self.serialQueue.sync { [unowned self] in
                let vector = VectorFloat()
                
                vector.pushBack(deviceMotion.userAcceleration.x)
                vector.pushBack(deviceMotion.userAcceleration.y)
                vector.pushBack(deviceMotion.userAcceleration.z)
                vector.pushBack(deviceMotion.rotationRate.x)
                vector.pushBack(deviceMotion.rotationRate.y)
                vector.pushBack(deviceMotion.rotationRate.z)
                
                if self.trainButton.isSelected {
                    if deviceMotion.attitude.pitch > 0.9 {
                        //                        self.verticalPipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
                        //                        self.iterationCount += 1
                        //                        print (self.iterationCount)
                    } else {
                        //                    self.pipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
                        //                    self.iterationCount += 1
                        //                    print (self.iterationCount)
                        if abs(deviceMotion.userAcceleration.z) > 0.4 {
                            self.fastPipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
                            self.iterationCount += 1
                            print (self.iterationCount)
                        }
                    }
                }
            }
        })
    }
    
    func TrainBtnPressed(_ sender: Any) {
        trainButton.isSelected = true
    }
    
    func TrainBtnReleased(_ sender: Any) {
        trainButton.isSelected = false
    }
    
    @IBAction func gestureSelected(_ sender: Any) {
        gestureClass = gestureSelector.selectedSegmentIndex
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
        //        let pipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainPipeline.grt")
        //        let pipelineTempSaveResult = self.pipeline?.save(pipelineTempURL)
        
        let fastPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainFastPipeline.grt")
        let fastPipelineTempSaveResult = self.fastPipeline?.save(fastPipelineTempURL)
        
        //        let verticalPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainVerticalPipeline.grt")
        //        let verticalPipelineTempSaveResult = self.verticalPipeline?.save(verticalPipelineTempURL)
        
        //        if !pipelineTempSaveResult! {
        //            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
        //            self.present(userAlert, animated: true, completion: { _ in })
        //            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        //            userAlert.addAction(cancel)
        //        }
        
        if !fastPipelineTempSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        
        //        if !verticalPipelineTempSaveResult! {
        //            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
        //            self.present(userAlert, animated: true, completion: { _ in })
        //            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        //            userAlert.addAction(cancel)
        //        }
        
        // Save the training data as a CSV file to temp directory
        //        let classificiationDataPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainingPipelineData.csv")
        //        let classificationTempPipelineSaveResult = self.pipeline?.saveClassificationData(classificiationDataPipelineTempURL)
        
        let classificiationDataFastPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainingFastPipelineData.csv")
        let classificationTempFastPipelineSaveResult = self.fastPipeline?.saveClassificationData(classificiationDataFastPipelineTempURL)
        
        
        //        let classificiationDataVerticalPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainingVerticalPipelineData.csv")
        //        let classificationTempVerticalPipelineSaveResult = self.verticalPipeline?.saveClassificationData(classificiationDataVerticalPipelineTempURL)
        
        //        if !classificationTempPipelineSaveResult! {
        //            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
        //            self.present(userAlert, animated: true, completion: { _ in })
        //            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        //            userAlert.addAction(cancel)
        //        }
        
        if !classificationTempFastPipelineSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        
        //        if !classificationTempVerticalPipelineSaveResult! {
        //            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
        //            self.present(userAlert, animated: true, completion: { _ in })
        //            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        //            userAlert.addAction(cancel)
        //        }
        
        //        let pipelineURL = documentsPipelineUrl.appendingPathComponent("trainPipeline.grt")
        //        let classificiationPipelineDataURL = documentsPipelineUrl.appendingPathComponent("trainingPipelineData.csv")
        
        let fastPipelineURL = documentsPipelineUrl.appendingPathComponent("trainFastPipeline.grt")
        let classificiationFastPipelineDataURL = documentsPipelineUrl.appendingPathComponent("trainingFastPipelineData.csv")
        
        //        let verticalPipelineURL = documentsPipelineUrl.appendingPathComponent("trainVerticalPipeline.grt")
        //        let classificiationVerticalPipelineDataURL = documentsPipelineUrl.appendingPathComponent("trainingVerticalPipelineData.csv")
        
        //        if pipelineTempSaveResult ?? false, classificationTempPipelineSaveResult ?? false {
        //            // Remove the pipeline if it already exists if temp save is ok
        //            //            let _ = try? FileManager.default.removeItem(at: pipelineTempURL)
        //            //            let _ = try? FileManager.default.removeItem(at: classificiationDataPipelineTempURL)
        //            let _ = try? FileManager.default.removeItem(at: pipelineURL)
        //            let _ = try? FileManager.default.removeItem(at: classificiationPipelineDataURL)
        //
        //            //Copy files from temporary folder
        //            let _ = try? FileManager.default.copyItem(at: pipelineTempURL, to: pipelineURL)
        //            let _ = try? FileManager.default.copyItem(at: classificiationDataPipelineTempURL, to: classificiationPipelineDataURL)
        //        }
        
        if classificationTempFastPipelineSaveResult ?? false, fastPipelineTempSaveResult ?? false {
            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: fastPipelineTempURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationDataFastPipelineTempURL)
            let _ = try? FileManager.default.removeItem(at: fastPipelineURL)
            let _ = try? FileManager.default.removeItem(at: classificiationFastPipelineDataURL)
            
            //Copy files from temporary folder
            let _ = try? FileManager.default.copyItem(at: fastPipelineTempURL, to: fastPipelineURL)
            let _ = try? FileManager.default.copyItem(at: classificiationDataFastPipelineTempURL, to: classificiationFastPipelineDataURL)
        }
    
        //        if verticalPipelineTempSaveResult ?? false, classificationTempVerticalPipelineSaveResult ?? false {
        //            // Remove the pipeline if it already exists if temp save is ok
        //            //            let _ = try? FileManager.default.removeItem(at: pipelineTempURL)
        //            //            let _ = try? FileManager.default.removeItem(at: classificiationDataPipelineTempURL)
        //            let _ = try? FileManager.default.removeItem(at: verticalPipelineURL)
        //            let _ = try? FileManager.default.removeItem(at: classificiationVerticalPipelineDataURL)
        //
        //            //Copy files from temporary folder
        //            let _ = try? FileManager.default.copyItem(at: verticalPipelineTempURL, to: verticalPipelineURL)
        //            let _ = try? FileManager.default.copyItem(at: classificiationDataVerticalPipelineTempURL, to: classificiationVerticalPipelineDataURL)
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

