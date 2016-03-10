//
//  QuickStartUIViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 10.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//


import UIKit

class QuickStartUIViewController: UIViewController {

    
    @IBOutlet weak var assignUserLabel: UILabel!
    @IBOutlet weak var assignUserSubtitleLabel: UILabel!
    @IBOutlet weak var noUserTitleLabel: UILabel!
    @IBOutlet weak var noUserSubTitleLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var startTrialButton: UIButton!
    
    override func viewDidLoad() {
        print("QuickStartUIViewController: viewDidLoad")
        super.viewDidLoad()
        initTitleAndColors()
    }
    
    func initTitleAndColors() {
        changeButtonColorAndStyle(createUserButton)
        createUserButton.setTitle(" " + "New user".translate() + " ", forState: UIControlState.Normal)
        
        changeButtonColorAndStyle(startTrialButton)
        startTrialButton.setTitle(" " + "NEW TRIAL".translate() + " ", forState: UIControlState.Normal)
        
        assignUserLabel.text = "Assign Trial".translate()
        assignUserLabel.textColor = UIColor.myKeyColor()
        assignUserSubtitleLabel.text = "Please assign trial(s) to a user.".translate()
        noUserTitleLabel.text = "There is no user to assign".translate()
        noUserTitleLabel.textColor = UIColor.myKeyColor()
        noUserSubTitleLabel.text = "Please create a new user to assign the trial(s).".translate()
        placeHolderLabel.text = ""
    }
    
    func changeButtonColorAndStyle(button: UIButton) {
        button.setTitleColor(UIColor.myKeyColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.myKeyColor().CGColor
    }
    
    @IBAction func onCreateUserButtonClick(sender: AnyObject) {
        
    }
    
    @IBAction func onStartTrialButtonClick(sender: AnyObject){
        
    }
}
