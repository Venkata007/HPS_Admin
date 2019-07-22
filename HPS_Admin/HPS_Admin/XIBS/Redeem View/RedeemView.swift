//
//  RedeemView.swift
//  HPS_Admin
//
//  Created by Vamsi on 10/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class RedeemView: UIViewController {

    @IBOutlet weak var pointsTF: UITextField!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var redeemBtn: UIButton!
    
    var mobileNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerAndBorder(self.view, cornerRadius: 10, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.pointsTF, cornerRadius: 5, borderWidth: 1, borderColor: #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 0.5))
        TheGlobalPoolManager.cornerAndBorder(self.otpTF, cornerRadius: 5, borderWidth: 1, borderColor: #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 0.5))
        self.redeemBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- Redeem Api Api
    func redeemApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EnteredRewardPoints: self.pointsTF.text!,
                                ApiParams.EnteredOtpValue: self.otpTF.text!,
                                ApiParams.MobileNumber: self.mobileNumber!,
                                ApiParams.CreatedOn: TheGlobalPoolManager.getTodayString(),
                                ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!,
                                ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.REDEEM_REWARD_POINTS, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    NotificationCenter.default.post(name: Notification.Name("RedeemButtonClicked"), object: nil)
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func redeemBtn(_ sender: UIButton) {
        if validate(){
            self.redeemApiHitting()
        }
    }
}
extension RedeemView{
    func validate() -> Bool{
        if (self.pointsTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid Points")
            return false
        }else if (self.otpTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_OTP)
            return false
        }else if (self.mobileNumber.isEmpty){
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }
        return true
    }
}
