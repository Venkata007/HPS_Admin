
//
//  LoginViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 04/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var viewInViews: [UIView]!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var selectTypeSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userNameTF.text = "admin"
        self.passwordTF.text = "admin@123"
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
         TheGlobalPoolManager.selectedUserType = ADMIN
        for view in viewInViews{
            TheGlobalPoolManager.cornerAndBorder(view, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.loginBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius:self.imgView.h / 2, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- Pushing To HomeVC
    func pushingToHomeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerIDs.TabBarController) as! TabBarController
        controller.selectedIndex = 1
        DispatchQueue.main.async {
            if let unselectedImage = UIImage(named: "Events_deactive"), let selectedImage = UIImage(named: "Events_active") {
                controller.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
            }
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    //MARK:- Login Api Hitting
    func loginApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.MobileNumber: self.userNameTF.text!,
                      ApiParams.Password: self.passwordTF.text!,
                      ApiParams.UserType: TheGlobalPoolManager.selectedUserType,
                      ApiParams.DeviceId: TheGlobalPoolManager.instanceIDTokenMessage] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.LOGIN_USER, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    if TheGlobalPoolManager.selectedUserType == ADMIN{
                      ModelClassManager.adminLoginModel = AdminLoginModel.init(fromJson: dataResponse.json)
                        UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: ADMIN_USER_INFO)
                        self.pushingToHomeVC()
                    }else{
                        ModelClassManager.tAdminLoginModel = TAdminLoginModel.init(fromJson: dataResponse.json)
                        UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: TADMIN_USER_INFO)
                    }
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func loginBtn(_ sender: UIButton) {
        if loginValidate(){
            self.loginApiHitting()
        }
    }
    @IBAction func selectTypeSegControl(_ sender: UISegmentedControl) {
        if self.selectTypeSegControl.selectedSegmentIndex == 0{
            TheGlobalPoolManager.selectedUserType = ADMIN
        }else{
            TheGlobalPoolManager.selectedUserType = TABLE_ADMIN
            self.userNameTF.keyboardType = .numberPad
        }
    }
}
extension LoginViewController{
    func loginValidate() -> Bool{
        if (self.userNameTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Username)
            return false
        }else if (self.passwordTF.text?.isEmpty)!{
            TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Password)
            return false
        }
        return true
    }
}
