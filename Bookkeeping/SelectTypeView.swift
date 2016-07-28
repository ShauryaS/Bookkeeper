//
//  SelectTypeView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/28/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation
import UIKit

class SelectTypeView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet var pickerView: UIPickerView!
    private var valSelected = ""
    var purposeLabel = ""
    var notes = ""
    var attendees = ""
    
    var pickerDataSource = ["Select Expense Type", "Asset", "Cost", "Expense", "Income", "Other", "Statement"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title="Select Expense Type"
        pickerView.dataSource = self;
        pickerView.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden =  false
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.blackColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    @IBAction func choose(sender: AnyObject) {
        self.performSegueWithIdentifier("TypeToMainSegue", sender: sender)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value=pickerDataSource[row]
        valSelected = value
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "TypeToMainSegue"==segue.identifier{
            let yourNextViewController = (segue.destinationViewController as! UploadReceiptView)
            yourNextViewController.type = valSelected
            yourNextViewController.purpose = purposeLabel
            if notes != ""{
                yourNextViewController.notesText = notes
            }
            if attendees != ""{
                yourNextViewController.attendeesText = attendees
            }
        }
    }
    
}
