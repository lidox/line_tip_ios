//
//  SettingsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    

    @IBOutlet weak var previewUI: CanvasUIView!
    @IBOutlet weak var lineWidhtStepper: UIStepper!
    @IBOutlet weak var spotWidthStepper: UIStepper!
    @IBOutlet weak var spotHeightStepper: UIStepper!
    @IBOutlet weak var lineGenerationPicker: UISwitch!
    @IBOutlet weak var hotSoundPicker: UIPickerView!
    @IBOutlet weak var missSoundPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfiguration()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func lineWidthStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.LINE_BROADNESS, value: lineWidhtStepper.value)
        print("lineWidthStepperAction (LINE_BROADNESS): \(lineWidhtStepper.value)")
        refreshPreview()
    }
    
    @IBAction func spotHeightStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.SPOT_HEIGHT, value: spotHeightStepper.value)
        print("spotHeightStepperAction : \(spotHeightStepper.value)")
        refreshPreview()
    }
    
    @IBAction func spotWidthStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.SPOT_WIDTH, value: (spotWidthStepper.value/100))
        print("spotWidthStepperAction : \(spotWidthStepper.value/100)")
        refreshPreview()
    }
    
    @IBAction func lineGenerationPickerAction(sender: AnyObject) {
        
    }
    
    func refreshPreview() {
        previewUI.setNeedsDisplay()
    }
    
    func initConfiguration() {
        lineWidhtStepper.value = Double(Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as! NSNumber)
        spotWidthStepper.value = Double(Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as! NSNumber) * 100
        spotHeightStepper.value = Double(Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as! NSNumber)
    }


    

    
    

    
    
    
    



}
