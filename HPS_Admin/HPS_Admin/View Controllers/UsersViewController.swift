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
    var sections = ["Approved Users","Registered Users","Pending Users","New Users","Blocked Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.UsersCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersCell)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(USER_UPDATED), object: nil)
        self.updateUI()
    }
    @objc func reloadData(_ userInfo:Notification){
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        ModelClassManager.getAllUsersApiHitting(self, progress: true) { (success, response) -> (Void) in
            self.tableView.delegate = self
            self.tableView.dataSource = self
            if ModelClassManager.usersListModel == nil{
                self.tableView.isHidden = true
                TheGlobalPoolManager.showAlertWith(message: "No Users Available", singleAction: true, callback: { (success) in
                    if success!{}
                })
            }
            self.tableView.reloadData()
        }
    }
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
    }
    //MARK:- Pushing To Add User VC
    func pushingToAddUserVC(){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.AddUserViewController) as? AddUserViewController{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon)
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addUserBtn(_ sender: UIButton) {
        self.pushingToAddUserVC()
    }
}
extension UsersViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:self.tableView.frame.size.width, height: 30))
        headerLabel.font = UIFont.appFont(.Bold, size: 20)
        headerLabel.textColor = .white
        headerLabel.text = self.sections[section]
        headerView.addSubview(headerLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = ModelClassManager.usersListModel
        switch section {
        case 0:
            return data?.approvedUsers.count == 0 ? 0 : 30
        case 1:
            return data?.registeredUsers.count == 0 ? 0 : 30
        case 2:
            return data?.pendingUsers.count == 0 ? 0 : 30
        case 3:
            return data?.newUsers.count == 0 ? 0 : 30
        case 4:
            return data?.blockedUsers.count == 0 ? 0 : 30
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let data = ModelClassManager.usersListModel
        switch section {
        case 0:
            return data?.approvedUsers.count == 0 ? 0 : 10
        case 1:
            return data?.registeredUsers.count == 0 ? 0 : 10
        case 2:
            return data?.pendingUsers.count == 0 ? 0 : 10
        case 3:
            return data?.newUsers.count == 0 ? 0 : 10
        case 4:
            return data?.blockedUsers.count == 0 ? 0 : 10
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.approvedUsers.count
        case 1:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.registeredUsers.count
        case 2:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.pendingUsers.count
        case 3:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.newUsers.count
        case 4:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.blockedUsers.count
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var user : UsersData!
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersCell) as! UsersCell
        switch indexPath.section {
        case 0:
             user =  ModelClassManager.usersListModel.approvedUsers[indexPath.row]
             cell.referalSendBtn.isHidden = true
             cell.referalCodeTitleLbl.isHidden = true
        case 1:
            user =  ModelClassManager.usersListModel.registeredUsers[indexPath.row]
            cell.referalSendBtn.isHidden = true
            cell.referalCodeTitleLbl.isHidden = true
        case 2:
            user =  ModelClassManager.usersListModel.pendingUsers[indexPath.row]
            cell.referalSendBtn.isHidden = true
            cell.referalCodeTitleLbl.isHidden = true
        case 3:
            user =  ModelClassManager.usersListModel.newUsers[indexPath.row]
            cell.referalSendBtn.isHidden = false
            cell.referalCodeTitleLbl.isHidden = false
            cell.referalCodeTitleLbl.text = user.referralCode!
        case 4:
            user =  ModelClassManager.usersListModel.blockedUsers[indexPath.row]
            cell.referalSendBtn.isHidden = true
            cell.referalCodeTitleLbl.isHidden = true
        default:
            break
        }
        cell.nameLbl.text = user.name!
        cell.numberLbl.text =  user.mobileNumber!
        let imgUrl = NSURL(string:user.profilePicUrl)!
        cell.imgView.sd_setImage(with: imgUrl as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.UserDetailsViewController) as? UserDetailsViewController{
            viewCon.hidesBottomBarWhenPushed = true
            if indexPath.section == 0{
                viewCon.selectedUser = ModelClassManager.usersListModel.approvedUsers[indexPath.row]
            }else if indexPath.section == 1{
                viewCon.selectedUser = ModelClassManager.usersListModel.registeredUsers[indexPath.row]
            }else if indexPath.section == 2{
                viewCon.selectedUser = ModelClassManager.usersListModel.pendingUsers[indexPath.row]
            }else if indexPath.section == 3{
                viewCon.selectedUser = ModelClassManager.usersListModel.newUsers[indexPath.row]
            }else if indexPath.section == 4{
                viewCon.selectedUser = ModelClassManager.usersListModel.blockedUsers[indexPath.row]
            }
            ez.topMostVC?.presentVC(viewCon) 
        }
    }
}
