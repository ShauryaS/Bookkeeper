//
//  Params.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/16/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation

let url = "https://cfo-online.com"
var list:Array<User> = []
struct User{
    var ok:Bool
    var errno:Int
    var errmsg:String
    var msg:String
    var accts:String
}