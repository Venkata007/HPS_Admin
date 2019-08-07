//
//  NotificationTriggerClass.swift
//  HPS_Admin
//
//  Created by Hexadots on 02/08/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationTriggerClass: NSObject {

    class var sharedInstance: NotificationTriggerClass {
        struct Singleton {
            static let instance = NotificationTriggerClass()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.eventBookingUpdatedKey(_:)) , name: NSNotification.Name("NotificationTrigger\(EVENT_BOOKING_UPDATED)"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.eventBookingAddedKey(_:)) , name: NSNotification.Name("NotificationTrigger\(EVENT_BOOKING_ADDED)"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.eventUpdatedKey(_:)) , name: NSNotification.Name("NotificationTrigger\(EVENT_UPDATED)"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.eventAddedKey(_:)) , name: NSNotification.Name("NotificationTrigger\(EVENT_ADDED)"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userAddedKey(_:)) , name: NSNotification.Name("NotificationTrigger\(USER_UPDATED)"), object: nil)
    }
    
    @objc func eventBookingUpdatedKey(_ userInfo:Notification){
        if let data = userInfo.userInfo as? [String:AnyObject]{
            let jsonData = JSON(data)
            if let id = jsonData["bookingId"].string{
                let info = jsonData["bookingInfo"]
                let collection = GetAllBookings(fromJson: (id, info))
                if let all = ModelClassManager.getAllBookingsModel{
                    var i = 0
                    for id in all.bookings{
                        if id.bookingId == collection.bookingId{
                            break
                        }
                        i += 1
                    }
                    ModelClassManager.getAllBookingsModel.bookings.remove(at: i)
                    ModelClassManager.getAllBookingsModel.bookings.insert(collection, at: i)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: EVENT_BOOKING_UPDATED), object: nil, userInfo: ["IndexPath":i])
                }
            }
        }
    }
    
    @objc func eventBookingAddedKey(_ userInfo:Notification){
        if let data = userInfo.userInfo as? [String:AnyObject]{
            let jsonData = JSON(data)
            if let id = jsonData["bookingId"].string{
                let info = jsonData["bookingInfo"]
                let collection = GetAllBookings(fromJson: (id, info))
                if ModelClassManager.getAllBookingsModel != nil{
                    let isBookingContains = ModelClassManager.getAllBookingsModel.bookings.contains { (bookingDetail) -> Bool in
                        return bookingDetail.bookingId == collection.bookingId
                    }
                    if !isBookingContains{
                        ModelClassManager.getAllBookingsModel.bookings.append(collection)
                    }
                }else{
                    if let _ = ModelClassManager.getAllBookingsModel{
                        ModelClassManager.getAllBookingsModel.bookings.append(collection)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: EVENT_BOOKING_ADDED), object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func eventUpdatedKey(_ userInfo:Notification){
        if let data = userInfo.userInfo as? [String:AnyObject]{
            let jsonData = JSON(data)
            if let eventId = jsonData["eventId"].string{
                let eventInfo = jsonData["eventInfo"]
                let eventCol = EventsData(fromJson: (eventId, eventInfo))
                if let allEvents = ModelClassManager.eventsListModel{
                    var i = 0
                    for id in allEvents.events{
                        if id.eventId == eventCol.eventId{
                            break
                        }
                        i += 1
                    }
                    ModelClassManager.eventsListModel.events.remove(at: i)
                    ModelClassManager.eventsListModel.events.insert(eventCol, at: i)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: EVENT_UPDATED), object: nil, userInfo: ["IndexPath":i])
                }
            }
        }
    }
    
    @objc func eventAddedKey(_ userInfo:Notification){
        if let data = userInfo.userInfo as? [String:AnyObject]{
            let jsonData = JSON(data)
            if let eventId = jsonData["eventId"].string{
                let eventInfo = jsonData["eventInfo"]
                let eventCol = EventsData(fromJson: (eventId, eventInfo))
                if ModelClassManager.eventsListModel != nil{
                    let isEventContains = ModelClassManager.eventsListModel.events.contains { (eventDetail) -> Bool in
                        return eventDetail.eventId == eventCol.eventId
                    }
                    if !isEventContains{
                        ModelClassManager.eventsListModel.events.append(eventCol)
                    }
                }else{
                    ModelClassManager.eventsListModel.events.append(eventCol)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: EVENT_ADDED), object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func userAddedKey(_ userInfo:Notification){
        if let data = userInfo.userInfo as? [String:AnyObject]{
            let jsonData = JSON(data)
            if let Id = jsonData["userId"].string{
                let Info = jsonData["userInfo"]
                let userCol = UsersData(fromJson: (Id, Info))
                if ModelClassManager.usersListModel != nil{
                    let isEventContains = ModelClassManager.usersListModel.users.contains { (userDetail) -> Bool in
                        return userDetail.userId == userCol.userId
                    }
                    if !isEventContains{
                        ModelClassManager.usersListModel.users.append(userCol)
                        ModelClassManager.usersListModel.sortData()
                    }else{
                        ModelClassManager.usersListModel.users.removeAll { (userData) -> Bool in
                            return userData.userId == userCol.userId
                        }
                        ModelClassManager.usersListModel.users.append(userCol)
                        ModelClassManager.usersListModel.sortData()
                    }
                }else{
                    ModelClassManager.usersListModel.users.append(userCol)
                    ModelClassManager.usersListModel.sortData()
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_UPDATED), object: nil, userInfo: nil)
            }
        }
    }
    
}
