//
//  UploadReceiptView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/13/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP

class UploadReceiptView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var accountIDLab: UILabel!
    @IBOutlet var attendeesTF: UITextField!
    @IBOutlet var notesTF: UITextField!
    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet var purposeButton: UIButton!
    @IBOutlet var typeButton: UIButton!
    var purpose = dataAsset[0]
    var type = "Asset"
    var notesText = ""
    var attendeesText = ""
    var typeChanged = false
    var img: UIImage!
    var uploaded = 2
    @IBOutlet var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.title="Bookkeeping"
        if type == ""{
            type = "Asset"
        }
        if typeChanged{
            choosePurposeLabel()
            typeChanged = !typeChanged
        }
        if purpose == ""{
            choosePurposeLabel()
        }
        if notesText != ""{
            notesTF.text = notesText
        }
        if attendeesText != ""{
            attendeesTF.text = attendeesText
        }
        accountIDLab.text = acctNum
        purposeButton.setTitle(purpose, forState: .Normal)
        typeButton.setTitle(type, forState: .Normal)
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
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = img
    }
    
    @IBAction func selectType(sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegueWithIdentifier("MainToTypeSegue", sender: sender)
    }
    
    @IBAction func selectPurpose(sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegueWithIdentifier("MainToPurposeSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "MainToTypeSegue"==segue.identifier{
            let yourNextViewController = (segue.destinationViewController as! SelectTypeView)
            yourNextViewController.purposeLabel = purpose
            if notesText != ""{
                yourNextViewController.notes = notesText
            }
            if attendeesText != ""{
                yourNextViewController.attendees = attendeesText
            }
        }
        if "MainToPurposeSegue"==segue.identifier{
            let yourNextViewController = (segue.destinationViewController as! SelectPurposeView)
            yourNextViewController.typeLabel = type
            if notesText != ""{
                yourNextViewController.notes = notesText
            }
            if attendeesText != ""{
                yourNextViewController.attendees = attendeesText
            }
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        submitButton.titleLabel?.text! = "Uploading..."
        let uid = uploadAndGetResp()
        handleResp(uid)
    }
    
    func choosePurposeLabel(){
        switch(type){
            case "Asset":
                purpose = dataAsset[0]
                break
            case "Cost":
                purpose = dataCost[0]
                break
            case "Expense":
                purpose = dataExpense[0]
                break
            case "Income":
                purpose = dataIncome[0]
                break
            case "Other":
                purpose = dataOther[0]
                break
            case "Statement":
                purpose = dataStatement[0]
                break
            default:
                break
        }
    }
    
    func parseJson(anyObj:AnyObject){
        if anyObj is NSDictionary {
            uploaded = (anyObj["OK"] as? Int!)!
        }
    }
    
    func uploadAndGetResp() -> String{
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        var filepath = ""
        let uuid = NSUUID().UUIDString
        if let data = UIImageJPEGRepresentation(img, 0.9) {
            filepath = getDocumentsDirectory().stringByAppendingPathComponent(uuid+".jpg")
            data.writeToFile(filepath, atomically: true)
        }
        let fileurl = NSURL(fileURLWithPath: filepath)
        let params = ["file": Upload(fileUrl: fileurl)]
        do {
            let opt = try HTTP.POST(url+"/upload?v=2&u="+username+"&p="+password+"&a="+acctNum+"&purpose="+purpose+"&type="+type+"&attendees="+attendeesText+"&notes="+notesText, parameters: params)
            opt.start { response in
                let jsonString = String(data: response.data, encoding: NSUTF8StringEncoding)
                let data: NSData = (jsonString!.dataUsingEncoding(NSUTF8StringEncoding))!
                do{
                    let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    self.parseJson(anyObj!)
                } catch {
                    self.uploaded = 3
                    print("Error: \(error)")
                }
            }
        } catch let error {
            uploaded = 4
            print("got an error creating the request: \(error)")
        }
        while uploaded == 2 {}
        return uuid
    }
    
    func handleResp(uuid: String){
        if uploaded == 1{
            reset(uuid)
            let alert = UIAlertController(title: "Upload Success", message: "Successfuly Uploaded To Your Account", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Great", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Upload Failed", message: "Please Try Again Later.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func reset(uid: String) -> Void{
        purpose = dataAsset[0]
        type = "Asset"
        notesText = ""
        attendeesText = ""
        typeChanged = false
        img = UIImage()
        imageView.image = img
        uploaded = 2
        purposeButton.setTitle(purpose, forState: .Normal)
        typeButton.setTitle(type, forState: .Normal)
        notesTF.text = notesText
        attendeesTF.text = attendeesText
        let filePath = getDocumentsDirectory().stringByAppendingString(uid+".jpg")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            do {
                try fileManager.removeItemAtPath(filePath)
            }
            catch let error as NSError {
                print("Error: "+"\(error)")
            }
        }
    }
    
}