//
//  StatisticsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class StatisticsViewController: UIViewController, LineChartDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    
    var txtField: UITextField!
    var label = UILabel()
    
    
    @IBOutlet weak var lineChart: LineChart!
    
    //var lineChart: LineChart!
    var trialList: [Trial]!
    var selectedUserObjectID : NSManagedObjectID!
    var views: [String: AnyObject]!
    
    var hitValues: [CGFloat] = []
    var failValue: [CGFloat] = []
    var timeStampLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        tableView.delegate = self
        tableView.dataSource = self
        
        trialList = MedUserManager.getTrialListByObjectId(self.selectedUserObjectID)
        
        initTexts()
        
        initChart()
        
        addLongPressRecognizer()
    }
    
    func initTexts() {
        titleText.text = "\("measurement results".translate())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        /*
        // set multiple color in a textfield
        let myString:NSString = "   \(Int(x)+1). \("trial".translate())= \(Int(yValues[0])).\("hits".translate()),  \(Int(yValues[1])).\("misses".translate())"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        
        let blueLineColor = UIColor(red: 0.160784, green: 0.384314, blue: 0.658824, alpha: 1.0)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:14))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: blueLineColor, range: NSRange(location:14,length:15))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.myKeyColor(), range: NSRange(location:27,length:myMutableString.length-27))
    
        label.attributedText = myMutableString
        */
    }
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trialList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "groupcell")
        
        // set style and color
        cell.tintColor = UIColor.myKeyColor()
        cell.accessoryType = .Checkmark
        cell.textLabel?.textColor = UIColor.myKeyColor()
        
        // set cell text
        cell.textLabel!.text = "(\(indexPath.row+1)): \(trialList[indexPath.row].timeStamp), \("duration".translate()) : \(trialList[indexPath.row].duration)"
        cell.detailTextLabel!.text = "\("hits".translate()): \(trialList[indexPath.row].hits), \("misses".translate()) : \(trialList[indexPath.row].fails)"
        
        return cell
    }

    
    func goodOldLineChart() {
        //lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = timeStampLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(hitValues)
        lineChart.addLine(failValue)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
    }
    
    func initChart() {
        if(self.trialList.count > 2){
            fillGraphByData()
            
            goodOldLineChart()
        }
        else {
            print("cant show statistics becuase not enougth data dude!")
        }
    }
    
    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func fillGraphByData() {
        for (index, _) in trialList.enumerate() {
            timeStampLabels.append("\(index+1).\("trial".translate())")
            hitValues.append(CGFloat(trialList[index].hits))
            failValue.append(CGFloat(trialList[index].fails))
        }
    }
    

    
    // Workaround for deleting
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(touchPoint) {
                print("long press on: \(indexPath.row)")
                
                
                let alert = UIAlertController(title: "",
                    message: "",
                    preferredStyle: .Alert)
                alert.view.tintColor = UIColor.myKeyColor()
                
                let attributedString = NSAttributedString(string: "\("Delete selected trial".translate())", attributes: [
                    NSForegroundColorAttributeName : UIColor.myKeyColor()
                    ])
                alert.setValue(attributedString, forKey: "attributedTitle")
                
                let saveAction = UIAlertAction(title: "\("Delete".translate())",
                    style: .Default,
                    handler: { (action:UIAlertAction) -> Void in
                        
                        // delete selected trial
                        MedUserManager.deleteTrialByObjectIdAndTrialIndex(self.selectedUserObjectID, index: indexPath.row)
                        self.trialList.removeAtIndex(indexPath.row)
                        self.hitValues.removeAtIndex(indexPath.row)
                        self.failValue.removeAtIndex(indexPath.row)
                        self.timeStampLabels.popLast()
     
                        self.tableView.reloadData()
                        self.goodOldLineChart()
                })
                
                let cancelAction = UIAlertAction(title: "\("Cancel".translate())",
                    style: .Default) { (action: UIAlertAction) -> Void in
                }
                
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                
                presentViewController(alert,
                    animated: true,
                    completion: nil)
            }}
    }
    
}