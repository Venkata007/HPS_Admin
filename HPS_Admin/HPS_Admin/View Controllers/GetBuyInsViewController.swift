//
//  GetBuyInsViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 22/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class GetBuyInsViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
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
    @IBOutlet weak var addBuyInsBtn: UIButton!
    @IBOutlet weak var cashOutBtn: UIButton!
    var selectedEvent : EventsData!
    var selectedUser : GetAllBookings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.BuyInsCell, bundle: nil), forCellReuseIdentifier: XIBNames.BuyInsCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        ez.runThisInMainThread {
            self.updateUI()
        }
    }
    //MARK:- Update UI
    func updateUI(){
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        }
        if let data  = selectedEvent{
            self.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
            self.coinsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
            self.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
            if data.eventStatus! == "running"{
                if self.selectedUser.status == "confirmed"{
                    self.addBuyInsBtn.isHidden = false
                    self.cashOutBtn.isEnabled = false
                    self.cashOutBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }else if self.selectedUser.status == "playing"{
                    self.addBuyInsBtn.isHidden = false
                    self.cashOutBtn.isHidden = false
                }else{
                    self.addBuyInsBtn.isHidden = true
                    self.cashOutBtn.isHidden = true
                }
            }else{
                self.addBuyInsBtn.isHidden = true
                self.cashOutBtn.isHidden = true
            }
            switch data.eventStatus! {
            case "created":
                if data.bookingStatus == "open"{
                    self.switch.isOn = true
                }else{
                    self.switch.isOn = false
                }
                self.switch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                self.balanceLbl.isHidden = true
                self.bookBtn.isHidden = false
                self.statusImgView.image = #imageLiteral(resourceName: "created")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case "running":
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.balanceLbl.isHidden = false
                self.bookBtn.isHidden = true
                self.statusImgView.image = #imageLiteral(resourceName: "running")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalcashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case "finished":
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.balanceLbl.isHidden = false
                self.bookBtn.isHidden = true
                self.statusImgView.image = #imageLiteral(resourceName: "finish")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalcashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case "closed":
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.balanceLbl.isHidden = false
                self.bookBtn.isHidden = true
                self.statusImgView.image = #imageLiteral(resourceName: "closed")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalcashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            default:
                break
            }
        }
    }
    @objc func switchChanged(_ sender : UISwitch){
        if let data = self.selectedEvent{
            if data.bookingStatus == OPEN{
                ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: CLOSED, viewCon: self) { (success, response) -> (Void) in
                    if success{
                        ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                            self.tableView.reloadData()
                        }
                    }
                }
            }else{
                ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: OPEN, viewCon: self) { (success,
                    response) -> (Void) in
                    if success{
                        ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func addBuyInsBtn(_ sender: UIButton) {
        self.pushingToAddBuyInsAndCashOutVC(true)
    }
    @IBAction func cashOutBtn(_ sender: UIButton) {
        self.pushingToAddBuyInsAndCashOutVC(false)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
}
extension GetBuyInsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let data = self.selectedUser!
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BuyInsCell) as! BuyInsCell
        cell.rewardPointsLbl.text = "\(data.userEventRewardPoints!.toString)\n points"
        cell.bookingIDLbl.text = "\(data.userName!)\n \(data.bookingId!)"
        if data.status == "confirmed"{
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinsAt!)
        }else{
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        }
        cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance\n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.balance!))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedUser.buyIns.count <= 2{
            return 150
        }
        return CGFloat(100 +  (self.selectedUser.buyIns.count * 25))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
//MARK:- Collection View Delegate Methods
extension GetBuyInsViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedUser.buyIns.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIBNames.BuyInsDetailCell, for: indexPath as IndexPath) as! BuyInsDetailCell
        cell.lbl1.text = TheGlobalPoolManager.getFormattedDate2(string: self.selectedUser.buyIns[indexPath.row].createdOn!)
        cell.lbl2.text = "₹ \(TheGlobalPoolManager.formatNumber(self.selectedUser.buyIns[indexPath.row].amount!))"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
}
extension GetBuyInsViewController{
    func pushingToAddBuyInsAndCashOutVC(_ isSelected : Bool){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.AddBuyInsAndCashOutVC) as? AddBuyInsAndCashOutVC{
            viewCon.isAddBuyIns = isSelected
            viewCon.selectedUser = self.selectedUser
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
