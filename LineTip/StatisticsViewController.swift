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
        
        trialList = getTrialListByObjectId(self.selectedUserObjectID)
        
        initTexts()
        initChart()
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
        //txtField.backgroundColor = UIColor.myKeyColorSecond()
        
        // set multiple color in a textfield
        let myString:NSString = "   \(Int(x)+1). \("trial".translate())= \(Int(yValues[0])).\("hits".translate()),  \(Int(yValues[1])).\("misses".translate())"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        
        let blueLineColor = UIColor(red: 0.160784, green: 0.384314, blue: 0.658824, alpha: 1.0)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:14))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: blueLineColor, range: NSRange(location:14,length:15))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.myKeyColor(), range: NSRange(location:27,length:myMutableString.length-27))
        
        // set label Attribute
        txtField.attributedText = myMutableString
      
        label.text = "x: \(x)     y: \(yValues)"
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
    
    
    func getTrialListByObjectId(objectId: NSManagedObjectID) -> [Trial]
    {
        let context = DataController().managedObjectContext
        var retList = [Trial] ()
        do {
            let medUser = try context.existingObjectWithID(objectId) as? MedUser
            var trialList = medUser?.trial!.allObjects as! [MedTrial]
            
            // sort by creation date:
            trialList = trialList.sort({ $0.creationDate.compare($1.creationDate) == .OrderedAscending })
            
            for (index, _) in trialList.enumerate() {
                let trial = Trial()
                trial.hits = Int(trialList[index].hits!)
                trial.fails = Int(trialList[index].fails!)
                trial.duration = trialList[index].duration!.doubleValue
                trial.timeStamp = trialList[index].timeStamp!
                trial.creationDate = trialList[index].creationDate
                retList.append(trial)
            }
            return retList
        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
    
    func initChart() {
        if(self.trialList.count > 2){
            views = [:]
            label.text = "..."
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = NSTextAlignment.Center
            
            views["label"] = label
            self.view.addSubview(label)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
            
            
            //add data
            for (index, _) in trialList.enumerate() {
                timeStampLabels.append("\(index+1).\("trial".translate())")
                hitValues.append(CGFloat(trialList[index].hits))
                failValue.append(CGFloat(trialList[index].fails))
            }
            
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
            self.view.addSubview(lineChart)
            views["chart"] = lineChart
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            
            // TABELLEN Titel
            let viewTitel = UIView()
            self.view.addSubview(viewTitel)
            
            views["title"] = viewTitel
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-[title(==50)]", options: [], metrics: nil, views: views))
            
            // Do any additional setup after loading the view.
            views["table"] = tableView
            let height = "\(Int(screenSize.height * 0.65))"
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[table]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[table(==\(height))]", options: [], metrics: nil, views: views))
            
            let hoch = tableView.frame.origin.y + 50
            txtField = UITextField(frame: CGRect(x: 0, y:  hoch , width: screenSize.width, height: 30.00))
            
            // set multiple color in a textfield
            let myString:NSString = "   \(trialList.count). \("trial".translate()) \("in following colors".translate()): \("hits".translate()) \("misses".translate())"
            //"\(Int(x)+1). \("trial".translate())= \(Int(yValues[0])).\("hits".translate()),  \(Int(yValues[1])).\("misses".translate())"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            
            let blueLineColor = UIColor(red: 0.160784, green: 0.384314, blue: 0.658824, alpha: 1.0)
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:25))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: blueLineColor, range: NSRange(location:35,length:7))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.myKeyColor(), range: NSRange(location:42,length:myMutableString.length-42))
            
            // set label Attribute
            txtField.attributedText = myMutableString
            self.view.addSubview(txtField)
        }
    }
    
}
