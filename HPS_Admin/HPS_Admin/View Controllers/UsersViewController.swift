//
//  UsersViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 08/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SwiftyJSON

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addUserBtn: UIButton!
    var sections = ["Pending Users","Blocked Users","New Users","Approved Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.UsersCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersCell)
        tableView.delegate = self
        tableView.dataSource = self
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.addUserBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : addUserBtn.h / 2)
        tableView.tableFooterView = UIView()
        self.getAllUsersApiHitting()
    }
    //MARK:- Pushing To Add User VC
    func pushingToAddUserVC(){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.AddUserViewController) as? AddUserViewController{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon)
        }
    }
    //MARK:- Get All Users Api Hitting
    func getAllUsersApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        APIServices.getUrlSession(urlString: ApiURls.GET_ALL_USERS, params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                ModelClassManager.usersListModel  = UsersListModel(fromJson: JSON(dict))
                if ModelClassManager.usersListModel.success{
                    self.tableView.reloadData()
                }
            }else{
                TheGlobalPoolManager.showToastView("No data available")
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addUserBtn(_ sender: UIButton) {
        self.pushingToAddUserVC()
    }
}
extension UsersViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:self.tableView.frame.size.width, height: 30))
        headerLabel.font = UIFont.appFont(.Bold, size: 17)
        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        headerLabel.text = self.sections[section]
        headerView.addSubview(headerLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let user = ModelClassManager.usersListModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersCell) as! UsersCell
        cell.referalSendBtn.isHidden = true
        cell.referalCodeTitleLbl.isHidden = true
        cell.nameLbl.text = user.name!
        cell.numberLbl.text =  user.mobileNumber!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.UserDetailsViewController) as? UserDetailsViewController{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon) 
        }
    }
}
