//
//  CloseEventViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 23/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CloseEventViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var totalButInsLbl: UILabel!
    @IBOutlet weak var totalCashOutLbl: UILabel!
    @IBOutlet weak var rakesAndTipsTF: UITextField!
    @IBOutlet weak var otherExpensesTF: UITextField!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var closeEventBtn: UIButton!
    
    var selectedEvent : EventsData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.rakesAndTipsTF.delegate = self
        self.otherExpensesTF.delegate = self
        TheGlobalPoolManager.cornerAndBorder(self.closeEventBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        if let data = self.selectedEvent{
            self.totalButInsLbl.text = data.audit.totalBuyIns!.toString
            self.totalCashOutLbl.text = data.audit.totalcashout!.toString
            //self.totalCashOutLbl.text = (data.audit.totalBuyIns! - (data.audit.totalcashout!.toString + self.rakesAndTipsTF.text! + self.otherExpensesTF.text!))
        }
    }
    //MARK:- Close Event Api
    func closeEventApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: self.selectedEvent.eventId!,
                      ApiParams.ClosedOn:  TheGlobalPoolManager.getTodayString(),
                      ApiParams.ClosedById: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!,
                      ApiParams.RakeAndTips: self.rakesAndTipsTF.text!,
                      ApiParams.OtherExpenses: self.otherExpensesTF.text!,
                      ApiParams.ConfirmStatus: ApiParams.ValidateAndConfirm] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.CLOSE_EVENT, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
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
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func closeEventBtn(_ sender: UIButton) {
        TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Are you sure\n You want to Close Game?", singleAction: false, okTitle: "Close", cancelTitle: "Cancel") { (success) in
            if success!{
                if self.validate(){
                    self.closeEventApiHitting()
                }
            }
        }
    }
}
extension CloseEventViewController{
    func validate() -> Bool{
        if (self.rakesAndTipsTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid Rakes & Tips")
            return false
        }else if (self.otherExpensesTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid Other Expenses")
            return false
        }
        return true
    }
}
extension CloseEventViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return true
    }
}
