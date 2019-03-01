//
//  UserModeMainViewController.swift
//  GRT-iOS-HelloWorld
//
//  Created by Kirill Shteffen on 01/03/2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showPatternDetection(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "DetectingProcess", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetectingProcessViewController") as? DetectingProcessViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    
}

