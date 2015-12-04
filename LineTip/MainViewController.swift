//
//  MainViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var medIdLabel: UILabel!
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("MainViewController userName= \(userName)")
        medIdLabel.text = "Med-ID: \(userName)"
    }

}
