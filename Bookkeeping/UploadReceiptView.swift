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
        nav?.tintColor = UIColor.black
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
        let fileManager = FileManager.default
        if imgPath != "" && fileManager.fileExists(atPath: imgPath) {
            img = UIImage(named: imgPath)
            imageView.image = img
        }
        accountIDLab.text = acctNum
        purposeButton.setTitle(purpose, for: UIControlState())
        typeButton.setTitle(type, for: UIControlState())
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden =  false
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
        }
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.black
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
    @IBAction func takePhoto(_ sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //params: none
    //sets the data array for purposes and sorts it lexographically
    //Return: none
    func setDataPurposes(){
        let temp = dataAll[type]?.allKeys
        dataPurposes = temp as! [String]
        dataPurposes = dataPurposes.sorted{
            return $0 < $1
        }
    }
    
    //param: UIImagePickerController - used to pick image. Info of the image as a String/AnyObject array - used to get image
    //sets the imageView image
    //sets the global img variable
    //saves image in a file
    //Return: none
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = img
        saveImg()
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //gets the text from the notes and attendees textfield and saves them to according global vars
    //changes view to the type selection view
    //Return: none
    @IBAction func selectType(_ sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegue(withIdentifier: "MainToTypeSegue", sender: sender)
    }
    
    //param: AnyObject that is recieved by button
    //param not used but necessary as button always sends an AnyObject
    //gets the text from the notes and attendees textfield and saves them to according global vars
    //changes view to the purpose selection view
    //Return: none
    @IBAction func selectPurpose(_ sender: AnyObject) {
        attendeesText = attendeesTF.text!
        notesText = notesTF.text!
        self.performSegue(withIdentifier: "MainToPurposeSegue", sender: sender)
    }
    
    //params: UIStoryboardSegue - to monitor the segue used - and AnyObject
    //func used to send data through the segue
    //sends purpose text, notes text, and img path if going to select type view
    //sends type text, notes text, and img path if going to select purpose view
    //Return: none
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "MainToTypeSegue"==segue.identifier{
            let yourNextViewController = (segue.destination as! SelectTypeView)
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
            let yourNextViewController = (segue.destination as! SelectPurposeView)
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
    @IBAction func submit(_ sender: AnyObject) {
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
    func parseJson(_ anyObj:AnyObject){
        if anyObj is NSDictionary {
            uploaded = (anyObj["OK"] as? Int!)!
        }
    }
    
    //params: array data as AnyObject
    //parses the data in the array to find the purpose with a val of 2
    //Return: String
    func parse(_ anyObj:AnyObject) -> String{
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
            let uuid = UUID().uuidString
            if let data = UIImageJPEGRepresentation(img, 0.9) {
                filepath = getDocumentsDirectory().appendingPathComponent(uuid+".jpg")
                try? data.write(to: URL(fileURLWithPath: filepath), options: [.atomic])
            }
            imgPath = filepath
        }
        else{
            if let data = UIImageJPEGRepresentation(img, 0.9) {
                try? data.write(to: URL(fileURLWithPath: imgPath), options: [.atomic])
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
        let fileurl = URL(fileURLWithPath: imgPath)
        let params = ["file": Upload(fileUrl: fileurl)]
        do {
            var decodedUrl = "&u=\(username)&p=\(password)"
            decodedUrl = decodedUrl+"&a=\(acctNum)&purpose=\(purpose)&type=\(type)"
            decodedUrl = decodedUrl+"&attendees=\(attendeesText)&notes=\(notesText)"
            var encodedUrl = decodedUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            encodedUrl = encodedUrl?.replacingOccurrences(of: "%20&%20", with: "%20%26%20")
            print(url+encodedUrl!)
            let opt = try HTTP.POST(url+encodedUrl!, parameters: params)
            opt.start { response in
                let jsonString = String(data: response.data, encoding: String.Encoding.utf8)
                let data: Data = (jsonString!.data(using: String.Encoding.utf8))!
                do{
                    let anyObj: Any? = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                    self.parseJson(anyObj! as AnyObject)
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
            let alert = UIAlertController(title: "Upload Success", message: "Successfuly Uploaded To Your Account", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Great", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let tempmsg = errmsg
            reset()
            let alert = UIAlertController(title: "Upload Failed", message: tempmsg, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
        purposeButton.setTitle(purpose, for: UIControlState())
        typeButton.setTitle(type, for: UIControlState())
        notesTF.text = notesText
        attendeesTF.text = attendeesText
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imgPath) {
            do {
                try fileManager.removeItem(atPath: imgPath)
            }
            catch let error as NSError {
                print("Error: "+"\(error)")
            }
        }
    }
    
}
