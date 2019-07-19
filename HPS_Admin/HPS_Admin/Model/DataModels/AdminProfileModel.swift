//
//	AdminProfileModel.swift
//	

import Foundation 
import SwiftyJSON

class AdminProfileModel{

	var adminInfo : AdminInfo!
	var adminType : String!
	var eventsInfo : AdminEventsInfo!
	var message : String!
	var status : String!
	var tableAdmins : [AdminTableAdmin]!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let adminInfoJson = json["adminInfo"]
		if !adminInfoJson.isEmpty{
			adminInfo = AdminInfo(fromJson: adminInfoJson)
		}
		adminType = json["adminType"].string ?? ""
		let eventsInfoJson = json["eventsInfo"]
		if !eventsInfoJson.isEmpty{
			eventsInfo = AdminEventsInfo(fromJson: eventsInfoJson)
		}
		message = json["message"].string ?? ""
		status = json["status"].string ?? ""
		tableAdmins = [AdminTableAdmin]()
		let tableAdminsArray = json["tableAdmins"].arrayValue
		for tableAdminsJson in tableAdminsArray{
			let value = AdminTableAdmin(fromJson: tableAdminsJson)
			tableAdmins.append(value)
		}
	}
}
class AdminInfo{
    
    var deviceId : String!
    var id : String!
    var name : String!
    var password : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceId = json["deviceId"].string ?? ""
        id = json["id"].string ?? ""
        name = json["name"].string ?? ""
        password = json["password"].string ?? ""
    }
}


class AdminEventsInfo{
    
    var bookingsClosed : Int!
    var bookingsOpen : Int!
    var closed : Int!
    var created : Int!
    var finished : Int!
    var running : Int!
    var total : Int!
    var totalBuyIns : Int!
    var totalCashout : Int!
    var totalUsersBalance : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingsClosed = json["bookingsClosed"].int ?? 0
        bookingsOpen = json["bookingsOpen"].int ?? 0
        closed = json["closed"].int ?? 0
        created = json["created"].int ?? 0
        finished = json["finished"].int ?? 0
        running = json["running"].int ?? 0
        total = json["total"].int ?? 0
        totalBuyIns = json["totalBuyIns"].int ?? 0
        totalCashout = json["totalCashout"].int ?? 0
        totalUsersBalance = json["totalUsersBalance"].int ?? 0
    }
}

class AdminTableAdmin{
    
    var createdOn : String!
    var createdOnNum : String!
    var deviceId : String!
    var emailId : String!
    var mobileNumber : String!
    var name : String!
    var password : String!
    var tAdminId : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdOn = json["createdOn"].string ?? ""
        createdOnNum = json["createdOnNum"].string ?? ""
        deviceId = json["deviceId"].string ?? ""
        emailId = json["emailId"].string ?? ""
        mobileNumber = json["mobileNumber"].string ?? ""
        name = json["name"].string ?? ""
        password = json["password"].string ?? ""
        tAdminId = json["tAdminId"].string ?? ""
    }
}
