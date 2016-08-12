//
//  SelectPurposeView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/14/16.
//  Copyright © 2016 CFO-online. All rights reserved.
//

import Foundation
import UIKit

class SelectPurposeView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet var pickerView: UIPickerView!
    private var valSelected = ""
    var typeLabel = ""
    var notes = ""
    var attendees = ""
    var imgPath = ""
    
    var pickerDataSource = ["Select Expense Purpose"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title="Select Expense Purpose"
        if typeLabel == "Asset"{
            pickerDataSource = dataAsset
        }
        else if typeLabel == "Cost"{
            pickerDataSource = dataCost
        }
        else if typeLabel == "Expense"{
            pickerDataSource = dataExpense
        }
        else if typeLabel == "Income"{
            pickerDataSource = dataIncome
        }
        else if typeLabel == "Other"{
            pickerDataSource = dataOther
        }
        else if typeLabel == "Statement"{
            pickerDataSource = dataStatement
        }
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
        self.performSegueWithIdentifier("SelectToMainSegue", sender: sender)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value=pickerDataSource[row]
        valSelected = value
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "SelectToMainSegue"==segue.identifier{
            let yourNextViewController = (segue.destinationViewController as! UploadReceiptView)
            yourNextViewController.purpose = valSelected
            yourNextViewController.type = typeLabel
            if notes != ""{
                yourNextViewController.notesText = notes
            }
            if attendees != ""{
                yourNextViewController.attendeesText = attendees
            }
            if imgPath != ""{
                yourNextViewController.imgPath = imgPath
            }
        }
    }
    
}