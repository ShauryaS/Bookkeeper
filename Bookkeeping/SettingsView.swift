//
//  SettingsView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/14/16.
//  Copyright © 2016 CFO-online. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIViewController{
    
    @IBOutlet var usernameLab: UILabel!
    
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