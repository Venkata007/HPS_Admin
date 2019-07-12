//
//  BookingHistoryVC.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BookingHistoryVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var bookedLbl: UILabel!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.UsersCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersCell)
        tableView.register(UINib(nibName: XIBNames.SwitchTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.SwitchTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.editBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : editBtn.h / 2)
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        TheGlobalPoolManager.cornerAndBorder(self.availableLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.bookedLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.completedLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func editBtn(_ sender: UIButton) {
        if sender.tag == 0{
            sender.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            sender.tag = 1
        }else{
            sender.setImage(#imageLiteral(resourceName: "Pencil"), for: .normal)
            sender.tag = 0
        }
    }
}
extension BookingHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 4{
             let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.SwitchTableViewCell) as! SwitchTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersCell) as! UsersCell
        cell.referalSendBtn.isHidden = true
        cell.referalCodeTitleLbl.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 80
        }
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
