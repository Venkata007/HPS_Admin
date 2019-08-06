//
//  EventsListModel.swift
//  HPS_Admin
//
//  Created by Hexadots on 12/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventsListModel{
    
    var success : Bool = false
    var events = [EventsData]()
    var createdEvents = [EventsData]()
    var runningEvents = [EventsData]()
    var finishedEvents = [EventsData]()
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let dataJson = json.dictionary{
            if !dataJson.isEmpty{
                success = true
                for data in dataJson{
                    events.append(EventsData(fromJson: (data.key, data.value)))
                }
                events = events.sorted { (data1, data2) -> Bool in
                    return data1.startsAtNum < data2.startsAtNum
                }
                createdEvents = events.filter({ (eventDetail) -> Bool in
                    return eventDetail.eventStatus == EVENT_CREATED
                }).sorted(by: { (data1, data2) -> Bool in
                    return data1.startsAtNum < data2.startsAtNum
                })
                runningEvents = events.filter({ (eventDetail) -> Bool in
                    return eventDetail.eventStatus == EVENT_RUNNING
                }).sorted(by: { (data1, data2) -> Bool in
                    return data1.startsAtNum < data2.startsAtNum
                })
                finishedEvents = events.filter({ (eventDetail) -> Bool in
                    return eventDetail.eventStatus == EVENT_FINISHED
                }).sorted(by: { (data1, data2) -> Bool in
                    return data1.startsAtNum < data2.startsAtNum
                })
            }
        }
    }
}

class EventsData{
    
    var eventName:String!
    
    var audit : EventsDataAudit!
    var bookingStatus : String!
    var bookingUserIds = [EventsDataBookingUserId]()
    var closedById : String!
    var closedByName : String!
    var closedAt : String!
    var closedAtNum : String!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    var createdOnNum : String!
    var endedById : String!
    var endedByName : String!
    var endedAt : String!
    var endedAtNum : String!
    var eventEndAt : String!
    var eventEndAtNum : String!
    var eventId : String!
    var eventRewardPoints : Int!
    var eventStartAt : String!
    var eventStartAtNum : String!
    var endsAt : String!
    var endsAtNum : String!
    var eventStatusNum : Int!
    var eventStatusStartedAtNum : String!
    var eventStatusStartsAtNum : String!
    var eventStatus : String!
    var name : String!
    var noOfBuyInsCreatedForTheEvent : Int!
    var seats : EventsDataSeat!
    var startedById : String!
    var startedByName : String!
    var startedAt : String!
    var startsAt : String!
    var startsAtNum : String!
    var startedAtNum : String!
    var totalEventDurationHrs : Int!
    
    init(fromJson json: (String,JSON)){
        
        eventName = json.0
        
        let auditJson = json.1["audit"]
        if !auditJson.isEmpty{
            audit = EventsDataAudit(fromJson: auditJson)
        }
        bookingStatus = json.1["bookingStatus"].string ?? ""
        let bookingUserIdsJson = json.1["bookingUserIds"]
        if !bookingUserIdsJson.isEmpty{
            for userID in bookingUserIdsJson.dictionaryValue{
                bookingUserIds.append(EventsDataBookingUserId(fromJson: userID))
            }
        }
        closedById = json.1["closedById"].string ?? ""
        closedByName = json.1["closedByName"].string ?? ""
        closedById = json.1["closedAt"].string ?? ""
        closedAtNum = json.1["closedAtNum"].string ?? ""
        createdById = json.1["createdById"].string ?? ""
        createdByName = json.1["createdByName"].string ?? ""
        createdOn = json.1["createdOn"].string ?? ""
        createdOnNum = json.1["createdOnNum"].string ?? ""
        endedById = json.1["endedById"].string ?? ""
        endedByName = json.1["endedByName"].string ?? ""
        endedByName = json.1["endedAt"].string ?? ""
        endedAtNum = json.1["endedAtNum"].string ?? ""
        eventEndAt = json.1["eventEndAt"].string ?? ""
        eventEndAtNum = json.1["eventEndAtNum"].string ?? ""
        endsAt = json.1["endsAt"].string ?? ""
        endsAtNum = json.1["endsAtNum"].string ?? ""
        eventId = json.1["eventId"].string ?? ""
        eventRewardPoints = json.1["eventRewardPoints"].int ?? 0
        eventStartAt = json.1["eventStartAt"].string ?? ""
        eventStartAtNum = json.1["eventStartAtNum"].string ?? ""
        eventStatus = json.1["eventStatus"].string ?? ""
        eventStatusNum = json.1["eventStatusNum"].int ?? 0
        eventStatusStartsAtNum = json.1["eventStatusStartsAtNum"].string ?? ""
        eventStatusStartedAtNum = json.1["eventStatusStartedAtNum"].string ?? ""
        name = json.1["name"].string ?? ""
        noOfBuyInsCreatedForTheEvent = json.1["noOfBuyInsCreatedForTheEvent"].int ?? 0
        let seatsJson = json.1["seats"]
        if !seatsJson.isEmpty{
            seats = EventsDataSeat(fromJson: seatsJson)
        }
        startedById = json.1["startedById"].string ?? ""
        startedByName = json.1["startedByName"].string ?? ""
        startedById = json.1["startedAt"].string ?? ""
        startedAtNum = json.1["startedAtNum"].string ?? ""
        startsAtNum = json.1["startsAtNum"].string ?? ""
        startsAt = json.1["startsAt"].string ?? ""
        startedAt = json.1["startedAt"].string ?? ""
        totalEventDurationHrs = json.1["totalEventDurationHrs"].int ?? 0
    }
}

class EventsDataAudit{
    
    var adjustments : Int = 0
    var otherCharges : Int = 0
    var rakeAndTips : Int = 0
    var totalBuyIns : Int = 0
    var totalUsersBalance : Int = 0
    var totalCashout : Int = 0
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adjustments = json["adjustments"].int ?? 0
        otherCharges = json["otherCharges"].int ?? 0
        rakeAndTips = json["rakeAndTips"].int ?? 0
        totalBuyIns = json["totalBuyIns"].int ?? 0
        totalUsersBalance = json["totalUsersBalance"].int ?? 0
        totalCashout = json["totalCashout"].int ?? 0
    }
}

class EventsDataBookingUserId{
    var userID : String!
    var success : Bool!
    init(fromJson json: (String,JSON)){
        userID = json.0
        success = json.1.boolValue
    }
}


class EventsDataSeat{
    
    var available : Int!
    var blocked   : Int!
    var booked    : Int!
    var total     : Int!
    var played    : Int!
    var playing   : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].int ?? 0
        blocked   = json["blocked"].int ?? 0
        booked    = json["booked"].int ?? 0
        total     = json["total"].int ?? 0
        played    = json["played"].int ?? 0
        playing   = json["playing"].int ?? 0
    }
}
