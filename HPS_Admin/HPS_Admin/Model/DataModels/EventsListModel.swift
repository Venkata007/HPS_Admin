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
                    return data1.eventName < data2.eventName
                }
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
    var closedTime : String!
    var closedTimeNum : String!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    var createdOnNum : String!
    var endedById : String!
    var endedByName : String!
    var endedTime : String!
    var endedTimeNum : String!
    var eventEndTime : String!
    var eventEndTimeNum : String!
    var eventId : String!
    var eventRewardPoints : Int!
    var eventStartTime : String!
    var eventStartTimeNum : String!
    var eventStatus : String!
    var name : String!
    var seats : EventsDataSeat!
    var startedById : String!
    var startedByName : String!
    var startedTime : String!
    var startedTimeNum : String!
    var totalEventDurationHrs : Int!
    
    init(fromJson json: (String,JSON)){
        
        eventName = json.0
        
        let auditJson = json.1["audit"]
        if !auditJson.isEmpty{
            audit = EventsDataAudit(fromJson: auditJson)
        }
        bookingStatus = json.1["bookingStatus"].stringValue
        let bookingUserIdsJson = json.1["bookingUserIds"]
        if !bookingUserIdsJson.isEmpty{
            for userID in bookingUserIdsJson.dictionaryValue{
                bookingUserIds.append(EventsDataBookingUserId(fromJson: userID))
            }
        }
        closedById = json.1["closedById"].stringValue
        closedByName = json.1["closedByName"].stringValue
        closedTime = json.1["closedTime"].stringValue
        closedTimeNum = json.1["closedTimeNum"].stringValue
        createdById = json.1["createdById"].stringValue
        createdByName = json.1["createdByName"].stringValue
        createdOn = json.1["createdOn"].stringValue
        createdOnNum = json.1["createdOnNum"].stringValue
        endedById = json.1["endedById"].stringValue
        endedByName = json.1["endedByName"].stringValue
        endedTime = json.1["endedTime"].stringValue
        endedTimeNum = json.1["endedTimeNum"].stringValue
        eventEndTime = json.1["eventEndTime"].stringValue
        eventEndTimeNum = json.1["eventEndTimeNum"].stringValue
        eventId = json.1["eventId"].stringValue
        eventRewardPoints = json.1["eventRewardPoints"].intValue
        eventStartTime = json.1["eventStartTime"].stringValue
        eventStartTimeNum = json.1["eventStartTimeNum"].stringValue
        eventStatus = json.1["eventStatus"].stringValue
        name = json.1["name"].stringValue
        let seatsJson = json.1["seats"]
        if !seatsJson.isEmpty{
            seats = EventsDataSeat(fromJson: seatsJson)
        }
        startedById = json.1["startedById"].stringValue
        startedByName = json.1["startedByName"].stringValue
        startedTime = json.1["startedTime"].stringValue
        startedTimeNum = json.1["startedTimeNum"].stringValue
        totalEventDurationHrs = json.1["totalEventDurationHrs"].intValue
    }
}

class EventsDataAudit{
    
    var adjustments : Int!
    var otherCharges : Int!
    var reckAndTips : Int!
    var totalBuyIns : Int!
    var totalCashOut : Int!
    var rakeAndTips : Int!
    var totalCashout : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adjustments = json["adjustments"].intValue
        otherCharges = json["otherCharges"].intValue
        reckAndTips = json["reckAndTips"].intValue
        totalBuyIns = json["totalBuyIns"].intValue
        totalCashOut = json["totalCashOut"].intValue
        rakeAndTips = json["rakeAndTips"].intValue
        totalCashout = json["totalCashout"].intValue
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
    var blocked : Int!
    var booked : Int!
    var total : Int!
    var played : Int!
    var playing : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].intValue
        blocked = json["blocked"].intValue
        booked = json["booked"].intValue
        total = json["total"].intValue
        played = json["played"].intValue
        playing = json["playing"].intValue
    }
}
