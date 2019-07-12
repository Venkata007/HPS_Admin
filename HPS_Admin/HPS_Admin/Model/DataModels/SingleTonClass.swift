//
//  SingleTonClass.swift
//  UrbanEats
//
//  Created by Hexadots on 02/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import EZSwiftExtensions

let ModelClassManager = SingleTonClass.sharedInstance
class SingleTonClass: NSObject {

    //Cahce
    let imageCache = SDImageCache.shared()
    var adminLoginModel : AdminLoginModel!
    var tAdminLoginModel : TAdminLoginModel!

    class var sharedInstance: SingleTonClass {
        struct Singleton {
            static let instance = SingleTonClass()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
}

extension SingleTonClass{
    func returnDateFormat(_ dateString:String, fromDateFormat:String, toDateFormat:String) -> String{
        let date = dateString
        let defaultDateFormat = DateFormatter()
        defaultDateFormat.dateFormat = fromDateFormat
        let newFormat = DateFormatter()
        newFormat.calendar = Calendar.init(identifier: Calendar.Identifier.iso8601)
        newFormat.dateFormat = toDateFormat
        if let convertedDate = defaultDateFormat.date(from: date){
            return newFormat.string(from: convertedDate)
        }
        return date
    }
}
