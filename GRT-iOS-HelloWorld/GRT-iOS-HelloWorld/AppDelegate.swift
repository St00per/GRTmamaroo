//
//  AppDelegate.swift
//  GRT-iOS-HelloWorld
//
//  Created by Nicholas Arner on 8/17/17.
//  Copyright © 2017 Nicholas Arner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pipeline: GestureRecognitionPipeline?
    
    var pipelineOne: GestureRecognitionPipeline?
    var pipelineTwo: GestureRecognitionPipeline?
    var pipelineThree: GestureRecognitionPipeline?
    var pipelineFour: GestureRecognitionPipeline?
    var pipelineFive: GestureRecognitionPipeline?
    
    var pipelineVerticalOne: GestureRecognitionPipeline?
    var pipelineVerticalTwo: GestureRecognitionPipeline?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        //Create an instance of a gesture recognition pipeline to be used as a global variable, accesible by both our training and prediction view controllers
//        self.pipelineOne = GestureRecognitionPipeline()
//        self.pipelineTwo = GestureRecognitionPipeline()
//        self.pipelineThree = GestureRecognitionPipeline()
//        self.pipelineFour = GestureRecognitionPipeline()
//        self.pipelineFive = GestureRecognitionPipeline()
        self.pipeline = GestureRecognitionPipeline()
        
        //self.pipelineVerticalOne = GestureRecognitionPipeline()
        //self.pipelineVerticalTwo = GestureRecognitionPipeline()
        
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
//        let pipelineOneURL = documentsUrl.appendingPathComponent("trainOne.grt")
//        let classificiationDataOneURL = documentsUrl.appendingPathComponent("trainingOneData.csv")
//
//        let pipelineTwoURL = documentsUrl.appendingPathComponent("trainTwo.grt")
//        let classificiationDataTwoURL = documentsUrl.appendingPathComponent("trainingTwoData.csv")
//
//        let pipelineThreeURL = documentsUrl.appendingPathComponent("trainThree.grt")
//        let classificiationDataThreeURL = documentsUrl.appendingPathComponent("trainingThreeData.csv")
//
//        let pipelineFourURL = documentsUrl.appendingPathComponent("trainFour.grt")
//        let classificiationDataFourURL = documentsUrl.appendingPathComponent("trainingFourData.csv")
//
//        let pipelineFiveURL = documentsUrl.appendingPathComponent("trainFive.grt")
//        let classificiationDataFiveURL = documentsUrl.appendingPathComponent("trainingFiveData.csv")
        
//        let pipelineVerticalOneURL = documentsUrl.appendingPathComponent("trainVerticalOne.grt")
//        let classificiationDataVerticalOneURL = documentsUrl.appendingPathComponent("trainingVerticalOneData.csv")
//
//        let pipelineVerticalTwoURL = documentsUrl.appendingPathComponent("trainVerticalTwo.grt")
//        let classificiationDataVerticalTwoURL = documentsUrl.appendingPathComponent("trainingVerticalTwoData.csv")
        
//        let pipelineOneResult:Bool = pipelineOne!.load(pipelineOneURL)
//        let classificationDataOneResult:Bool = pipelineOne!.loadClassificationData(classificiationDataOneURL)
//
//        let pipelineTwoResult:Bool = pipelineTwo!.load(pipelineTwoURL)
//        let classificationDataTwoResult:Bool = pipelineTwo!.loadClassificationData(classificiationDataTwoURL)
//
//        let pipelineThreeResult:Bool = pipelineThree!.load(pipelineThreeURL)
//        let classificationDataThreeResult:Bool = pipelineThree!.loadClassificationData(classificiationDataThreeURL)
//
//        let pipelineFourResult:Bool = pipelineFour!.load(pipelineFourURL)
//        let classificationDataFourResult:Bool = pipelineFour!.loadClassificationData(classificiationDataFourURL)
        
//        let pipelineFiveResult:Bool = pipelineFive!.load(pipelineFiveURL)
//        let classificationDataFiveResult:Bool = pipelineFive!.loadClassificationData(classificiationDataFiveURL)
        
//        let pipelineVerticalOneResult:Bool = pipelineVerticalOne!.load(pipelineVerticalOneURL)
//        let classificationDataVerticalOneResult:Bool = pipelineVerticalOne!.loadClassificationData(classificiationDataVerticalOneURL)
//
//        let pipelineVerticalTwoResult:Bool = pipelineVerticalTwo!.load(pipelineVerticalTwoURL)
//        let classificationDataVerticalTwoResult:Bool = pipelineVerticalTwo!.loadClassificationData(classificiationDataVerticalTwoURL)

//        if (classificationDataOneResult && pipelineOneResult) {
//            pipelineOne?.train()
//        }
//        if (classificationDataTwoResult && pipelineTwoResult) {
//            pipelineTwo?.train()
//        }
//        if (classificationDataThreeResult && pipelineThreeResult) {
//            pipelineThree?.train()
//        }
//        if (classificationDataFourResult && pipelineFourResult) {
//            pipelineFour?.train()
//        }
//        if (classificationDataFiveResult && pipelineFiveResult) {
//            pipelineFive?.train()
//        }
        
//        if (classificationDataVerticalOneResult && pipelineVerticalOneResult) {
//            pipelineVerticalOne?.train()
//        }
//        
//        if (classificationDataVerticalTwoResult && pipelineVerticalTwoResult) {
//            pipelineVerticalTwo?.train()
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

