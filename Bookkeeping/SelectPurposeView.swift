//
//  SelectPurposeView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/14/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation
import UIKit

class SelectPurposeView: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title="Select Expense Purpose"
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
    
    @IBAction func choose(sender: AnyObject) {
        self.performSegueWithIdentifier("SelectToMainSegue", sender: sender)
    }
    
}