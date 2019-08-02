//
//  ChangePasswordVC.swift
//  HPS_User
//
//  Created by Vamsi on 01/08/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet var viewsInView: [UIView]!
    
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
        self.updateBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- IB Action Outlets
    @IBAction func updateBtn(_ sender: UIButton) {
        if validate(){
            if (self.newPasswordTF.text?.isPasswordValid)!{
                self.updatePasswordApiHitting()
            }else{
                TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Password)
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
}
extension ChangePasswordVC{
    func validate() -> Bool{
        if (self.oldPasswordTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid Old Password")
            return false
        }else if (self.newPasswordTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView("Invalid New Password")
            return false
        }
        return true
    }
}
extension ChangePasswordVC{
    //MARK:- Update Password Api Hitting
    func updatePasswordApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.MobileNumber: ModelClassManager.adminLoginModel.data.id!,
                                ApiParams.Password: self.oldPasswordTF.text!,
                                ApiParams.NewPassword: self.newPasswordTF.text!,
                                ApiParams.UserType: ModelClassManager.adminLoginModel.data.type == ADMIN ? ADMIN : TABLE_ADMIN ] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.UPDATE_PASSWORD, params: param as [String : AnyObject], header: HEADER) { (dataResponse, success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: "status") as! String
                let message = dict.object(forKey: "message") as! String
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
