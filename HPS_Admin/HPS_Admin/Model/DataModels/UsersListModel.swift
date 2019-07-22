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

     // (created/registered/pending/approved/disapproved)
    
    var success : Bool = false
    var users = [UsersData]()
    var registeredUsers = [UsersData]()
    var pendingUsers = [UsersData]()
    var blockedUsers = [UsersData]()
    var approvedUsers = [UsersData]()
    var newUsers = [UsersData]()
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
                users = users.sorted { (data1, data2) -> Bool in
                    return data1.name < data2.name
                }
                registeredUsers = users.filter({ (userData) -> Bool in
                    return userData.status == "registered"
                })
                pendingUsers = users.filter({ (userData) -> Bool in
                    return userData.status == "pending"
                })
                newUsers = users.filter({ (userData) -> Bool in
                    return userData.status == "created"
                })
                blockedUsers = users.filter({ (userData) -> Bool in
                    return userData.status == "blocked"
                })
                approvedUsers = users.filter({ (userData) -> Bool in
                    return userData.status == "approved"
                })
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
        createdOn = json.1["createdOn"].string ?? ""
        createdOnNum = json.1["createdOnNum"].string ?? ""
        deviceId = json.1["deviceId"].string ?? ""
        emailId = json.1["emailId"].string ?? ""
        message = json.1["message"].string ?? ""
        messageId = json.1["messageId"].string ?? ""
        mobileNumber = json.1["mobileNumber"].string ?? ""
        name = json.1["name"].string ?? ""
        password = json.1["password"].string ?? ""
        photoIdUrl = json.1["photoIdUrl"].string ?? ""
        profilePicUrl = json.1["profilePicUrl"].string ?? ""
        referralCode = json.1["referralCode"].string ?? ""
        status = json.1["status"].string ?? ""
        totalGamesPlayed = json.1["totalGamesPlayed"].int ?? 0
        totalHoursPlayed = json.1["totalHoursPlayed"].int ?? 0
        userBalance = json.1["userBalance"].int ?? 0
        userId = json.1["userId"].string ?? ""
        userRewardPoints = json.1["userRewardPoints"].int ?? 0
    }
    
}
