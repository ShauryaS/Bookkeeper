//
//  LoginView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/12/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP

class LogInView: UIViewController{
    
    @IBOutlet var emailUserTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var rememberMeButton: UIButton!
    private var selected = false
    var jsonString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden =  true
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

    @IBAction func signIn(sender: AnyObject) {
        let username = emailUserTF.text!
        let password = passwordTF.text!
        if username != "" && password != ""{
            do {
                let opt = try HTTP.POST(url+"/upload?v=2&u="+username+"&p="+password)
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    self.jsonString = String(data: response.data, encoding: NSUTF8StringEncoding)!
                    /*let data: NSData = self.jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                    do{
                        let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                        list = self.parseJson(anyObj!)
                    } catch {
                        print("Error: \(error)")
                    }*/
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            //if ok{
                //self.performSegueWithIdentifier("LogToMainSegue", sender: nil)
            //}
        }
        else{
            let alert = UIAlertController(title: "Login Failed", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*func parseJson(anyObj:AnyObject) -> Array<User>{
        var list:Array<User> = []
        if  anyObj is Array<AnyObject> {
            var u:User = User()
            for json in anyObj as! Array<AnyObject>{
                u.ok = (json["OK"] as AnyObject? as? Bool)!
                list.append(u)
            }
        }
        return list
    }*/
    
    @IBAction func remember(sender: AnyObject) {
        if selected == false{
            rememberMeButton.selected = true
            selected = true
        }
        else{
            rememberMeButton.selected = false
            selected = false
        }
    }
    
}
