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
    var fastPipeline: GestureRecognitionPipeline?
    var verticalPipeline: GestureRecognitionPipeline?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        //Create an instance of a gesture recognition pipeline to be used as a global variable, accesible by both our training and prediction view controllers

        self.pipeline = GestureRecognitionPipeline()
        self.fastPipeline = GestureRecognitionPipeline()
        self.verticalPipeline = GestureRecognitionPipeline()
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let pipelineURL = documentsUrl.appendingPathComponent("trainPipeline.grt")
        let classificiationDataPipelineURL = documentsUrl.appendingPathComponent("trainingPipelineData.csv")

        let pipelineResult: Bool = pipeline!.load(pipelineURL)
        let classificationDataPipelineResult: Bool = pipeline!.loadClassificationData(classificiationDataPipelineURL)

        if (classificationDataPipelineResult && pipelineResult) {
            pipeline?.train()
        }
        
        let fastPipelineURL = documentsUrl.appendingPathComponent("trainFastPipeline.grt")
        let classificiationDataFastPipelineURL = documentsUrl.appendingPathComponent("trainingFastPipelineData.csv")
        
        let fastPipelineResult: Bool = fastPipeline!.load(fastPipelineURL)
        let classificationDataFastPipelineResult: Bool = fastPipeline!.loadClassificationData(classificiationDataFastPipelineURL)
        
        if (classificationDataFastPipelineResult && fastPipelineResult) {
            fastPipeline?.train()
        }

        let verticalPipelineURL = documentsUrl.appendingPathComponent("trainVerticalPipeline.grt")
        let classificiationDataVerticalPipelineURL = documentsUrl.appendingPathComponent("trainingVerticalPipelineData.csv")
        
        let verticalPipelineResult: Bool = verticalPipeline!.load(verticalPipelineURL)
        let classificationDataVerticalPipelineResult: Bool = verticalPipeline!.loadClassificationData(classificiationDataVerticalPipelineURL)
        
        if (classificationDataVerticalPipelineResult && verticalPipelineResult) {
            verticalPipeline?.train()
        }
        
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

