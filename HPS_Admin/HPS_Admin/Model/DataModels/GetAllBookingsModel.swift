//
//  GetAllBookingsModel.swift
//  HPS_Admin
//
//  Created by Vamsi on 17/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetAllBookingsModel {
    
    var success : Bool = false
    var bookings = [GetAllBookings]()

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let dataJson = json.dictionary{
            if !dataJson.isEmpty{
                success = true
                for data in dataJson{
                    bookings.append(GetAllBookings(fromJson: (data.key, data.value)))
                }
                bookings = bookings.sorted { (data1, data2) -> Bool in
                    return data1.bookingId < data2.bookingId
                }
            }
        }
    }
}

class GetAllBookings{
    
    var bookingID:String!
    var balance : Int!
    var bookingId : String!
    var buyIns = [GetAllBuyIns]()
    var cashoutInfo : CashoutInfo!
    var cashout : Int!
    var createdOn : String!
    var createdOnNum : String!
    var eventId : String!
    var eventName : String!
    var eventRewardPoints : Int!
    var noOfSeatsBookedInEvent : Int!
    var status : String!
    var totalBuyIns : Int!
    var userEventRewardPoints : Int!
    var userId : String!
    var userJoinedAt : String!
    var userJoinedAtNum : String!
    var userJoinsAt : String!
    var userJoinsAtNum : String!
    var userLeftAt : String!
    var userLeftAtNum : String!
    var userName : String!
    var userPlayedHrs : Int!
    
    init(fromJson json: (String,JSON)){
        bookingId = json.0
        balance = json.1["balance"].int ?? 0
        bookingId = json.1["bookingId"].string ?? ""
        if let dataJson = json.1["buyIns"].dictionary{
            if !dataJson.isEmpty{
                buyIns = []
                for data in dataJson{
                    buyIns.append(GetAllBuyIns(fromJson: (data.key, data.value)))
                }
                buyIns = buyIns.sorted { (data1, data2) -> Bool in
                    return data1.buyInId < data2.buyInId
                }
            }
        }
        cashout = json.1["cashout"].int ?? 0
        createdOn = json.1["createdOn"].string ?? ""
        createdOnNum = json.1["createdOnNum"].string ?? ""
        eventId = json.1["eventId"].string ?? ""
        eventName = json.1["eventName"].string ?? ""
        eventRewardPoints = json.1["eventRewardPoints"].int ?? 0
        noOfSeatsBookedInEvent = json.1["noOfSeatsBookedInEvent"].int ?? 0
        status = json.1["status"].string ?? ""
        totalBuyIns = json.1["totalBuyIns"].int ?? 0
        userEventRewardPoints = json.1["userEventRewardPoints"].int ?? 0
        userId = json.1["userId"].string ?? ""
        userJoinedAt = json.1["userJoinedAt"].string ?? ""
        userJoinedAtNum = json.1["userJoinedAtNum"].string ?? ""
        userJoinsAt = json.1["userJoinsAt"].string ?? ""
        userJoinsAtNum = json.1["userJoinsAtNum"].string ?? ""
        userLeftAt = json.1["userLeftAt"].string ?? ""
        userLeftAtNum = json.1["userLeftAtNum"].string ?? ""
        userName = json.1["userName"].string ?? ""
        userPlayedHrs = json.1["userPlayedHrs"].int ?? 0
    }
    
}

class GetAllBuyIns {
    
    var amount : Int!
    var buyInId : String!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!

    init(fromJson json: (String,JSON)){
        amount = json.1["amount"].int ?? 0
        buyInId = json.1["buyInId"].string ?? ""
        createdById = json.1["createdById"].string ?? ""
        createdByName = json.1["createdByName"].string ?? ""
        createdOn = json.1["createdOn"].string ?? ""
    }
}


class CashoutInfo{
    
    var amount : Int!
    var createdById : String!
    var createdByName : String!
    var createdOn : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount = json["amount"].int ?? 0
        createdById = json["createdById"].string ?? ""
        createdByName = json["createdByName"].string ?? ""
        createdOn = json["createdOn"].string ?? ""
    }
}
