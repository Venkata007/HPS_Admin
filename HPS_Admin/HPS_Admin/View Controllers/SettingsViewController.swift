//
//  SettingsViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 08/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sections = ["","","","Table Admins",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.EventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventTableViewCell)
        tableView.register(UINib(nibName: XIBNames.UsersListCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersListCell)
        tableView.register(UINib(nibName: XIBNames.TAdminCell, bundle: nil), forCellReuseIdentifier: XIBNames.TAdminCell)
        tableView.register(UINib(nibName: XIBNames.LogoutCell, bundle: nil), forCellReuseIdentifier: XIBNames.LogoutCell)
        tableView.register(UINib(nibName: XIBNames.AddTAdminCell, bundle: nil), forCellReuseIdentifier: XIBNames.AddTAdminCell)
        tableView.register(UINib(nibName: XIBNames.AdminProfileCell, bundle: nil), forCellReuseIdentifier: XIBNames.AdminProfileCell)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
        self.adminProfileApiHitting()
    }
    //MARK:- Create Table Admin VC
    @objc func pushingToCreateTabelAdminVC(_ sender : UIButton){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.CreateTableAdminVC) as? CreateTableAdminVC{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon)
        }
    }
    @objc func logoutMethod(_ btn : UIButton){
        TheGlobalPoolManager.showAlertWith(title: "Are you sure", message: "Do you want to Logout?", singleAction: false, okTitle:"Confirm") { (sucess) in
            if sucess!{
                if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.LoginViewController) as? LoginViewController{
                    self.navigationController?.pushViewController(viewCon, animated: true)
                }
            }
        }
    }
    //MARK:- Adimn Profile Api
    func adminProfileApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.AdminType: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.MobileNumber: ModelClassManager.adminLoginModel.data.id!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.ADMIN_PROFILE_API, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    ModelClassManager.adminProfileModel = AdminProfileModel.init(fromJson: dataResponse.json)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
    //MARK:- Delete Table Admin Api
    func deleteTableAdminApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.TAdminId: "",
                      ApiParams.CreatedOn: "",
                      ApiParams.CreatedByID: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.CreatedByName: ModelClassManager.adminLoginModel.data.name!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.DELETE_TABLE_ADMIN, params: param as [String : AnyObject], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                let status = dict.object(forKey: STATUS) as! String
                let message = dict.object(forKey: MESSAGE) as! String
                if status == Constants.SUCCESS{
                    TheGlobalPoolManager.showToastView(message)
                    // Reload Api Once..................
                }else{
                    TheGlobalPoolManager.showToastView(message)
                }
            }
        }
    }
}
extension SettingsViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count 
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:self.tableView.frame.size.width, height: 30))
        headerLabel.font = UIFont.appFont(.Bold, size: 17)
        headerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        headerLabel.text = self.sections[section]
        headerView.addSubview(headerLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 30
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 3:
            return ModelClassManager.adminProfileModel.tableAdmins.count == 0 ?  1 : 2
        default:
            break
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.AdminProfileCell) as! AdminProfileCell
            cell.mobileNumLbl.isHidden = true
            cell.nameLbl.isHidden = true
            cell.emailIDLbl.text = ModelClassManager.adminProfileModel.adminInfo.name!
            return cell
        case 1:
            let data = ModelClassManager.adminProfileModel.eventsInfo!
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventTableViewCell) as! EventTableViewCell
            cell.coinsImgView.isHidden = true
            cell.timeLbl.isHidden = true
            cell.bookBtn.isHidden = true
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.coinsLbl.isHidden = true
            cell.eventNameLbl.text = "Events"
            cell.userImgView.isHidden = true
            cell.usersLbl.isHidden = true
            cell.statusImgView.isHidden = true
            cell.eventNameLbl.font = UIFont.appFont(AppFonts.Bold)
            cell.lbl4.isHidden = false
            cell.lbl4.text = "New Events : \(data.created!)"
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.finished!.toString)\n", attr2Text: "Finished", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.closed!.toString)\n", attr2Text: "Closed", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.total!.toString)\n", attr2Text: "Total", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Running \n", attr2Text: "₹ \(data.running!)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            return cell
        case 2:
            let data = ModelClassManager.adminProfileModel.eventsInfo!
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersListCell) as! UsersListCell
            cell.coinsImgView.isHidden = true
            cell.dateLbl.isHidden = true
            cell.rewardPointsLbl.isHidden = true
            cell.userImgView.isHidden = true
            cell.buyInsLbl.isHidden = true
            cell.bookingIDLbl.text = "Buy In's & Cash Out"
            cell.bookingIDLbl.font = UIFont.appFont(AppFonts.Bold)
            cell.statusImgView.isHidden = true
            cell.userNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Buy In's & Cash Out \n", attr2Text: "\(data.totalBuyIns!)/\(data.totalCashout!)", attr1Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), attr2Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr1Font: 14, attr2Font: 18, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.userNameLbl.textAlignment = .center
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(data.totalUsersBalance!)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            return cell
        case 3:
            if ModelClassManager.adminProfileModel.tableAdmins.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.AddTAdminCell) as! AddTAdminCell
                cell.addTAdminBtn.addTarget(self, action: #selector(self.pushingToCreateTabelAdminVC(_:)), for: .touchUpInside)
                return cell
            }else if ModelClassManager.adminProfileModel.tableAdmins.count == 1{
                if indexPath.row == 0{
                    let data = ModelClassManager.adminProfileModel.tableAdmins[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.TAdminCell) as! TAdminCell
                    cell.nameLbl.text = data.name!
                    cell.emailIDLbl.text = data.emailId!
                    cell.mobileNumLbl.isHidden = true
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.AddTAdminCell) as! AddTAdminCell
                cell.addTAdminBtn.addTarget(self, action: #selector(self.pushingToCreateTabelAdminVC(_:)), for: .touchUpInside)
                return cell
            }
            let data = ModelClassManager.adminProfileModel.tableAdmins[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.TAdminCell) as! TAdminCell
            cell.nameLbl.text = data.name!
            cell.emailIDLbl.text = data.emailId!
            cell.mobileNumLbl.isHidden = true
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.LogoutCell) as! LogoutCell
            cell.logoutBtn.addTarget(self, action: #selector(self.logoutMethod(_:)), for: .touchUpInside)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 2:
            return 150
        case 4:
            return 50
        case 3:
            if ModelClassManager.adminProfileModel.tableAdmins.count == 0{
                return 50
            }else if ModelClassManager.adminProfileModel.tableAdmins.count == 1{
                if indexPath.row == 0{
                    return 100
                }
                return 50
            }
            return 100
        default:
            break
        }
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

