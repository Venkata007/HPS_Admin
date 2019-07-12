//
//	LoginTAdminLoginModel.swift
//	

import Foundation 
import SwiftyJSON

class TAdminLoginModel{

	var data : TLoginData!
	var message : String!
	var status : String!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = TLoginData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		status = json["status"].string ?? ""
	}
}

class TLoginData{
    
    var deviceId : String!
    var emailId : String!
    var id : Int!
    var mobileNumber : String!
    var name : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceId = json["deviceId"].string ?? ""
        emailId = json["emailId"].string ?? ""
        id = json["id"].int ?? 0
        mobileNumber = json["mobileNumber"].string ?? ""
        name = json["name"].string ?? ""
    }
    
}
