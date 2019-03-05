//
//  PatternDetectedViewController.swift
//  GRT-iOS-HelloWorld
//
//  Created by Kirill Shteffen on 04/03/2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

import UIKit

class PatternDetectedViewController: UIViewController {

    var detectedPattern: String = ""
    var patternSpeed: Int = 0
    
    @IBOutlet weak var patternHeader: UILabel!
    @IBOutlet weak var patternLabel: UILabel!
    @IBOutlet weak var patternImage: UIImageView!
    @IBOutlet weak var patternSpeedSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        patternLabel.text = detectedPattern
        patternImage.image = UIImage(named: detectedPattern)
        patternSpeedSlider.value = Float(patternSpeed)
        if patternLabel.text == "Error" {
            patternHeader.text = "Pattern not detected"
        }
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
