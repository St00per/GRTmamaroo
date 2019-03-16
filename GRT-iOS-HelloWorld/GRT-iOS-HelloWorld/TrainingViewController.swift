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
//    var pipelineOne: GestureRecognitionPipeline?
//    var pipelineTwo: GestureRecognitionPipeline?
//    var pipelineThree: GestureRecognitionPipeline?
//    var pipelineFour: GestureRecognitionPipeline?
//    var pipelineFive: GestureRecognitionPipeline?
    
    var pipelineVerticalOne: GestureRecognitionPipeline?
    var pipelineVerticalTwo: GestureRecognitionPipeline?
    
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
//        self.pipelineOne = appDelegate.pipelineOne!
//        self.pipelineTwo = appDelegate.pipelineTwo!
//        self.pipelineThree = appDelegate.pipelineThree!
//        self.pipelineFour = appDelegate.pipelineFour!
//        self.pipelineFive = appDelegate.pipelineFive!
        
//        self.pipelineVerticalOne = appDelegate.pipelineVerticalOne!
//        self.pipelineVerticalTwo = appDelegate.pipelineVerticalTwo!
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAccellerometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerManager.stop()
    }
    
    func startAccellerometer() {

        accelerometerManager.start( handler: { (deviceMotion) -> Void in
            self.iterationCount += 1
            let gestureClass = self.gestureSelector.selectedSegmentIndex
            
            //Add the accellerometer data to a vector, which is how we'll store the classification data
            let vector = VectorFloat()
            
            //vector.clear()
            vector.pushBack(deviceMotion.userAcceleration.x)
            vector.pushBack(deviceMotion.userAcceleration.y)
            vector.pushBack(deviceMotion.userAcceleration.z)
            vector.pushBack(deviceMotion.rotationRate.x)
            vector.pushBack(deviceMotion.rotationRate.y)
            vector.pushBack(deviceMotion.rotationRate.z)
//            vector.pushBack(deviceMotion.attitude.pitch)
//            vector.pushBack(deviceMotion.attitude.yaw)
//            vector.pushBack(deviceMotion.attitude.roll)
            if self.iterationCount == 300 {
                self.pipeline!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
                vector.clear()
            }
//            print("x", x)
//            print("y", y)
//            print("z", z)
//            print("Gesture class is %@", gestureClass);
            self.graphView.addData([deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z])
            
//            if (self.trainButton.isSelected == true) {
//                if gestureClass == 0 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//
//                      self.pipelineVerticalOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//                      //self.pipelineVerticalTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//                }
//                if gestureClass == 1 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//
//                    self.pipelineVerticalOne!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
//                    self.pipelineVerticalTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//                }
//                if gestureClass == 2 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//                    self.pipelineVerticalOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
//                    self.pipelineVerticalTwo!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
//                }
////                if gestureClass == 3 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                }
////                if gestureClass == 4 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                }
////                if gestureClass == 5 {
////                    self.pipelineOne!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineTwo!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineThree!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFour!.addSamplesToClassificationData(forGesture: UInt(0), vector)
////                    self.pipelineFive!.addSamplesToClassificationData(forGesture: UInt(gestureClass), vector)
////                }
//            }
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
        let documentsUrlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsPipelineUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsOneUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsTwoUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsThreeUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsFourUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsFiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
//        let documentsVerticalOneUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsVerticalTwoUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let tempPipelineDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempOneDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempTwoDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempThreeDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempFourDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempFiveDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//
//        let tempVerticalOneDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
//        let tempVerticalTwoDirectory = URL(fileURLWithPath: documentsUrlString + "/Temp")
        
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
//        let pipelineTempOneURL = tempOneDirectory.appendingPathComponent("trainOne.grt")
//        let pipelineTempTwoURL = tempTwoDirectory.appendingPathComponent("trainTwo.grt")
//        let pipelineTempThreeURL = tempThreeDirectory.appendingPathComponent("trainThree.grt")
//        let pipelineTempFourURL = tempFourDirectory.appendingPathComponent("trainFour.grt")
//        let pipelineTempFiveURL = tempFiveDirectory.appendingPathComponent("trainFive.grt")
        
//        let pipelineVerticalTempOneURL = tempVerticalOneDirectory.appendingPathComponent("trainVerticalOne.grt")
//        let pipelineVerticalTempTwoURL = tempVerticalTwoDirectory.appendingPathComponent("trainVerticalTwo.grt")
        
        let pipelineTempSaveResult = self.pipeline?.save(pipelineTempURL)
        
//        let pipelineTempSaveOneResult = self.pipelineOne?.save(pipelineTempOneURL)
//        let pipelineTempSaveTwoResult = self.pipelineTwo?.save(pipelineTempTwoURL)
//        let pipelineTempSaveThreeResult = self.pipelineThree?.save(pipelineTempThreeURL)
//        let pipelineTempSaveFourResult = self.pipelineFour?.save(pipelineTempFourURL)
//        let pipelineTempSaveFiveResult = self.pipelineFive?.save(pipelineTempFiveURL)
        
//        let pipelineVerticalTempSaveOneResult = self.pipelineVerticalOne?.save(pipelineVerticalTempOneURL)
//        let pipelineVerticalTempSaveTwoResult = self.pipelineVerticalTwo?.save(pipelineVerticalTempTwoURL)
        
        
//        if !pipelineTempSaveOneResult! || !pipelineTempSaveTwoResult! || !pipelineTempSaveThreeResult! || !pipelineTempSaveFourResult! || !pipelineTempSaveFiveResult! {
       // if !pipelineVerticalTempSaveOneResult! || !pipelineVerticalTempSaveTwoResult! {
        if !pipelineTempSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save pipeline", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        
        // Save the training data as a CSV file to temp directory
        
        let classificiationDataPipelineTempURL = tempPipelineDirectory.appendingPathComponent("trainingPipelineData.csv")
        
//        let classificiationDataOneTempURL = tempOneDirectory.appendingPathComponent("trainingOneData.csv")
//        let classificiationDataTwoTempURL = tempTwoDirectory.appendingPathComponent("trainingTwoData.csv")
//        let classificiationDataThreeTempURL = tempThreeDirectory.appendingPathComponent("trainingThreeData.csv")
//        let classificiationDataFourTempURL = tempFourDirectory.appendingPathComponent("trainingFourData.csv")
//        let classificiationDataFiveTempURL = tempFiveDirectory.appendingPathComponent("trainingFiveData.csv")
        
//        let classificiationDataVerticalOneTempURL = tempVerticalOneDirectory.appendingPathComponent("trainingVerticalOneData.csv")
//        let classificiationDataVerticalTwoTempURL = tempVerticalTwoDirectory.appendingPathComponent("trainingVerticalTwoData.csv")
        
//        let classificationTempSaveOneResult = self.pipelineOne?.saveClassificationData(classificiationDataOneTempURL)
//        let classificationTempSaveTwoResult = self.pipelineTwo?.saveClassificationData(classificiationDataTwoTempURL)
//        let classificationTempSaveThreeResult = self.pipelineThree?.saveClassificationData(classificiationDataThreeTempURL)
//        let classificationTempSaveFourResult = self.pipelineFour?.saveClassificationData(classificiationDataFourTempURL)
//        let classificationTempSaveFiveResult = self.pipelineFive?.saveClassificationData(classificiationDataFiveTempURL)
        
        let classificationTempPipelineSaveResult = self.pipeline?.saveClassificationData(classificiationDataPipelineTempURL)
        
//        let classificationTempVerticalOneSaveResult = self.pipelineVerticalOne?.saveClassificationData(classificiationDataVerticalOneTempURL)
////        let classificationTempVerticalTwoSaveResult = self.pipelineVerticalTwo?.saveClassificationData(classificiationDataVerticalTwoTempURL)
        
        //if !classificationTempSaveOneResult! || !classificationTempSaveTwoResult! || !classificationTempSaveThreeResult! || !classificationTempSaveFourResult! || !classificationTempSaveFiveResult! {
        //if !classificationTempVerticalOneSaveResult! || !classificationTempVerticalTwoSaveResult! {
        if !classificationTempPipelineSaveResult! {
            let userAlert = UIAlertController(title: "Error", message: "Failed to save classification data", preferredStyle: .alert)
            self.present(userAlert, animated: true, completion: { _ in })
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            userAlert.addAction(cancel)
        }
        
//        let pipelineOneURL = documentsOneUrl.appendingPathComponent("trainOne.grt")
//        let classificiationOneDataURL = documentsOneUrl.appendingPathComponent("trainingOneData.csv")
//        let pipelineTwoURL = documentsTwoUrl.appendingPathComponent("trainTwo.grt")
//        let classificiationTwoDataURL = documentsTwoUrl.appendingPathComponent("trainingTwoData.csv")
//        let pipelineThreeURL = documentsThreeUrl.appendingPathComponent("trainThree.grt")
//        let classificiationThreeDataURL = documentsThreeUrl.appendingPathComponent("trainingThreeData.csv")
//        let pipelineFourURL = documentsFourUrl.appendingPathComponent("trainFour.grt")
//        let classificiationFourDataURL = documentsFourUrl.appendingPathComponent("trainingFourData.csv")
//        let pipelineFiveURL = documentsFiveUrl.appendingPathComponent("trainFive.grt")
//        let classificiationFiveDataURL = documentsFiveUrl.appendingPathComponent("trainingFiveData.csv")
        
        let pipelineURL = documentsPipelineUrl.appendingPathComponent("trainPipeline.grt")
        let classificiationPipelineDataURL = documentsPipelineUrl.appendingPathComponent("trainingPipelineData.csv")
        
//        let pipelineVerticalOneURL = documentsVerticalOneUrl.appendingPathComponent("trainVerticalOne.grt")
//        let classificiationVerticalOneDataURL = documentsVerticalOneUrl.appendingPathComponent("trainingVerticalOneData.csv")
//
//        let pipelineVerticalTwoURL = documentsVerticalTwoUrl.appendingPathComponent("trainVerticalTwo.grt")
//        let classificiationVerticalTwoDataURL = documentsVerticalTwoUrl.appendingPathComponent("trainingVerticalTwoData.csv")
        
//        if pipelineTempSaveOneResult ?? false, classificationTempSaveOneResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineOneURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationOneDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempOneURL, to: pipelineOneURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataOneTempURL, to: classificiationOneDataURL)
//        }
//
//        if pipelineTempSaveTwoResult ?? false, classificationTempSaveTwoResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineTwoURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationTwoDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempTwoURL, to: pipelineTwoURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataTwoTempURL, to: classificiationTwoDataURL)
//        }
//
//        if pipelineTempSaveThreeResult ?? false, classificationTempSaveThreeResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineThreeURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationThreeDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempThreeURL, to: pipelineThreeURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataThreeTempURL, to: classificiationThreeDataURL)
//        }
//
//        if pipelineTempSaveFourResult ?? false, classificationTempSaveFourResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineFourURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationFourDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempFourURL, to: pipelineFourURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataFourTempURL, to: classificiationFourDataURL)
//        }
        
//        if pipelineTempSaveFiveResult ?? false, classificationTempSaveFiveResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineFiveURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationFiveDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineTempFiveURL, to: pipelineFiveURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataFiveTempURL, to: classificiationFiveDataURL)
//        }
        
        if pipelineTempSaveResult ?? false, classificationTempVerticalOneSaveResult ?? false {
            // Remove the pipeline if it already exists if temp save is ok
            let _ = try? FileManager.default.removeItem(at: pipelineVerticalOneURL)
            let _ = try? FileManager.default.removeItem(at: classificiationVerticalOneDataURL)
            
            //Copy files from temporary folder
            let _ = try? FileManager.default.copyItem(at: pipelineVerticalTempOneURL, to: pipelineVerticalOneURL)
            let _ = try? FileManager.default.copyItem(at: classificiationDataVerticalOneTempURL, to: classificiationVerticalOneDataURL)
        }
        
//        if pipelineVerticalTempSaveOneResult ?? false, classificationTempVerticalOneSaveResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineVerticalOneURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationVerticalOneDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineVerticalTempOneURL, to: pipelineVerticalOneURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataVerticalOneTempURL, to: classificiationVerticalOneDataURL)
//        }
//
//        if pipelineVerticalTempSaveTwoResult ?? false, classificationTempVerticalTwoSaveResult ?? false {
//            // Remove the pipeline if it already exists if temp save is ok
//            let _ = try? FileManager.default.removeItem(at: pipelineVerticalTwoURL)
//            let _ = try? FileManager.default.removeItem(at: classificiationVerticalTwoDataURL)
//
//            //Copy files from temporary folder
//            let _ = try? FileManager.default.copyItem(at: pipelineVerticalTempTwoURL, to: pipelineVerticalTwoURL)
//            let _ = try? FileManager.default.copyItem(at: classificiationDataVerticalTwoTempURL, to: classificiationVerticalTwoDataURL)
//        }
        
    }
    
    @IBAction func showUserMode(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "UserModeMain", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "UserModeMainViewController") as? UserModeMainViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    
//    func initPipeline() {
//
//        //Load the GRT pipeline and the training data files from the documents directory
//        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        let pipelineURL = documentsUrl.appendingPathComponent("train.grt")
//        let classificiationDataURL = documentsUrl.appendingPathComponent("trainingData.csv")
//
//        let pipelineResult:Bool = pipeline!.load(pipelineURL)
//        let classificationDataResult:Bool = pipeline!.loadClassificationData(classificiationDataURL)
//
//        if pipelineResult == false {
//            let userAlert = UIAlertController(title: "Error", message: "Couldn't load pipeline", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
//            userAlert.addAction(cancel)
//            self.present(userAlert, animated: true, completion: { _ in })
//        }
//
//        if classificationDataResult == false {
//            let userAlert = UIAlertController(title: "Error", message: "Couldn't load classification data", preferredStyle: .alert)
//            self.present(userAlert, animated: true, completion: { _ in })
//            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
//            userAlert.addAction(cancel)
//        }
//    }
}

