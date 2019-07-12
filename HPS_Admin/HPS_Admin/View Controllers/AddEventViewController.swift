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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        for view in viewsInView{
            view.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        }
        self.createEventBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- IB Action Outlets
    @IBAction func eventStatusSwitch(_ sender: UISwitch) {
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func createEventBtn(_ sender: UIButton) {
        if validate(){
            
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
