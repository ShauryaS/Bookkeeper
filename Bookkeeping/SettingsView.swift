//
//  SettingsView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/14/16.
//  Copyright © 2016 CFO-online, Inc. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIViewController{
    
    //variable of label used to display the username/email of the account logged in
    @IBOutlet var usernameLab: UILabel!
    
    //called when the view is loaded
    //Params: none
    //sets the tap anywhere to get rid of keyboard function
    //sets the title text of the navigation bar
    //sets the text of the username label
    //Return: none
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.title="Settings"
        usernameLab.text = "Username: "+username
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //function that is called when view is going to appear
    //Param: boolean variable to determine if view should be animated
    //sets the navigation bar to be visible
    //sets the tint of the notification bar to white (light content)
    //sets the color of the notification bar to black
    //Return: none
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden =  false
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor.blackColor()
        }
    }
    
    //default view method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //func to logout from account
    //resets all global credential data (username, password, acctNum, rememberMe)
    //resets auth val back to default
    //deletes savedData file
    //switches view back to login view
    @IBAction func logout(sender: AnyObject) {
        auth = 3
        acctNum = ""
        username = ""
        password = ""
        rememberMe = false
        let filePath = getDocumentsDirectory().stringByAppendingString("/savedData.txt")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            do {
                try fileManager.removeItemAtPath(filePath)
            }
            catch let error as NSError {
                print("Error: "+"\(error)")
            }
        }
        self.performSegueWithIdentifier("backToLogInSegue", sender: sender)
    }
    
}