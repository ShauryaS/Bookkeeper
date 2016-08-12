//
//  Params.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/16/16.
//  Copyright © 2016 CFO-online, Inc. All rights reserved.
//

//Global data for the entire app

import Foundation

//variable containing the url to the website where data is posted, uploaded, and recieved
let url = "https://cfo-online.com"

//array to store the type array from the json
var dataAll = [String: AnyObject]()

//array to store all the type options
var dataTypes = [String]()

//array to store all the purposes options
var dataPurposes = [String]()

//variable of the auth status
var auth = 3

//variable of the account number; unique to each user
var acctNum = ""

//variable containing the username entered in the username textfield
var username = ""

//variable containing the password entered in the password textfield
var password = ""

//variable of the remember me status; changes when remember me button is pressed
var rememberMe = false

//Struct of the user object; used when json data of login post is being parsed
struct User{
    var ok:Int?
    var accts:String?
    var types: [String: AnyObject]?
    init(){}
}

//params: none
//func used to get path to the apps document directory
//Return: path as a string
func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}