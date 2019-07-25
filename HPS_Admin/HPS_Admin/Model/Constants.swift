//
//  Constants.swift
//  QHost
//
//  Created by Admin on 29/06/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

let SERVER_IP        = "https://us-central1-home-poker-squad-hps.cloudfunctions.net"
let Auth_Key         = "vYv6I6g2XoC3So3FcuullGwdJrFXss9V2lPJZ3r9"

let ADMIN_USER_INFO  = "admin_user_info"
let TADMIN_USER_INFO = "tadmin_user_info"
let ADMIN            = "admin"
let TABLE_ADMIN      = "tableAdmin"
let CLOSED           = "closed"
let OPEN             = "open"
let STATUS           = "status"
let MESSAGE          = "message"



public struct Constants {
    static let AppName                = "HPS_Admin"
    static let TERMS_AND_SERVICES_URL = ""
    static let StoryBoardName         = "Main"
    static let SUCCESS                = "ok"
    static let ERROR                  = "error"
}
//MARK : - ViewController IDs
public  struct ViewControllerIDs {
    static let LoginViewController       =  "LoginViewController"
    static let TabBarController          =  "TabBarController"
    static let UsersViewController       = "UsersViewController"
    static let EventsViewController      = "EventsViewController"
    static let SettingsViewController    = "SettingsViewController"
    static let AddUserViewController     = "AddUserViewController"
    static let UserDetailsViewController = "UserDetailsViewController"
    static let AddEventViewController    = "AddEventViewController"
    static let BookingHistoryVC          = "BookingHistoryVC"
    static let BookASeatViewController   = "BookASeatViewController"
    static let CreateTableAdminVC        = "CreateTableAdminVC"
    static let GetBuyInsViewController   = "GetBuyInsViewController"
    static let AddBuyInsAndCashOutVC     = "AddBuyInsAndCashOutVC"
    static let CloseEventViewController  = "CloseEventViewController"
}
//MARK : - Device INFO
public struct DeviceInfo {
    static let DefaultDeviceToken = "2222222"
    static let DeviceType         = "IOS"
    static let Device             = "MOBILE"
}
//MARK : - All Apis
public struct ApiURls{
    static let LOGIN_USER           = "\(SERVER_IP)/login"
    static let GET_ALL_USERS        = "https://home-poker-squad-hps.firebaseio.com/usersTable/.json?auth=\(Auth_Key)"
    static let GET_ALL_EVENTS       = "https://home-poker-squad-hps.firebaseio.com/eventsTable/.json?auth=\(Auth_Key)"
    static let CREATE_REFERAL       = "\(SERVER_IP)/createNewUserReferral"
    static let CREATE_EVENT         = "\(SERVER_IP)/createEvent"
    static let CREATE_TABLE_ADMIN   = "\(SERVER_IP)/createTAdmin"
    static let DELETE_TABLE_ADMIN   = "\(SERVER_IP)/deleteTAdmin"
    static let ADMIN_PROFILE_API    = "\(SERVER_IP)/admin"
    static let EVENT_STATUS_API     = "\(SERVER_IP)/changeEventBookingStatus"
    static let GET_ALL_BOOKINGS     = "https://home-poker-squad-hps.firebaseio.com/bookingsTable/.json?auth=\(Auth_Key)"
    static let BOOK_SEATS           = "\(SERVER_IP)/bookSeats"
    static let CHANGE_USER_STATUS   = "\(SERVER_IP)/changeUserStatus"
    static let REDEEM_REWARD_POINTS = "\(SERVER_IP)/redeemRewardPoints"
    static let BLOCK_SEATS          = "\(SERVER_IP)/blockSeat"
    static let UNBLOCK_SEATS        = "\(SERVER_IP)/unBlockSeat"
    static let ADD_BUYIN            = "\(SERVER_IP)/addBuyIn"
    static let CASH_OUT             = "\(SERVER_IP)/cashout"
    static let START_EVENT          = "\(SERVER_IP)/startEvent"
    static let END_EVENT            = "\(SERVER_IP)/endEvent"
    static let CLOSE_EVENT          = "\(SERVER_IP)/closeEvent"
    static let MODIFY_REWARD_POINTS = "\(SERVER_IP)/changeEventsRewardPointsPerHour"
    static let DELETE_EVENT         = "\(SERVER_IP)/deleteEvent"
}
// MARK : - Toast Messages
public struct ToastMessages {
    static let  Unable_To_Sign_UP          = "Unable to register now, Please try again...😞"
    static let Check_Internet_Connection   = "Please check internet connection"
    static let Some_thing_went_wrong       = "Something went wrong...🙃, Please try again."
    static let Invalid_Credentials         = "Invalid credentials...🤔"
    static let Success                     = "Success...😀"
    static let Email_Address_Is_Not_Valid  = "Email address is not valid"
    static let Invalid_Email               = "Invalid Email Address"
    static let Invalid_Username            = "Invalid Username"
    static let Invalid_Number              = "Invalid Mobile Number"
    static let Invalid_Password            = "Password must contains min 6 character"
    static let Please_Wait                 = "Please wait..."
    static let Password_Missmatch          = "Password Missmatch...😟"
    static let Logout                      = "Logout Successfully...🤚"
    static let Invalid_Latitude            = "Invalid latitude"
    static let Invalid_Longitude           = "Invalid longitude"
    static let Invalid_Address             = "Invalid Address"
    static let Invalid_SelectedAddressType = "Please choose address type"
    static let Invalid_OthersMsg           = "Please give the address type of Others"
    static let Invalid_Strong_Password     = "Password should be at least 6 characters, which Contain At least 1 uppercase, 1 lower case, 1 Numeric digit."
    static let Invalid_OTP                 =  "Invalid OTP"
    static let No_Data_Available           = "No Data Available"
    static let Invalid_Name                = "Invalid Name"
    static let Invalid_Apartmrnt           = "Please enter valid House No/Flat No"
    static let Session_Expired             = "Your session has been expired.Please login again"
    static let Invalid_EventName           = "Invalid Event Name"
    static let Invalid_StartTime           = "Invalid Start Time"
    static let Invalid_Seats               = "Invalid Provide Seats"
    static let Invalid_Duration            = "Invalid Duration"
}
//MARK:- XIB Names
public struct XIBNames{
    static let EventTableViewCell    = "EventTableViewCell"
    static let UsersCell             = "UsersCell"
    static let TAdminCell            = "TAdminCell"
    static let AddTAdminCell         = "AddTAdminCell"
    static let AdminProfileCell      = "AdminProfileCell"
    static let SwitchTableViewCell   = "SwitchTableViewCell"
    static let BookSeatTableViewCell = "BookSeatTableViewCell"
    static let UsersListCell         = "UsersListCell"
    static let LogoutCell            = "LogoutCell"
    static let BuyInsCell            = "BuyInsCell"
    static let BuyInsDetailCell      = "BuyInsDetailCell"
}
//MARK:- Api Paramaters
public struct ApiParams  {
    static let User_Details                 = "userDetails"
    static let Staus_Code                   = "status"
    static let Message                      = "message"
    static let MobileNumber                 = "mobileNumber"
    static let Name                         = "name"
    static let EmailId                      = "emailId"
    static let DeviceId                     = "deviceId"
    static let Password                     = "password"
    static let UserType                     = "type"
    static let CreatedOn                    = "createdOn"
    static let CreatedByID                  = "createdById"
    static let CreatedByName                = "createdByName"
    static let EventStartTime               = "eventStartTime"
    static let EventEndTime                 = "eventEndTime"
    static let EventRewardsPoints           = "eventRewardPoints"
    static let TotalSeatsAvailable          = "totalSeatsAvailable"
    static let BookingStatus                = "bookingStatus"
    static let TAdminId                     = "tAdminId"
    static let AdminType                    = "adminType"
    static let EventId                      = "eventId"
    static let UserIds                      = "userIds"
    static let UserId                       = "userId"
    static let BookFromBlockedSeats         = "bookFromBlockedSeats"
    static let NewStatus                    = "newStatus"
    static let EnteredRewardPoints          = "enteredRewardPoints"
    static let EnteredOtpValue              = "enteredOtpValue"
    static let NoOfSeatsRequestedToUnBlock  = "noOfSeatsRequestedToUnBlock"
    static let NoOfSeatsRequestedToBlock    = "noOfSeatsRequestedToBlock"
    static let BookingId                    = "bookingId"
    static let BuyInValue                   = "buyInValue"
    static let CashoutValue                 = "cashoutValue"
    static let StartedOn                    = "startedOn"
    static let StartedById                  = "startedById"
    static let StartedByName                = "startedByName"
    static let EndedOn                      = "endedOn"
    static let EndedById                    = "endedById"
    static let EndedByName                  = "endedByName"
    static let ClosedOn                     = "closedOn"
    static let ClosedById                   = "closedById"
    static let ClosedByName                 = "closedByName"
    static let RakeAndTips                  = "rakeAndTips"
    static let OtherExpenses                = "otherExpenses"
    static let ConfirmStatus                = "confirmStatus"
    static let ValidateAndConfirm           = "confirmed"
    static let Adjustments                  = "adjustments"
    static let newEventsRewardPointsPerHour = "newEventsRewardPointsPerHour"
    static let ID                           = "id"
}
