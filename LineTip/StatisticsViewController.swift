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
    var lineChart: LineChart!
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
    
    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
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
                        //self.initChart()
                        
                        //self.lineChart.clearAll()
                        self.lineChart = LineChart()
                        //
                        /*for (index, _) in self.trialList.enumerate() {
                        self.timeStampLabels.append("\(index+1).\("trial".translate())")
                        self.hitValues.append(CGFloat(self.trialList[index].hits))
                        self.failValue.append(CGFloat(self.trialList[index].fails))
                        }*/
                        
                        //self.lineChart = LineChart()
                        
                        self.lineChart.animation.enabled = true
                        self.lineChart.area = true
                        self.lineChart.x.labels.visible = true
                        self.lineChart.x.grid.count = 5
                        self.lineChart.y.grid.count = 5
                        self.lineChart.x.labels.values = self.timeStampLabels
                        self.lineChart.y.labels.visible = true
                        self.lineChart.addLine(self.hitValues)
                        self.lineChart.addLine(self.failValue)
                        
                        self.lineChart.translatesAutoresizingMaskIntoConstraints = false
                        self.lineChart.delegate = self
                        //
                        
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
    
    /*
    // -- BEGINNING: REMOVE FUNCTION --
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
    return "\("Delete".translate())"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if(editingStyle == UITableViewCellEditingStyle.Delete) {
    print("MUHAHA \(indexPath.row)")
    //MedUserManager.deleteMedUserByObjectId(medUserList.removeAtIndex(indexPath.row).objectID)
    //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    self.tableView.reloadData()
    }
    }
    // -- ENDING: REMOVE FUNCTION --
    */
    func initChart() {
        if(self.trialList.count > 2){
            views = [:]
            label.text = "..."
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = NSTextAlignment.Center
            
            let placeHolder = UILabel()
            views["placeHolder"] = placeHolder
            placeHolder.backgroundColor = UIColor.redColor()
            self.view.addSubview(placeHolder)
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[placeHolder]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[placeHolder]", options: [], metrics: nil, views: views))
            
            views["label"] = label
            placeHolder.backgroundColor = UIColor.yellowColor()
            self.view.addSubview(label)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
            //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[placeHolder]-[label(==150)]", options: [], metrics: nil, views: views))
            
            
            //add data
            for (index, _) in trialList.enumerate() {
                timeStampLabels.append("\(index+1).\("trial".translate())")
                hitValues.append(CGFloat(trialList[index].hits))
                failValue.append(CGFloat(trialList[index].fails))
            }
            
            //
            lineChart = LineChart()
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
            //
            
            // chart
            lineChart.backgroundColor = UIColor.blueColor()
            self.view.addSubview(lineChart)
            
            views["chart"] = lineChart
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            // chart
            
            // txt label
            let hoch = tableView.frame.origin.y + 110
            let txtlabel = UILabel(frame: CGRect(x: 0, y:  hoch , width: screenSize.width, height: 30.00))
            views["txtlabel"] = txtlabel
            //txtlabel.center = CGPointMake(160, 284)
            txtlabel.textAlignment = NSTextAlignment.Center
            txtlabel.text = "I'am a test label"
            txtlabel.backgroundColor = UIColor.cyanColor()
            self.view.addSubview(txtlabel)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[txtlabel]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-[txtlabel(==40)]", options: [], metrics: nil, views: views))
            // txt label
            
            // Do any additional setup after loading the view.
            views["table"] = tableView
            tableView.backgroundColor = UIColor.greenColor()
            let height = "\(Int(screenSize.height * 0.60))"
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[table]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[txtlabel]-[table(==\(height))]", options: [], metrics: nil, views: views))
        }
    }
    
}