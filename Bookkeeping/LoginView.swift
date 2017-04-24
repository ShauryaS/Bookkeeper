//
//  LoginView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/12/16.
//  Copyright © 2016 CFO-online, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP

class LogInView: UIViewController{
    
    //variable for the textfield where the email/username is entered
    @IBOutlet var emailUserTF: UITextField!
    
    //variable for the textfield where the password is entered
    @IBOutlet var passwordTF: UITextField!
    
    //variable for the button which indactes whether credentials should be saved
    @IBOutlet var rememberMeButton: UIButton!
    
    //variable for error msg
    var emsg = "error"
    
    //called when the view is loaded
    //Params: none
    //sets the tap anywhere to get rid of keyboard function
    //Return: none
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
    
    //params: boolean to determine if view should be animated
    //func determines if savedData file exists
    //reads file and gets info
    //breaks up data read into separate variables (rememberMe, username, password, acctNum)
    //depending on rememberMe boolean val, switches to the upload receipt view
    //Return: none
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let filePath = getDocumentsDirectory().appending("/savedData.txt")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            var savedContents = ""
            do {
                savedContents = try NSString(contentsOf: URL(fileURLWithPath: filePath), encoding: String.Encoding.utf8.rawValue) as String
                let contents = savedContents.characters.split(separator: " ").map(String.init)
                username = contents[0]
                password = contents[1]
            }
            catch {
                print("Error: "+"\(error)")
            }
            connectToBackEnd(username, password: password)
            permitAuth()
        }
    }
    
    //function that is called when view is going to appear
    //Param: boolean variable to determine if view should be animated
    //sets the navigation bar to be visible
    //sets the tint of the notification bar to white (light content)
    //sets the color of the notification bar to black
    //Return: none
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden =  true
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

    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //gets text from the username and password textfields and saves text to vars username and password
    //checks if either username or password is nil
    //if nil, alert box tells the user to enter credentials
    //else, attempts to connect to backend and get json data and permits auth accordingly
    //Return: none
    @IBAction func signIn(_ sender: AnyObject) {
        username = emailUserTF.text!
        password = passwordTF.text!
        if username != "" && password != ""{
            connectToBackEnd(username, password: password)
            permitAuth()
        }
        else{
            let alert = UIAlertController(title: "Login Failed", message: "Enter Credentials.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //params: none
    //depending on val of auth, if successful, calls saveAuth method and switches view
    //if auth unsuccessful, changes auth val back to default val and alerts user that credentials are incorrect
    //Return: none
    func permitAuth(){
        if auth == 1{
            saveAuth(username, password: password)
            self.performSegue(withIdentifier: "LogToMainSegue", sender: nil)
        }
        else{
            auth = 3
            let tempmsg = emsg
            emsg = ""
            let alert = UIAlertController(title: "Login Failed", message: tempmsg, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //params: username and password - needed for the HTTP posting
    //trys to post data to get json file
    //gets json data as string - converts to data - converts to anyobject
    //json gets parsed
    //all errors caught
    //Return: none
    func connectToBackEnd(_ username:String, password:String){
        do {
            let opt = try HTTP.POST(url+"/upload?v=2&u="+username+"&p="+password)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                let jsonString = String(data: response.data, encoding: String.Encoding.utf8)
                let data: Data = (jsonString!.data(using: String.Encoding.utf8))!
                do{
                    let anyObj: Any? = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                    print(anyObj!)
                    self.parseJson(anyObj! as AnyObject)
                } catch {
                    print("Error: \(error)")
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        while auth == 3 || emsg == "error" {}
    }
    
    //param: json data as AnyObject
    //parses the data recieved when the username and password are posted
    //gets auth status and acct number and all the types and purposes options
    //sets the data array for types and sorts it lexographically
    //Return: none
    func parseJson(_ anyObj:AnyObject){
        var user = User()
        if anyObj is NSDictionary {
            user.accts = anyObj["accts"] as? String
            user.types = anyObj["types"] as? [String: AnyObject]
            user.emsg = anyObj["errmsg"] as? String
            user.ok = anyObj["OK"] as? AnyObject
            print(user.ok?.description)
            auth = Int((user.ok?.description)!)!
            if user.accts != nil{
                acctNum = user.accts!
            }
            if user.types != nil{
                dataAll = user.types!
                for key in (user.types?.keys)!{
                    dataTypes.append(key)
                }
                dataTypes = dataTypes.sorted{
                    return $0 < $1
                }
            }
            if user.emsg != nil{
                emsg = user.emsg!
            }
        }
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //higlights/unhighlights remember me button depending on val of rememberMe
    //changes val of rememberMe accordingly
    //used to determine whether credentials should be saved
    //Return: none
    @IBAction func remember(_ sender: AnyObject) {
        if rememberMe == false{
            rememberMeButton.isSelected = true
            rememberMe = true
        }
        else{
            rememberMeButton.isSelected = false
            rememberMe = false
        }
    }
    
    //params: username and password - to be saved in file
    //credential data is saved as string in a file
    //Return: none
    func saveAuth(_ username: String, password: String){
        if rememberMe {
            let filePath = getDocumentsDirectory().appending("/savedData.txt")
            let fileurl = URL(fileURLWithPath: filePath)
            let savedString = username+" "+password
            do{
                try savedString.write(to: fileurl, atomically: false, encoding: String.Encoding.utf8)
            }
            catch{
                print("Error: "+"\(error)")
            }
        }
    }
    
    //params: str - boolean in string format
    //func returns bool val depending on whether string val is "true" or "false"
    //Return: Boolean value
    func stringBool(_ str: String) -> Bool{
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
