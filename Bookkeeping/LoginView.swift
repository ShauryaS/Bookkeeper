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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let filePath = getDocumentsDirectory().stringByAppendingString("savedData.txt")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            var savedContents: String?
            do {
                savedContents = try NSString(contentsOfURL: NSURL(fileURLWithPath: filePath), encoding: NSUTF8StringEncoding) as String
            }
            catch {
                print("Error: "+"\(error)")
            }
            let contents = savedContents?.characters.split(" ").map(String.init)
            rememberMe = stringBool(contents![0])
            if rememberMe{
                username = contents![1]
                password = contents![2]
                acctNum = contents![3]
                auth = 1
            }
            permitAuth()
        }
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
        username = emailUserTF.text!
        password = passwordTF.text!
        if username != "" && password != ""{
            connectToBackEnd(username, password: password)
            saveAuth()
            permitAuth()
        }
        else{
            let alert = UIAlertController(title: "Login Failed", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func permitAuth(){
        if auth == 1{
            self.performSegueWithIdentifier("LogToMainSegue", sender: nil)
        }
        else{
            auth = 3
            let alert = UIAlertController(title: "Login Failed", message: "Email and Password Don't Match. Re-enter Credentials.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func connectToBackEnd(username:String, password:String){
        do {
            let opt = try HTTP.POST(url+"/upload?v=2&u="+username+"&p="+password)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                let jsonString = String(data: response.data, encoding: NSUTF8StringEncoding)
                let data: NSData = (jsonString!.dataUsingEncoding(NSUTF8StringEncoding))!
                do{
                    let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    self.parseJson(anyObj!)
                } catch {
                    print("Error: \(error)")
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        while auth == 3 {}
    }
    
    func parseJson(anyObj:AnyObject){
        var user = User()
        if anyObj is NSDictionary {
            user.ok = anyObj["OK"] as? Int
            user.accts = anyObj["accts"] as? String
            auth = user.ok!
            if user.accts != nil{
                acctNum = user.accts!
            }
        }
    }
    
    @IBAction func remember(sender: AnyObject) {
        if rememberMe == false{
            rememberMeButton.selected = true
            rememberMe = true
        }
        else{
            rememberMeButton.selected = false
            rememberMe = false
        }
    }
    
    func saveAuth(){
        if rememberMe {
            let filePath = getDocumentsDirectory().stringByAppendingString("savedData.txt")
            let fileurl = NSURL(fileURLWithPath: filePath)
            let savedString = rememberMe.description+" "+username+" "+password+" "+acctNum
            do{
                try savedString.writeToURL(fileurl, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
                print("Error: "+"\(error)")
            }
        }
    }
    
    func stringBool(str: String) -> Bool{
        switch(str){
            case "true":
                return true
            case "false":
                return false
            default:
                return false
        }
    }
    
}
