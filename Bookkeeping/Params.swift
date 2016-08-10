//
//  Params.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/16/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation

let url = "https://cfo-online.com"
let dataAsset = ["Building", "Computer Equipment", "Furniture & Fixtures", "Land", "Leasehold Improvement", "Office Equipment", "Other", "Plant & Machinery", "Vehicles"]
let dataCost = ["Labor Costs", "Other", "Product Costs", "Raw Materials"]
let dataExpense = ["Advertising", "Car & Truck", "Commissions & Fees", "Contract Labor", "Depletion", "Depreciation", "Employee Benefits", "Insurance", "Interest", "Meals & Entertainment", "Office Expense", "Other", "Pension & Profit Sharing", "Professional Services", "Rent & Lease", "Repairs & Maintenance", "Supplies", "Taxes & Liscenses", "Travel & Entertainment", "Utilities", "Wages"]
let dataIncome = ["Non-Operating Income", "Operating Income", "Other"]
let dataOther = ["Other"]
let dataStatement = ["Bank Statement", "Credit Card Statement", "Other"]

var auth = 3
var acctNum = ""
var username = ""
var password = ""
var rememberMe = false

struct User{
    var ok:Int?
    var accts:String?
    init(){}
}

func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}