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
    var purpose = "Select Expense Purpose"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.title="Bookkeeping"
        if purpose == ""{
            purpose = "Select Expense Purpose"
        }
        purposeButton.setTitle(purpose, forState: .Normal)
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func submit(sender: AnyObject) {
        let attendees = attendeesTF.text!
        let notes = notesTF.text!
    }
    
}