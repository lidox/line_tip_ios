//
//  ViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 27.11.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            loadSettingsData()
        }
        catch{
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLineDetectionBtn(sender: AnyObject) {
        print("line-detection btn clicked");
        
        //Utils.printLinesToConsole()
    }
    
    func loadSettingsData(){
        
        var settingsList = [String]()
        settingsList.append(ConfigKey.LINE_WIDTH)
        settingsList.append(ConfigKey.LINE_COLOR_ALPHA)
        settingsList.append(ConfigKey.SPOT_HEIGHT)
        settingsList.append(ConfigKey.SPOT_WIDTH)
        settingsList.append(ConfigKey.SPOT_IMAGE_NAME)
        
        for (index, item) in settingsList.enumerate() {
            //print("Item \(index): \(item)")
            let test = Utils.getSettingsData(item)
            
            if(test  as! NSObject == 0){
                print("could not load settings data for key: \(item) . So use defaults")
                
                if(item == ConfigKey.LINE_WIDTH){
                    Utils.setSettingsData(ConfigKey.LINE_WIDTH, value: 5.0)
                }
                else if(item == ConfigKey.LINE_COLOR_ALPHA){
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_RED, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_GREEN, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_BLUE, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_ALPHA, value: 255)
                }
                else if(item == ConfigKey.SPOT_HEIGHT){
                    Utils.setSettingsData(ConfigKey.SPOT_HEIGHT, value: 75)
                }
                else if(item == ConfigKey.SPOT_IMAGE_NAME){
                    Utils.setSettingsData(ConfigKey.SPOT_IMAGE_NAME, value: "trans.png")
                }
                else if(item == ConfigKey.SPOT_WIDTH){
                    Utils.setSettingsData(ConfigKey.SPOT_WIDTH, value: 75)
                }
            }
            else{
                print("loaded settings data for key: \(item) at pos: \(index)")
            }
        }

    }
    
    

}

