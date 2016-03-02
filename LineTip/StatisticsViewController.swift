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
        print("medTrialList size= \(trialList.count)")
        
        initColors()
        initTexts()
        initChart()
    }
    
    func initColors() {
        /*
        startButton.backgroundColor = UIColor.myKeyColor()
        timeStampLabel.textColor = UIColor.myKeyColor()
        hitLabel.textColor = UIColor.myKeyColor()
        missLabel.textColor = UIColor.myKeyColor()
        durationLabel.textColor = UIColor.myKeyColor()
        startButton.setTitleColor(UIColor.myKeyColorSecond(), forState: UIControlState.Normal)
        
        //button settings
        startButton.layer.cornerRadius = 7.0
        */
    }
    
    func initTexts() {
        titleText.text = "\("measurement results".translate())"
        /*
        startButton.setTitle("\("NEW TRIAL".translate())", forState: UIControlState.Normal)
        //startButton.frame = CGRectMake(startButton.frame.origin.x, startButton.frame.origin.y, 700, 200)
        //let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        titleLabel.text = "\("result view".translate())"
        timeStampTextLabel.text = "\("timestamp".translate())"
        hitTextLabel.text = "\("hits".translate())"
        missTextLabel.text = "\("misses".translate())"
        durationTextLabel.text = "\("duration".translate())"
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
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
            var trialList = medUser?.trial.allObjects as! [MedTrial]
            
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
            self.view.addSubview(label)
            views["label"] = label
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
            
            //add data
            for (index, _) in trialList.enumerate() {
                timeStampLabels.append("\(index+1)")
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

            var txtField: UITextField //= UITextField(frame: CGRect(x: 0, y: 0 , width: screenSize.width, height: 30.00))
            
            //txtField.borderStyle = UITextBorderStyle.Line
            //txtField.text = "myString"
            //txtField.backgroundColor = UIColor.redColor()
            
            views["title"] = viewTitel
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-[title(==50)]", options: [], metrics: nil, views: views))
            
            
            
            // Do any additional setup after loading the view.
            views["table"] = tableView
            //let screenSize: CGRect = UIScreen.mainScreen().bounds
            let height = "\(Int(screenSize.height * 0.65))"
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[table]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[table(==\(height))]", options: [], metrics: nil, views: views))
            
            let hoch = tableView.frame.origin.y + 50
            txtField = UITextField(frame: CGRect(x: 0, y:  hoch , width: screenSize.width, height: 30.00))
            txtField.text = "   \(trialList.count). \("trials".translate())"
            txtField.textColor = UIColor.myKeyColor()
            self.view.addSubview(txtField)
        }
    }
    
}
