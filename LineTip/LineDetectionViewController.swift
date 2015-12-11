//
//  LineDetectionViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

// TO DELETE: currently not used
class LineDetectionViewController: UIViewController {
    
    //@IBOutlet weak var spot: UIImageView!
    //@IBOutlet var uiView: LineDetectionUIView!
    
    @IBOutlet var uiView: LineDetectionUIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("viewDidLoad")

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onHit:"))
        uiView.myImageView.userInteractionEnabled = true
        uiView.myImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let uiViewGestureRecognizer = UITapGestureRecognizer(target:uiView, action:Selector("onFail:"))
        uiView.userInteractionEnabled = true
        uiView.addGestureRecognizer(uiViewGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
       print("viewWillAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onHit(img: AnyObject){
        print("CONTROLLER Hit line")
        uiView.trial.countHit()
        uiView.draw()
        uiView.setNeedsDisplay()
 
    }
    
    func onFail(img: AnyObject){
        print("CONTROLLER Failed to hit line")
        uiView.trial.countMiss()
    }
    
    
    
    
}