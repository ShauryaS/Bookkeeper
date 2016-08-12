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

//array containing String names of the purpose options if the type is asset
let dataAsset = ["Building", "Computer Equipment", "Furniture & Fixtures", "Land", "Leasehold Improvement", "Office Equipment", "Other", "Plant & Machinery", "Vehicles"]

//array containing Strings names of the purpose options if the type is cost
let dataCost = ["Labor Costs", "Other", "Product Costs", "Raw Materials"]

//array containing Strings names of the purpose options if the type is expense
let dataExpense = ["Advertising", "Car & Truck", "Commissions & Fees", "Contract Labor", "Depletion", "Depreciation", "Employee Benefits", "Insurance", "Interest", "Meals & Entertainment", "Office Expense", "Other", "Pension & Profit Sharing", "Professional Services", "Rent & Lease", "Repairs & Maintenance", "Supplies", "Taxes & Liscenses", "Travel & Entertainment", "Utilities", "Wages"]

//array containing Strings names of the purpose options if the type is income
let dataIncome = ["Non-Operating Income", "Operating Income", "Other"]

//array containing Strings names of the purpose options if the type is other
let dataOther = ["Other"]

//array containing Strings names of the purpose options if the type is statement
let dataStatement = ["Bank Statement", "Credit Card Statement", "Other"]

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