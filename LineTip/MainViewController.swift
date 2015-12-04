//
//  MainViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var medIdLabel: UILabel!
    
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc0 = ResultsViewController(nibName: "ResultsViewController", bundle: nil)
        
        self.addChildViewController(vc0)
        self.scrollView.addSubview(vc0.view)
        vc0.didMoveToParentViewController(self)
        
        
        
        let vc1 = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        var frame1 = vc1.view.frame
        frame1.origin.x = self.view.frame.size.width
        vc1.view.frame = frame1;
        
        self.addChildViewController(vc1)
        self.scrollView.addSubview(vc1.view)
        vc1.didMoveToParentViewController(self)
        
        
        let vc2 = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        var frame2 = vc2.view.frame
        frame2.origin.x = self.view.frame.size.width
        vc2.view.frame = frame2;
        
        self.addChildViewController(vc2)
        self.scrollView.addSubview(vc2.view)
        vc2.didMoveToParentViewController(self)
        
        
        let vc3 = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        var frame3 = vc3.view.frame
        frame3.origin.x = self.view.frame.size.width
        vc3.view.frame = frame3;
        
        self.addChildViewController(vc3)
        self.scrollView.addSubview(vc3.view)
        vc3.didMoveToParentViewController(self)
        
        // video bei 10:27: https://www.youtube.com/watch?v=3jAlg5BnYUU
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("MainViewController userName= \(userName)")
        medIdLabel.text = "Med-ID: \(userName)"
    }

}
