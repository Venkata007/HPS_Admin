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
    var sections = ["Registered Users","Pending Users","Blocked Users","Approved Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.UsersCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersCell)
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        ModelClassManager.getAllUsersApiHitting(self) { (success, response) -> (Void) in
            if success{
                self.tableView.delegate = self
               self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- Update UI
    func updateUI(){
        self.addUserBtn.setImage(#imageLiteral(resourceName: "Add").withColor(#colorLiteral(red: 0.9199201465, green: 0.9765976071, blue: 0.9851337075, alpha: 1)), for: .normal)
        self.addUserBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : addUserBtn.h / 2)
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
        headerView.backgroundColor = #colorLiteral(red: 0.9199201465, green: 0.9765976071, blue: 0.9851337075, alpha: 1)
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:self.tableView.frame.size.width, height: 30))
        headerLabel.font = UIFont.appFont(.Bold, size: 20)
        headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        headerLabel.text = self.sections[section]
        headerView.addSubview(headerLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = ModelClassManager.usersListModel
        switch section {
        case 0:
            return data?.registeredUsers.count == 0 ? 0 : 30
        case 1:
            return data?.pendingUsers.count == 0 ? 0 : 30
        case 2:
            return data?.blockedUsers.count == 0 ? 0 : 30
        case 3:
            return data?.approvedUsers.count == 0 ? 0 : 30
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.registeredUsers.count
        case 1:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.pendingUsers.count
        case 2:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.blockedUsers.count
        case 3:
            return ModelClassManager.usersListModel == nil ? 0 : ModelClassManager.usersListModel.approvedUsers.count
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var user : UsersData!
        switch indexPath.section {
        case 0:
             user =  ModelClassManager.usersListModel.registeredUsers[indexPath.row]
        case 1:
            user =  ModelClassManager.usersListModel.pendingUsers[indexPath.row]
        case 2:
            user =  ModelClassManager.usersListModel.blockedUsers[indexPath.row]
        case 3:
            user =  ModelClassManager.usersListModel.approvedUsers[indexPath.row]
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersCell) as! UsersCell
        cell.referalSendBtn.isHidden = true
        cell.referalCodeTitleLbl.isHidden = true
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
                viewCon.selectedUser = ModelClassManager.usersListModel.registeredUsers[indexPath.row]
            }else if indexPath.section == 1{
                viewCon.selectedUser = ModelClassManager.usersListModel.pendingUsers[indexPath.row]
            }else if indexPath.section == 2{
                viewCon.selectedUser = ModelClassManager.usersListModel.blockedUsers[indexPath.row]
            }else if indexPath.section == 3{
                viewCon.selectedUser = ModelClassManager.usersListModel.approvedUsers[indexPath.row]
            }
            ez.topMostVC?.presentVC(viewCon) 
        }
    }
}
