//
//  UsersListModel.swift
//  HPS_Admin
//
//  Created by Vamsi on 12/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsersListModel {

    var success : Bool = false
    var users = [UsersData]()
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let dataJson = json.dictionary{
            if !dataJson.isEmpty{
                success = true
                for data in dataJson{
                    users.append(UsersData(fromJson: (data.key, data.value)))
                }
            }
        }
    }
}

class UsersData{
    
    var userNumber:String!
    var createdOn : String!
    var createdOnNum : String!
    var deviceId : String!
    var emailId : String!
    var message : String!
    var messageId : String!
    var mobileNumber : String!
    var name : String!
    var password : String!
    var photoIdUrl : String!
    var profilePicUrl : String!
    var referralCode : String!
    var status : String!
    var totalGamesPlayed : Int!
    var totalHoursPlayed : Int!
    var userBalance : Int!
    var userId : String!
    var userRewardPoints : Int!
    
    init(fromJson json: (String,JSON)){
        userNumber = json.0
        createdOn = json.1["createdOn"].stringValue
        createdOnNum = json.1["createdOnNum"].stringValue
        deviceId = json.1["deviceId"].stringValue
        emailId = json.1["emailId"].stringValue
        message = json.1["message"].stringValue
        messageId = json.1["messageId"].stringValue
        mobileNumber = json.1["mobileNumber"].stringValue
        name = json.1["name"].stringValue
        password = json.1["password"].stringValue
        photoIdUrl = json.1["photoIdUrl"].stringValue
        profilePicUrl = json.1["profilePicUrl"].stringValue
        referralCode = json.1["referralCode"].stringValue
        status = json.1["status"].stringValue
        totalGamesPlayed = json.1["totalGamesPlayed"].intValue
        totalHoursPlayed = json.1["totalHoursPlayed"].intValue
        userBalance = json.1["userBalance"].intValue
        userId = json.1["userId"].stringValue
        userRewardPoints = json.1["userRewardPoints"].intValue
    }
    
}
