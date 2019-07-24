//
//	LoginAdminLoginModel.swift
//

import Foundation 
import SwiftyJSON

class AdminLoginModel{

	var data : LoginData!
	var message : String!
	var status : String!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = LoginData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		status = json["status"].string ?? ""
	}

}

class LoginData{
    
    var deviceId : String!
    var id : String!
    var name : String!
    var eventsRewardPointsPerHour : Int!
    var emailId : String!
    var mobileNumber : String!
    var type : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceId = json["deviceId"].string ?? ""
        id = json["id"].string ?? ""
        name = json["name"].string ?? ""
        eventsRewardPointsPerHour = json["eventsRewardPointsPerHour"].int ?? 0
        emailId = json["emailId"].string ?? ""
        mobileNumber = json["mobileNumber"].string ?? ""
        type = json["type"].string ?? ""
    }
}
