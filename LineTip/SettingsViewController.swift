//
//  SettingsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, SwiftColorPickerDelegate, SwiftColorPickerDataSource {
    
    @IBOutlet weak var lineWidthSlider: UISlider!

    @IBAction func onLineWidthChanged(sender: AnyObject) {
        print("done")
    }
    
    @IBOutlet weak var canvasUV: CanvasUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showColorPickerProgrammatically(sender: UIButton)
    {
        let colorPickerVC = SwiftColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.dataSource = self
        colorPickerVC.modalPresentationStyle = .Popover
        let popVC = colorPickerVC.popoverPresentationController!;
        popVC.sourceRect = sender.frame
        popVC.sourceView = self.view
        popVC.permittedArrowDirections = .Any;
        popVC.delegate = self;
        
        self.presentViewController(colorPickerVC, animated: true, completion: {
            print("Ready");
        })
    }
    
    // MARK: popover presenation delegates
    
    // this enables pop over on iphones
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.None
    }
    
    
    // MARK: - Color Matrix (only for test case)
    var colorMatrix = [ [UIColor]() ]
    private func fillColorMatrix(numX: Int, _ numY: Int) {
        
        colorMatrix.removeAll()
        if numX > 0 && numY > 0 {
            
            for _ in 0..<numX {
                var colInX = [UIColor]()
                for _ in 0..<numY {
                    colInX += [UIColor.randomColor()]
                }
                colorMatrix += [colInX]
            }
        }
    }
    
    
    // MARK: - Swift Color Picker Data Source
    
    func colorForPalletIndex(x: Int, y: Int, numXStripes: Int, numYStripes: Int) -> UIColor {
        if colorMatrix.count > x  {
            let colorArray = colorMatrix[x]
            if colorArray.count > y {
                return colorArray[y]
            } else {
                fillColorMatrix(numXStripes,numYStripes)
                return colorForPalletIndex(x, y:y, numXStripes: numXStripes, numYStripes: numYStripes)
            }
        } else {
            fillColorMatrix(numXStripes,numYStripes)
            return colorForPalletIndex(x, y:y, numXStripes: numXStripes, numYStripes: numYStripes)
        }
    }
    
    
    // MARK: Color Picker Delegate
    
    func colorSelectionChanged(selectedColor color: UIColor) {
        self.canvasUV.setBackgroundColorUV(color)
        //self.view.backgroundColor = color
    }


}
