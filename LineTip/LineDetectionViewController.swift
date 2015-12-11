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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //print("LineDetectionViewController viewDidLoad")
        
        // hier die line setzen
        //uiView.line = Line(x1: 180, y1: 400, x2: 600, y2: 400)
        
        
        // set spotSize
        //spot.frame = CGRectMake(0, 0, 50, 50)
        
        //var frame:CGRect = spot.frame
        //frame.origin.y = CGFloat(uiView.line.getMidpointY())
        //frame.origin.x = CGFloat(uiView.line.getMidpointX())
        
        //spot.frame = CGRect(x: CGFloat(uiView.line.getMidpointX()), y: CGFloat(uiView.line.getMidpointY()), width: spot.frame.size.width, height: spot.frame.size.height)
        
        //spot.frame = CGRect(origin: spot.frame.origin, size: spot.frame.size)
        
    }
    
    override func viewWillAppear(animated: Bool) {
       print("viewWillAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}