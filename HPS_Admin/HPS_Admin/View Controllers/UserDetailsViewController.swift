//
//  UserDetailsViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 10/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rewardsPointsLbl: UILabel!
    @IBOutlet weak var emailIDTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var userTypeTF: UITextField!
    @IBOutlet weak var statusTF: UITextField!
    @IBOutlet weak var photoIDImgView: UIImageView!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var viewsInView: [UIView]!
    @IBOutlet weak var photoIDView: UIView!
    @IBOutlet weak var redeemBtn: UIButton!
    
    var selectedUser : UsersData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
          NotificationCenter.default.addObserver(self, selector: #selector(UserDetailsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("RedeemButtonClicked"), object: nil)
        self.updateUI()
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
    }
    //MARK:- Update UI
    func updateUI(){
        for view in viewsInView{
            TheGlobalPoolManager.cornerAndBorder(view, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.photoIDView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.approveBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.profileImgView, cornerRadius:5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
        TheGlobalPoolManager.cornerAndBorder(self.photoIDImgView, cornerRadius:5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
        if let data  = selectedUser{
            if data.status == "approved"{
                self.redeemBtn.isHidden = false
                self.approveBtn.setTitle("Block", for: .normal)
            }else{
                self.redeemBtn.isHidden = true
                self.approveBtn.setTitle("Approve", for: .normal)
            }
            self.nameLbl.text = data.name!
            let imgUrl = NSURL(string:data.profilePicUrl)!
            self.profileImgView.sd_setImage(with: imgUrl as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
            self.rewardsPointsLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Reward points : ", attr2Text: "\(data.userRewardPoints!.toString)", attr1Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), attr2Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr1Font: 16, attr2Font: 16, attr1FontName: AppFonts.Medium, attr2FontName: AppFonts.Bold)
            self.emailIDTF.text = data.emailId!
            self.mobileNumTF.text = data.mobileNumber!
            self.statusTF.text = data.status!.firstUppercased
            self.userTypeTF.text = "User" // Needs to check once again
            let photoIDURL = NSURL(string:data.photoIdUrl)!
            self.photoIDImgView.sd_setImage(with: photoIDURL as URL, placeholderImage: #imageLiteral(resourceName: "Upload_Document").withColor(.white), options: .cacheMemoryOnly, completed: nil)
            self.photoIDImgView.contentMode = .scaleAspectFit
        }
    }
    //MARK:- Approve Or Block Api
    func approveOrBlockApiHitting(_ status : String){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.UserId: self.selectedUser.userId!,
                                ApiParams.NewStatus: status,
                                ApiParams.CreatedOn: TheGlobalPoolManager.getTodayString(),
                                ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!,
                                ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.CHANGE_USER_STATUS, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
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
    @IBAction func approveBtn(_ sender: UIButton) {
        if let data = self.selectedUser{
            if data.status == "approved"{
                self.approveOrBlockApiHitting("blocked") 
            }else{
                self.approveOrBlockApiHitting("approved")
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func redeemBtn(_ sender: UIButton) {
        self.redeemPopUpView()
    }
}
extension UserDetailsViewController{
    //MARK: -  Redeem Pop Up View
    func redeemPopUpView(){
        let viewCon = RedeemView(nibName: "RedeemView", bundle: nil)
        viewCon.mobileNumber = self.selectedUser.mobileNumber!
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationFade)
    }
}
