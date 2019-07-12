//
//  UserDetailsViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 10/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import PopOverMenu

class UserDetailsViewController: UIViewController,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate {

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
    @IBOutlet weak var menuBtn: UIButton!
    
    let popOverViewController = PopOverViewController.instantiate()
    var optionsArray = ["Redeem","Block"]
    
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
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.photoIDView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.approveBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.profileImgView, cornerRadius:5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
        TheGlobalPoolManager.cornerAndBorder(self.photoIDImgView, cornerRadius:5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
    }
    //MARK:- IB Action Outlets
    @IBAction func approveBtn(_ sender: UIButton) {
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func menuBtn(_ sender: UIButton) {
        //POP MENU
        self.popOverViewController.set(titles: optionsArray)
        self.popOverViewController.set(separatorStyle: .singleLine)
        self.popOverViewController.popoverPresentationController?.sourceView = sender
        self.popOverViewController.popoverPresentationController?.sourceRect = sender.bounds
        self.popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.popOverViewController.preferredContentSize = CGSize(width: 120, height:self.optionsArray.count * 50)
        self.popOverViewController.presentationController?.delegate = self
        self.popOverViewController.completionHandler = { selectRow in
            if selectRow == 0{
                self.redeemPopUpView()
            }
        }
        self.present(self.popOverViewController, animated: true, completion: nil)
    }
}
extension UserDetailsViewController{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    //MARK: -  Redeem Pop Up View
    func redeemPopUpView(){
        let viewCon = RedeemView(nibName: "RedeemView", bundle: nil)
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationFade)
    }
}
