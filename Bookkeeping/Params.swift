//
//  Params.swift
//  Bookkeeping
//
//  Created by Shaurya Srivastava on 7/16/16.
//  Copyright © 2016 Shaurya Srivastava. All rights reserved.
//

import Foundation
import JSONJoy

let url = "https://cfo-online.com"

struct User: JSONJoy{
    let ok:Bool
    let errno:Int
    let errmsg:String
    let msg:String
    let accts:Int
    
    init(_ decoder: JSONDecoder) throws {
        ok = decoder["OK"].bool
        errno = try decoder["errno"].getInt()
        errmsg = try decoder["errmsg"].getString()
        msg = try decoder["msg"].getString()
        accts = try decoder["accts"].getInt()
    }
    
}