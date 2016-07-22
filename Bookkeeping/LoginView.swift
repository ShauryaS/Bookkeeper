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
import JSONJoy

class LogInView: UIViewController{
    
    @IBOutlet var emailUserTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var rememberMeButton: UIButton!
    private var selected = false
    
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
            struct Response: JSONJoy {
                let status: String?
                let error: String?
                init(_ decoder: JSONDecoder) {
                    status = decoder["OK"].string
                    error = decoder["errno"].string
                    //print(Response(JSONDecoder(response.data)))
                    //print("opt finished: \(response.description)")
                }
            }
            do {
                let opt = try HTTP.GET(url+"/upload?v=2&u="+username+"&p="+password)
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    do {
                        let user = try User(JSONDecoder(response.description))
                        print("city is: \(user.ok)")
                    } catch {
                        print("unable to parse the JSON")
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        }
        else{
            let alert = UIAlertController(title: "Login Failed", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*func getAccountID() -> String{
        do {
            let opt = try HTTP.GET("https://google.com")
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                //print("data is: \(response.data)") access the response of the data with response.data
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }*/
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "LogToMainSegue"==segue.identifier{
            let yourNextViewController = (segue.destinationViewController as! UploadReceiptView)
            //yourNextViewController.accountID = getAccountID()
        }
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
