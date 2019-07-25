//
//  AddBuyInsAndCashOutVC.swift
//  HPS_Admin
//
//  Created by Vamsi on 23/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AddBuyInsAndCashOutVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var viewsInView: [UIView]!
    @IBOutlet weak var buyIns_CashOutTF: UITextField!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var addBuyIns_CashOutBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    var datePicker:PickerView!
    let date = Date()
    var isAddBuyIns : Bool = false
    var selectedUser : GetAllBookings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        if isAddBuyIns{
            self.titleLbl.text = "Enter Buy In's"
            self.addBuyIns_CashOutBtn.setTitle("Add Buy In's", for: .normal)
        }else{
            self.titleLbl.text = "Enter CashOut"
            self.addBuyIns_CashOutBtn.setTitle("Add CashOut", for: .normal)
        }
        for view in viewsInView{
            TheGlobalPoolManager.cornerAndBorder(view, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.addBuyIns_CashOutBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- Add Buy In's Api
    func addBuyInsApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.BookingId: self.selectedUser.bookingId!,
                      ApiParams.BuyInValue: self.buyIns_CashOutTF.text!.toInt() ?? 0,
                      ApiParams.CreatedOn: self.dateTF.text!,
                      ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!,
                      ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.ADD_BUYIN, params: param as [String : AnyObject], header: HEADER) { (dataResponse, success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
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
    }
    //MARK:- Add Cash Out Api
    func addCashOutApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.BookingId: self.selectedUser.bookingID!,
                      ApiParams.CashoutValue: self.buyIns_CashOutTF.text!.toInt() ?? 0,
                      ApiParams.CreatedOn: self.dateTF.text!,
                      ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!,
                      ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.CASH_OUT, params: param as [String : AnyObject], header: HEADER) { (dataResponse, success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
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
    }
    //MARK:- IB Action Outlets
    @IBAction func addBuyInsAndCashOutBtn(_ sender: UIButton) {
        if validate(){
            if isAddBuyIns{
                self.addBuyInsApiHitting()
            }else{
                self.addCashOutApiHitting()
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func selectDateBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.datePickerView("Select Date and Time")
    }
}
extension AddBuyInsAndCashOutVC : PickerViewDelegate {
    func datePickerView( _ btnName : String){
        self.datePicker = nil
        self.datePicker = PickerView(frame: self.view.frame)
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = .blueColor
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
        self.dateTF.text = strDate
    }
}
extension AddBuyInsAndCashOutVC{
    func validate() -> Bool{
        if (self.buyIns_CashOutTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("\(isAddBuyIns ? "Invalid Buy In's" : "Invalid Cash Out")")
            return false
        }else if (self.dateTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid Date Selected")
            return false
        }
        return true
    }
}
