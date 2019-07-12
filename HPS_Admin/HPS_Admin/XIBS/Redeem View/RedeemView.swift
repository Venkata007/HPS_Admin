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
    //MARK:- IB Action Outlets
    @IBAction func redeemBtn(_ sender: UIButton) {
        if validate(){
            NotificationCenter.default.post(name: Notification.Name("RedeemButtonClicked"), object: nil)
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
        }
        return true
    }
}
