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

/// shows up statistics (all trials of selected user) via chart and table view
class StatisticsViewController: UIViewController, LineChartDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lineChart: LineChart!

    var selectedUserObjectID : NSManagedObjectID!
    var trialList: [Trial]!
    var views: [String: AnyObject]!
    
    // charts axis content
    var hitValues: [CGFloat] = []
    var failValue: [CGFloat] = []
    var timeStampLabels: [String] = []
    var userManager = MedUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        tableView.delegate = self
        tableView.dataSource = self
        
        trialList = userManager.getTrialListByObjectId(self.selectedUserObjectID)
        
        initTexts()
        
        initChart()
        
        addLongPressRecognizer()
    }
    
    func initTexts() {
        titleText.text = "\("measurement results".translate())"
        label.text = "\("trials".translate())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Line chart delegate method to highlight cell if chart has been touched
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        
        // cell highlight on chart click
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: Int(x), inSection: 0)
        self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
    ///  Redraw chart on device rotation
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trialList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "groupcell")
        
        // set style and color
        cell.tintColor = UIColor.myKeyColor()
        cell.accessoryType = .Checkmark

        // set colored cell to get better understanding of the chart
        let duration = ("duration".translate() + ": "+trialList[indexPath.row].duration.getStringAsHoursMinutesSeconds())
        let hits = "hits".translate() + ": \(trialList[indexPath.row].hits)"
        let fails = "misses".translate() + ": \(trialList[indexPath.row].fails)"
        let tendency = "\(trialList[indexPath.row].getTendency())"
        let myString:NSString = "\(trialList[indexPath.row].timeStamp) | \(duration) | \(hits) | \(fails) | "
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        let blueLineColor = UIColor(red: 0.160784, green: 0.384314, blue: 0.658824, alpha: 1.0)
        let sTimestamp = trialList[indexPath.row].timeStamp.characters.count
        let sDuration = duration.characters.count
        let sHits = hits.characters.count
        let sMiss = fails.characters.count
        //let sTendency = tendency.characters.count
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:sTimestamp + sDuration + 3))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: blueLineColor, range: NSRange(location:sTimestamp + sDuration + 6,length:sHits))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.myKeyColor(), range: NSRange(location:sTimestamp + sDuration + sHits + 9,length:sMiss))
        //myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:sTimestamp + sDuration + sHits + sMiss + 12,length:sTendency))

        // add image
        myMutableString.appendAttributedString(getAttributedStringWithImageByTendecy(tendency))

        cell.textLabel!.attributedText = myMutableString
        return cell
    }
    
    /// get attributted string with image and correct orientation by tendecy
    func getAttributedStringWithImageByTendecy(tendecy: String) -> NSAttributedString {
        let textAttachment = NSTextAttachment()
        var orientation = UIImageOrientation.Left
        
        if(tendecy == "downRight"){
            orientation = .Up
        }
        else if(tendecy == "downLeft"){
            orientation = .Right
        }
        else if(tendecy == "topRight"){
            orientation = .Left
        }
        else if(tendecy == "topLeft"){
            orientation = .Down
        }
        else if(tendecy == "none"){
            return NSAttributedString(attachment: textAttachment)
        }
        
        
        textAttachment.image = UIImage(named: "arrow.png")!
        textAttachment.image = UIImage(CGImage: textAttachment.image!.CGImage!, scale: 2, orientation: orientation)
        return NSAttributedString(attachment: textAttachment)
    }
    
    /// shows chart if only mere then 3 trials availible
    func goodOldLineChart() {
        if(self.trialList.count > 2){
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
    }
    
    /// draws the chart
    func initChart() {
        if(self.trialList.count > 2){
            fillGraphByData()
            goodOldLineChart()
        }
        else {
            self.label.hidden = true
            tableView.hidden = true
            if(self.trialList.count > 0){
                self.label.hidden = false
                tableView.hidden = false
            }
            
            print("cant show statistics becuase not enougth data dude!")
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2, (titleText.frame.origin.y + 30) , 400, 60))
    
            noDataLabel.font.fontWithSize(20)
            noDataLabel.text = "Not enough trials yet".translate()
            noDataLabel.textColor = UIColor.myKeyColor()
            
            
            let centeredXPosition = (self.view.bounds.size.width / 2 ) - CGFloat((noDataLabel.text?.characters.count)! + 30)
            var myframe = noDataLabel.frame
            myframe.origin.x = centeredXPosition;
            noDataLabel.frame = myframe
            
            
            self.view.addSubview(noDataLabel)
            self.tableView.setNeedsDisplay()
        }
    }
    
    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func fillGraphByData() {
        for (index, _) in trialList.enumerate() {
            timeStampLabels.append("\(index+1).")
            hitValues.append(CGFloat(trialList[index].hits))
            failValue.append(CGFloat(trialList[index].fails))
        }
    }
    
    // Workaround for deleting a trial
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
                        
                        if self.hitValues.count > 0 {
                            self.hitValues.removeAtIndex(indexPath.row)
                            self.failValue.removeAtIndex(indexPath.row)
                            self.timeStampLabels.popLast()
                        }
                        if self.hitValues.count < 3 {
                            self.lineChart.hidden = true
                        }
     
                        self.tableView.reloadData()
    
                        self.lineChart.clearAll()
                        self.goodOldLineChart()
                        self.lineChart.setNeedsDisplay()
                        //self.view.setNeedsDisplay()
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