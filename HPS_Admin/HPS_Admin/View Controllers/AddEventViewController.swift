//
//  AddEventViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AddEventViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var viewsInView: [UIView]!
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var provideSeatsTF: UITextField!
    @IBOutlet weak var enterHoursTF: UITextField!
    @IBOutlet weak var eventStatusSwitch: UISwitch!
    @IBOutlet weak var createEventBtn: UIButton!
    @IBOutlet weak var datePickerBtn: UIButton!
    var datePicker:PickerView!
    let date = Date()
    var eventStatus : String = "open"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        for view in viewsInView{
            TheGlobalPoolManager.cornerAndBorder(view, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.createEventBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- Create Event Api
    func createEventApiHitting(_ endTime : String){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.Name: self.eventNameTF.text!,
                      ApiParams.EventStartTime: self.startTimeTF.text!,
                      ApiParams.EventEndTime: endTime,
                      ApiParams.EventRewardsPoints: ModelClassManager.adminProfileModel.eventsRewardPointsPerHour!,
                      ApiParams.TotalSeatsAvailable: self.provideSeatsTF.text!,
                      ApiParams.BookingStatus: self.eventStatus,
                      ApiParams.CreatedOn: TheGlobalPoolManager.getTodayString(),
                      ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.CREATE_EVENT, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    ez.topMostVC?.dismissVC(completion: nil)
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func datePickerBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.datePickerView("Select Start Time")
    }
    @IBAction func eventStatusSwitch(_ sender: UISwitch) {
        if sender.isOn{
            eventStatus = "open"
        }else{
            eventStatus = "closed"
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func createEventBtn(_ sender: UIButton) {
        if validate(){
            if ((self.enterHoursTF.text!.toInt()! > 0) && (self.enterHoursTF.text!.toInt()! <= 24)){
                let endTime = TheGlobalPoolManager.adding(hours: self.enterHoursTF.text!.toInt()!)
                self.createEventApiHitting(endTime)
            }else{
                TheGlobalPoolManager.showToastView("Oops! Invalid Hours Provided")
            }
        }
    }
}
extension AddEventViewController{
    func validate() -> Bool{
        if (self.eventNameTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_EventName)
            return false
        }else if (self.startTimeTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_StartTime)
            return false
        }else if (self.provideSeatsTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Seats)
            return false
        }else if (self.enterHoursTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Duration)
            return false
        }
        return true
    }
}
extension AddEventViewController : PickerViewDelegate {
    func datePickerView( _ btnName : String){
        self.datePicker = nil
        self.datePicker = PickerView(frame: self.view.frame)
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.datePicker.btnColour = #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1)
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        self.datePicker.nameLbl = btnName
        self.datePicker.show(attachToView: self.view)
    }
    //MARK : - Gertting Age  based on DOB
    func pickerViewDidSelectDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: (date))
        print(strDate)
        self.startTimeTF.text = strDate
    }
}

