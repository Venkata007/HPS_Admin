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
    var eventsListModel : EventsListModel!
    var usersListModel : UsersListModel!
    var adminProfileModel : AdminProfileModel!
    var getAllBookingsModel : GetAllBookingsModel!

    class var sharedInstance: SingleTonClass {
        struct Singleton {
            static let instance = SingleTonClass()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    // @@@@@@@@@@@@@  Global Apis Hitting  @@@@@@@@@@@@@@@@@@@@
    // ***** Hitting all the Apis Globally which are used for twice.
    
    //MARK:- Get All Events Api Hitting
    func getAllEventsApiHitting(_ viewCon : UIViewController, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        APIServices.getUrlSession(urlString: ApiURls.GET_ALL_EVENTS, params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(viewCon.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                ModelClassManager.eventsListModel  = EventsListModel(fromJson: JSON(dict))
                if ModelClassManager.eventsListModel.success{
                     completionHandler(true,dict as AnyObject)
                }
            }else{
                completionHandler(false,nil)
                TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
            }
        }
    }
    
    //MARK:- Change Event Status Api Hitting
    func changeEventStatuslApiHitting(_ eventID : String , bookingStatus : String , viewCon : UIViewController, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: eventID,
                      ApiParams.BookingStatus: bookingStatus] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.EVENT_STATUS_API, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(viewCon.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
                completionHandler(true,dict as AnyObject)
            }else{
                 completionHandler(false,nil)
                TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
            }
        }
    }
    
    //MARK:- Get All Bookings Api Hitting
    func getAllBookingsApiHitting(_ viewCon : UIViewController, eventID : String, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        let url = "\(ApiURls.GET_ALL_BOOKINGS)&orderBy=%22eventId%22&equalTo=%22\(eventID)%22"
        APIServices.getUrlSession(urlString: url , params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(viewCon.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                print(dict)
                ModelClassManager.getAllBookingsModel  = GetAllBookingsModel(fromJson: JSON(dict))
                if ModelClassManager.getAllBookingsModel.success{
                    completionHandler(true,dict as AnyObject)
                }
            }else{
                completionHandler(false,nil)
                TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
            }
        }
    }
    
    //MARK:- Get All Users Api Hitting
    func getAllUsersApiHitting(_ viewCon : UIViewController, completionHandler : @escaping (_ granted:Bool, _ response:AnyObject?) -> (Void)){
        TheGlobalPoolManager.showProgress(viewCon.view, title:ToastMessages.Please_Wait)
        APIServices.getUrlSession(urlString: ApiURls.GET_ALL_USERS, params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(viewCon.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                ModelClassManager.usersListModel  = UsersListModel(fromJson: JSON(dict))
                if ModelClassManager.usersListModel.success{
                    completionHandler(true,dict as AnyObject)
                }
            }else{
                completionHandler(false,nil)
                TheGlobalPoolManager.showToastView(ToastMessages.No_Data_Available)
            }
        }
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
