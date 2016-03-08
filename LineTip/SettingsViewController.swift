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
    
    

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var spotWidthLabel: UILabel!
    @IBOutlet weak var spotHeightLabel: UILabel!
    @IBOutlet weak var randomLineLabel: UILabel!
    @IBOutlet weak var hitSoundLabel: UILabel!
    @IBOutlet weak var missSoundLabel: UILabel!
    
    let gradePickerValues = ["5. Klasse", "6. Klasse", "7. Klasse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfiguration()
        initTexts()
        
    }
    
    func initTexts() {
        settingsLabel.text = "Settings".translate()
        previewLabel.text = "Preview".translate()
        lineWidthLabel.text = "Line Width".translate()
        spotWidthLabel.text = "Spot Width".translate()
        spotHeightLabel.text = "Spot Height".translate()
        randomLineLabel.text = "Display lines random".translate()
        hitSoundLabel.text = "Hit Sound".translate()
        missSoundLabel.text = "Miss Sound".translate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func lineWidthStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.LINE_BROADNESS, value: lineWidhtStepper.value)
        //print("lineWidthStepperAction (LINE_BROADNESS): \(lineWidhtStepper.value)")
        refreshPreview()
    }
    
    @IBAction func spotHeightStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.SPOT_HEIGHT, value: spotHeightStepper.value)
        //print("spotHeightStepperAction : \(spotHeightStepper.value)")
        refreshPreview()
    }
    
    @IBAction func spotWidthStepperAction(sender: AnyObject) {
        Utils.setSettingsData(ConfigKey.SPOT_WIDTH, value: (spotWidthStepper.value/100))
        //print("spotWidthStepperAction : \(spotWidthStepper.value/100)")
        refreshPreview()
    }
    
    @IBAction func lineGenerationPickerAction(sender: AnyObject) {
        if lineGenerationPicker.on {
            Utils.setSettingsData(ConfigKey.LINE_RANDOM_GENERATION, value: true)
        } else {
            Utils.setSettingsData(ConfigKey.LINE_RANDOM_GENERATION, value: false)
        }
    }
    
    func refreshPreview() {
        previewUI.setNeedsDisplay()
    }
    
    func initConfiguration() {
        lineWidhtStepper.value = Double(Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as! NSNumber)
        spotWidthStepper.value = Double(Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as! NSNumber) * 100
        spotHeightStepper.value = Double(Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as! NSNumber)
        
        lineGenerationPicker.on = Utils.getSettingsData(ConfigKey.LINE_RANDOM_GENERATION) as! Bool
    }
    

}
