//
//  BookASeatViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BookASeatViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookSeatsBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var coinsLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var noOFUsersLbl: UILabel!
    @IBOutlet weak var bookStsLbl: UILabel!
    @IBOutlet weak var ribbonImageView: UIImageView!
    
    var selectedUsers = [String]()
    var selectedUsersNames = [String]()
    var selectedUsersMobileNum = [String]()
    var selectedUsersProfileUrls = [String]()
    var selectedEvent : EventsData!
    var allUsers = [UsersData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.BookSeatTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.BookSeatTableViewCell)
        tableView.tableFooterView = UIView()
        ez.runThisInMainThread {
            self.updateUI()
        }
    }
    func isBookingButtonHigh(_ isHigh:Bool){
        //self.ribbonImageView.isHidden = isHigh
        //self.balanceLbl.isHidden = isHigh
        self.bookBtn.isHidden = !isHigh
    }
    //MARK:- Update UI
    func updateUI(){
        self.allUsers = []
        self.bookSeatsBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerAndBorder(self.bookBtn, cornerRadius: 20, borderWidth: 0, borderColor: .clear)
        }
        if let data  = selectedEvent{
            self.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
            self.coinsLbl.text = " \(data.eventRewardPoints!.toString)"
            self.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
            self.bookStsLbl.isHidden = true
            self.switch.isHidden = true
            self.bookBtn.isHidden = true
            //self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            switch data.eventStatus! {
            case EVENT_CREATED:
                self.statusImgView.image = #imageLiteral(resourceName: "created")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.isBookingButtonHigh(true)
            case EVENT_RUNNING:
                self.statusImgView.image = #imageLiteral(resourceName: "running")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
            case EVENT_FINISHED:
                self.statusImgView.image = #imageLiteral(resourceName: "finish")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
            case EVENT_CLOSED:
                self.statusImgView.image = #imageLiteral(resourceName: "closed")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
            default:
                break
            }
        }
        ModelClassManager.getAllUsersApiHitting(self, progress: true) { (success, response) -> (Void) in
            if success{
                if let usersList = ModelClassManager.usersListModel{
                    self.allUsers = usersList.approvedUsers.filter({ (userDetail) -> Bool in
                        return !self.selectedEvent.bookingUserIds.contains(where: { (userData) -> Bool in
                            return userData.userID == userDetail.userId
                        })
                    })
                }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func bookBtn(_ sender: UIButton) {
        if self.selectedUsers.count != 0{
            if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.ConfirmViewContoller) as? ConfirmViewContoller{
                viewCon.hidesBottomBarWhenPushed = true
                viewCon.selectedEvent = self.selectedEvent
                viewCon.selectedUsers = selectedUsers
                viewCon.selectedUsersNames = selectedUsersNames
                viewCon.selectedUsersMobileNum = selectedUsersMobileNum
                viewCon.selectedUsersProfileUrls = selectedUsersProfileUrls
                ez.topMostVC?.presentVC(viewCon)
            }
        }else{
            TheGlobalPoolManager.showToastView("Please select any one of the Users")
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func bookSeatsBtn(_ sender: UIButton) {
        if self.selectedUsers.count != 0{
            let selectedUsers = self.selectedUsersNames.joined(separator: ",")
            TheGlobalPoolManager.showAlertWith(title: "Selected Users", message: "\(selectedUsers)", singleAction: false, okTitle:"Continue") { (sucess) in
                if sucess!{
                    
                }
            }
        }
    }
}
extension BookASeatViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.allUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let data =  self.allUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BookSeatTableViewCell) as! BookSeatTableViewCell
        cell.nameLbl.text = data.name!
        cell.numberLbl.text =  data.mobileNumber!
        let imgUrl = NSURL(string:data.profilePicUrl)!
        cell.imgView.sd_setImage(with: imgUrl as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
        let selectedValue = selectedUsers.contains(data.userId!)
        let selectedName = selectedUsersNames.contains(data.name!)
        let seletedMobNum = selectedUsersMobileNum.contains(data.mobileNumber!)
        let selectedProfileUrls = selectedUsersProfileUrls.contains(data.profilePicUrl!)
        if selectedValue && selectedName && seletedMobNum && selectedProfileUrls{
            cell.cellSelected(true)
        }else{
            cell.cellSelected(false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data =  self.allUsers[indexPath.row]
        let selectedValue = selectedUsers.contains(data.userId!)
        let selectedName = selectedUsersNames.contains(data.name!)
        let seletedMobNum = selectedUsersMobileNum.contains(data.mobileNumber!)
        let selectedProfileUrls = selectedUsersProfileUrls.contains(data.profilePicUrl!)
        if !selectedValue && !selectedName && !seletedMobNum && !selectedProfileUrls{
            selectedUsers.append(data.userId!)
            selectedUsersNames.append(data.name!)
            selectedUsersMobileNum.append(data.mobileNumber!)
            selectedUsersProfileUrls.append(data.profilePicUrl!)
        }else{
            let indx = selectedUsers.index(of: data.userId!)
            let indx1 = selectedUsersNames.index(of: data.name!)
            let indx2 = selectedUsersMobileNum.index(of: data.mobileNumber!)
            let indx3 = selectedUsersProfileUrls.index(of: data.profilePicUrl!)
            selectedUsers.remove(at: indx!)
            selectedUsersNames.remove(at: indx1!)
            selectedUsersMobileNum.remove(at: indx2!)
            selectedUsersProfileUrls.remove(at: indx3!)
        }
        tableView.reloadData()
        print(selectedUsers)
        print(selectedUsersNames)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let data =  self.allUsers[indexPath.row]
        let selectedValue = selectedUsers.contains(data.userId!)
        let selectedName = selectedUsersNames.contains(data.name!)
        let seletedMobNum = selectedUsersMobileNum.contains(data.mobileNumber!)
        let selectedProfileUrls = selectedUsersProfileUrls.contains(data.profilePicUrl!)
        if selectedValue && selectedName && seletedMobNum && selectedProfileUrls {
            let indx = selectedUsers.index(of: data.userId!)
            let indx1 = selectedUsersNames.index(of: data.name!)
            let indx2 = selectedUsersMobileNum.index(of: data.mobileNumber!)
            let indx3 = selectedUsersProfileUrls.index(of: data.profilePicUrl!)
            selectedUsers.remove(at: indx!)
            selectedUsersNames.remove(at: indx1!)
            selectedUsersMobileNum.remove(at: indx2!)
            selectedUsersProfileUrls.remove(at: indx3!)
        }
        tableView.reloadData()
        print(selectedUsers)
        print(selectedUsersNames)
    }
}



