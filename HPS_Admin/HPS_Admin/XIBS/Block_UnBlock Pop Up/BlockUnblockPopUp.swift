//
//  BlockUnblockPopUp.swift
//  HPS_Admin
//
//  Created by Vamsi on 22/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class BlockUnblockPopUp: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var reduceBtn: UIButton!
    @IBOutlet weak var noOfSeatsTF: UITextField!
    @IBOutlet weak var blockUnBlockBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var selectedEvent : EventsData!
    var isBlockBtnClicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        if isBlockBtnClicked{
            self.titleLbl.text = "Want to Block Seats ?"
            self.blockUnBlockBtn.setTitle("Block", for: .normal)
        }else{
            self.titleLbl.text = "Want to Unblock Seats ?"
            self.blockUnBlockBtn.setTitle("Unblock", for: .normal)
        }
        self.noOfSeatsTF.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.addBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : self.addBtn.h / 2)
        self.reduceBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : self.reduceBtn.h / 2)
        TheGlobalPoolManager.cornerAndBorder(self.cancelBtn, cornerRadius: 5, borderWidth: 1, borderColor: #colorLiteral(red: 0.04705882353, green: 0.7137254902, blue: 0.8470588235, alpha: 1))
        TheGlobalPoolManager.cornerAndBorder(blockUnBlockBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- Block Seats Api
    func blockSeatsApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: self.selectedEvent.eventId!,
                                ApiParams.NoOfSeatsRequestedToBlock: self.noOfSeatsTF.text!.toInt()!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.BLOCK_SEATS, params: param as [String : AnyObject], header: HEADER) { (dataResponse,success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
                if dataResponse.json.exists(){
                    let dict = dataResponse.dictionaryFromJson! as NSDictionary
                    let status = dict.object(forKey: STATUS) as! String
                    let message = dict.object(forKey: MESSAGE) as! String
                    if status == Constants.SUCCESS{
                        self.selectedEvent.seats.available = self.selectedEvent.seats.available - self.noOfSeatsTF.text!.toInt()!
                        self.selectedEvent.seats.booked = self.selectedEvent.seats.booked
                        self.selectedEvent.seats.blocked = self.selectedEvent.seats.blocked + self.noOfSeatsTF.text!.toInt()!
                        TheGlobalPoolManager.showToastView(message)
                        NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil, userInfo: ["SelectedEvent":self.selectedEvent])
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                        NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil)
                    }
                }
            }
        }
    }
    //MARK:- UnBlock Seats Api
    func unBlockSeatsApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: self.selectedEvent.eventId!,
                      ApiParams.NoOfSeatsRequestedToUnBlock: self.noOfSeatsTF.text!.toInt()!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.UNBLOCK_SEATS, params: param as [String : AnyObject], header: HEADER) { (dataResponse,success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
                if dataResponse.json.exists(){
                    let dict = dataResponse.dictionaryFromJson! as NSDictionary
                    let status = dict.object(forKey: STATUS) as! String
                    let message = dict.object(forKey: MESSAGE) as! String
                    if status == Constants.SUCCESS{
                        self.selectedEvent.seats.available = self.selectedEvent.seats.available + self.noOfSeatsTF.text!.toInt()!
                        self.selectedEvent.seats.booked = self.selectedEvent.seats.booked
                        self.selectedEvent.seats.blocked = self.selectedEvent.seats.blocked - self.noOfSeatsTF.text!.toInt()!
                        TheGlobalPoolManager.showToastView(message)
                        NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil, userInfo: ["SelectedEvent":self.selectedEvent])
                        TheGlobalPoolManager.showToastView(message)
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                        NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil)
                    }
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addBtn(_ sender: UIButton) {
        let value = ((self.noOfSeatsTF.text?.toInt())! + 1)
        if value > (self.isBlockBtnClicked ? self.selectedEvent.seats.available! : self.selectedEvent.seats.blocked!){
            return
        }
        self.noOfSeatsTF.text = value.toString
    }
    @IBAction func reduceBtn(_ sender: UIButton) {
        let value = ((self.noOfSeatsTF.text?.toInt())! - 1)
        if value <= (self.isBlockBtnClicked ? self.selectedEvent.seats.available! : self.selectedEvent.seats.blocked!) && value >= 1{
            self.noOfSeatsTF.text = value.toString
        }
    }
    @IBAction func blockUnBlockBtn(_ sender: UIButton) {
        if isBlockBtnClicked{
            self.blockSeatsApiHitting()
        }else{
            self.unBlockSeatsApiHitting()
        }
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil)
    }
}
