//
//  UploadReceiptView.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/12/16.
//  Copyright © 2016 CFO-online, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP

class UploadReceiptView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //variable for the label that displays the account id
    @IBOutlet var accountIDLab: UILabel!
    
    //variable for the textfield where the names of attendees to be entered
    @IBOutlet var attendeesTF: UITextField!
    
    //variable for the textfield where notes to be entered
    @IBOutlet var notesTF: UITextField!
    
    //variable for the image view where the image taken will be displayed
    @IBOutlet var imageView: UIImageView!
    
    //variable that is used to pick the image that has been taken
    var imagePicker: UIImagePickerController!
    
    //variable for the button that navigates to view where the purpose can be selected
    @IBOutlet var purposeButton: UIButton!
    
    //variable for the button that navigates to view where the type can be selected
    @IBOutlet var typeButton: UIButton!
    
    //variable to set the default purpose button label
    var purpose = ""
    
    //variable to set the default type button label
    var type = ""
    
    //variable to set the default note textfield data
    var notesText = ""
    
    //variable to set the default attendees textfield data
    var attendeesText = ""
    
    //variable that moniters if the type has been changed
    var typeChanged = false
    
    //variable to store the image of the picture taken
    var img: UIImage!
    
    //variable that monitors the upload state 
    //diff numbers refer to whether upload succeeded or failed
    var uploaded = 2
    
    //variable that stores the path of the image file that has been saved on the device
    var imgPath = ""
    
    //variable that stores the error message
    var errmsg = ""
    
    //variable for the button that is pressed for the uploading to begin
    @IBOutlet var submitButton: UIButton!
    
    //called when the view is loaded
    //Params: none
    //sets the tint color of the navigation bar at the top
    //sets the title text in the navigation bar
    //sets the tap anywhere to get rid of keyboard function
    //sets the text of the labels, buttons, and text fields
    //sets the purpose options based on the type selected
    //sets the image of the image view if there is an image saved at the image path
    //Return: none
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.title="Bookkeeping"
        if type == ""{
            type = dataTypes[0]
        }
        setDataPurposes()
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
        let fileManager = NSFileManager.defaultManager()
        if imgPath != "" && fileManager.fileExistsAtPath(imgPath) {
            img = UIImage(imageLiteral: imgPath)
            imageView.image = img
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
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
    }
    
    //default view method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //opens view to take an image
    //Return: none
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //params: none
    //sets the data array for purposes and sorts it lexographically
    //Return: none
    func setDataPurposes(){
        let temp = dataAll[type]?.allKeys
        dataPurposes = temp as! [String]
        dataPurposes = dataPurposes.sort{
            return $0 < $1
        }
    }
    
    //param: UIImagePickerController - used to pick image. Info of the image as a String/AnyObject array - used to get image
    //sets the imageView image
    //sets the global img variable
    //saves image in a file
    //Return: none
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = img
        saveImg()
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //gets the text from the notes and attendees textfield and saves them to according global vars
    //changes view to the type selection view
    //Return: none
    @IBAction func selectType(sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegueWithIdentifier("MainToTypeSegue", sender: sender)
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //gets the text from the notes and attendees textfield and saves them to according global vars
    //changes view to the purpose selection view
    //Return: none
    @IBAction func selectPurpose(sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegueWithIdentifier("MainToPurposeSegue", sender: sender)
    }
    
    //params: UIStoryboardSegue - to monitor the segue used - and AnyObject
    //func used to send data through the segue
    //sends purpose text, notes text, and img path if going to select type view
    //sends type text, notes text, and img path if going to select purpose view
    //Return: none
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
            if imgPath != ""{
                yourNextViewController.imgPath = imgPath
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
            if imgPath != ""{
                yourNextViewController.imgPath = imgPath
            }
        }
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    @IBAction func submit(sender: AnyObject) {
        uploaded = 2
        uploadAndGetResp()
        handleResp()
    }
    
    //params: none
    //function to select the default label for the purpose button which val of purpose is 2
    //Return: none
    func choosePurposeLabel(){
        purpose = parse(dataAll[type]!)
    }
    
    //param: json data as AnyObject
    //parses the data recieved when the image is uploaded so that action dialog boxes can occur 
    //used to know whether upload was successful or failed
    //Return: none
    func parseJson(anyObj:AnyObject){
        if anyObj is NSDictionary {
            uploaded = (anyObj["OK"] as? Int!)!
        }
    }
    
    //params: array data as AnyObject
    //parses the data in the array to find the purpose with a val of 2
    //Return: String
    func parse(anyObj:AnyObject) -> String{
        var toRet = ""
        if anyObj is NSDictionary {
            for key in dataPurposes{
                let val = anyObj[key] as? String
                if val! == "2"{
                    toRet = key
                }
            }
        }
        return toRet
    }
    
    //params: none
    //saves image to a file with a random name
    //image saved as jpg
    //saves to an existing image file or new image file depending on whether imgPath is nil or not
    //Return: none
    func saveImg(){
        if imgPath == ""{
            var filepath = ""
            let uuid = NSUUID().UUIDString
            if let data = UIImageJPEGRepresentation(img, 0.9) {
                filepath = getDocumentsDirectory().stringByAppendingPathComponent(uuid+".jpg")
                data.writeToFile(filepath, atomically: true)
            }
            imgPath = filepath
        }
        else{
            if let data = UIImageJPEGRepresentation(img, 0.9) {
                data.writeToFile(imgPath, atomically: true)
            }
        }
    }
    
    
    //params: none
    //gets text from attendees and notes textfield
    //converts imgPath to NSUrl
    //attempts to upload the image to the website and catches all errors
    //different states of uploaded var are assigned depending on upload status
    //Return: none
    func uploadAndGetResp(){
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        let fileurl = NSURL(fileURLWithPath: imgPath)
        let params = ["file": Upload(fileUrl: fileurl)]
        do {
            var decodedUrl = "&u=\(username)&p=\(password)"
            decodedUrl = decodedUrl+"&a=\(acctNum)&purpose=\(purpose)&type=\(type)"
            decodedUrl = decodedUrl+"&attendees=\(attendeesText)&notes=\(notesText)"
            var encodedUrl = decodedUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            encodedUrl = encodedUrl?.stringByReplacingOccurrencesOfString("%20&%20", withString: "%20%26%20")
            print(url+encodedUrl!)
            let opt = try HTTP.POST(url+encodedUrl!, parameters: params)
            opt.start { response in
                let jsonString = String(data: response.data, encoding: NSUTF8StringEncoding)
                let data: NSData = (jsonString!.dataUsingEncoding(NSUTF8StringEncoding))!
                do{
                    let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    self.parseJson(anyObj!)
                } catch {
                    self.uploaded = 3
                    print("Error: \(error)")
                    self.errmsg = "\(error)"
                }
            }
        } catch let error {
            uploaded = 4
            print("got an error creating the request: \(error)")
            errmsg = "\(error)"
        }
        while uploaded == 2 {}
    }
    
    //params: none
    //based on uploaded val (upload status) different alert boxes are shown to inform user of the status
    //reset method is called in both cases to reset all the data in the view
    //Return: none
    func handleResp(){
        if uploaded == 1{
            reset()
            let alert = UIAlertController(title: "Upload Success", message: "Successfuly Uploaded To Your Account", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Great", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let tempmsg = errmsg
            reset()
            let alert = UIAlertController(title: "Upload Failed", message: tempmsg, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //params: none
    //func to reset all the data in the entire view
    //resets all variables, labels, textfields, button labels
    //removes image from image view
    //deletes image file
    //Return: none
    func reset(){
        errmsg = ""
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
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(imgPath) {
            do {
                try fileManager.removeItemAtPath(imgPath)
            }
            catch let error as NSError {
                print("Error: "+"\(error)")
            }
        }
    }
    
}