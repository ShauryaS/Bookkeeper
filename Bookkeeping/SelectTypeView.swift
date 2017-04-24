//
//  SelectTypeView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/28/16.
//  Copyright © 2016 CFO-online, Inc. All rights reserved.
//

import Foundation
import UIKit

class SelectTypeView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //variable for the UIPickerView
    @IBOutlet var pickerView: UIPickerView!
    
    //variable to store the string text of the option selected
    fileprivate var valSelected = ""
    
    //variable for the purpose label text
    var purposeLabel = ""
    
    //variable for the notes label text
    var notes = ""
    
    //variable for the attendees label text
    var attendees = ""
    
    //variable for the imgPath label text
    var imgPath = ""
    
    //array for the data to be loaded into the UIPickerView
    var pickerDataSource = dataTypes
    
    //called when the view is loaded
    //Params: none
    //sets the data of the UIPickerView
    //Return: none
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title="Select Expense Type"
        pickerView.dataSource = self;
        pickerView.delegate = self;
    }
    
    //function that is called when view is going to appear
    //Param: boolean variable to determine if view should be animated
    //sets the navigation bar to be visible
    //sets the tint of the notification bar to white (light content)
    //sets the color of the notification bar to black
    //Return: none
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden =  false
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
        }
    }
    
    //default view method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //params: UIPickerView - used to override inherited method
    //func returns number of columns
    //Return: int
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //params: UIPickerView, Int
    //func returns the number of rows
    //Return: Int
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    //params: UIPickerView, Int
    //func returns the text of the option selected
    //uses row (Int) to determine the variable selected
    //Return: String
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //switches view to upload receipt view
    @IBAction func choose(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "TypeToMainSegue", sender: sender)
    }
    
    //params: UIPickerView, Int
    //saves the text of the option selected to a new constant variable
    //text also saved in valSelected var
    //Return: none
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value=pickerDataSource[row]
        valSelected = value
    }
    
    //params: UIStoryboardSegue - to monitor the segue used - and AnyObject
    //func used to send data through the segue
    //sends attendees text, notes text, and img path if going to select type view
    //takes the valSelected variable and sets it as the type label text
    //Return: none
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "TypeToMainSegue"==segue.identifier{
            let yourNextViewController = (segue.destination as! UploadReceiptView)
            yourNextViewController.type = valSelected
            yourNextViewController.purpose = purposeLabel
            yourNextViewController.typeChanged = true
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
