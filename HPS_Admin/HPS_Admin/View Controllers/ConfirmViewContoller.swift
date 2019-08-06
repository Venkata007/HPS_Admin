//
//  ConfirmViewContoller.swift
//  HPS_Admin
//
//  Created by Hexadots on 30/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ConfirmViewContoller: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ConfirmBtn: UIButton!
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
    @IBOutlet weak var noOFUsersLbl: UILabel!
    @IBOutlet weak var bookStsLbl: UILabel!
    @IBOutlet weak var ribbonImageView: UIImageView!
    @IBOutlet var checkBtns: [UIButton]!
    
    var selectedUsers = [String]()
    var selectedUsersNames = [String]()
    var selectedUsersMobileNum = [String]()
    var selectedUsersProfileUrls = [String]()
    var selectedEvent : EventsData!
    var isBookFromBlockedSeats : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.BookSeatTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.BookSeatTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
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
            TheGlobalPoolManager.cornerAndBorder(self.ConfirmBtn, cornerRadius: self.ConfirmBtn.h / 2, borderWidth: 0, borderColor: .clear)
        }
        if let data  = selectedEvent{
            if data.seats.available! == 0 || data.seats.blocked! == 0{
                for btn in checkBtns{
                    btn.isEnabled = false
                }
            }
            if data.seats.available != 0{
                for btn in checkBtns{
                    if btn.tag == 0{
                        btn.setImage(#imageLiteral(resourceName: "Checkbox_Fill").withColor(.white), for: .normal)
                    }
                    else if btn.tag == 1{
                        btn.setImage(#imageLiteral(resourceName: "Checkbox_Off").withColor(.white), for: .normal)
                    }
                }
            }else if data.seats.blocked != 0{
                for btn in checkBtns{
                    if btn.tag == 0{
                        btn.setImage(#imageLiteral(resourceName: "Checkbox_Off").withColor(.white), for: .normal)
                    }
                    else if btn.tag == 1{
                        btn.setImage(#imageLiteral(resourceName: "Checkbox_Fill").withColor(.white), for: .normal)
                    }
                }
            }else{
                for btn in checkBtns{
                    btn.isEnabled = false
                }
            }
            self.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
            self.coinsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
            self.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
            self.bookStsLbl.isHidden = true
            self.switch.isHidden = true
            self.balanceLbl.isHidden = true
            self.ribbonImageView.isHidden = true
            switch data.eventStatus! {
            case EVENT_CREATED:
                self.statusImgView.image = #imageLiteral(resourceName: "created")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case EVENT_RUNNING:
                self.statusImgView.image = #imageLiteral(resourceName: "running")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case EVENT_FINISHED:
                self.statusImgView.image = #imageLiteral(resourceName: "finish")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case EVENT_CLOSED:
                self.statusImgView.image = #imageLiteral(resourceName: "closed")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            default:
                break
            }
        }
        ModelClassManager.getAllUsersApiHitting(self, progress: true) { (success, response) -> (Void) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func confirmBtn(_ sender: UIButton) {
        TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Confirm Booking", singleAction: false, okTitle:"Continue") { (sucess) in
            if sucess!{
                self.bookSeatsApiHitting()
            }
        }
    }
    @IBAction func checkBtns(_ sender: UIButton) {
        for btn in checkBtns{
            if btn == sender{
                if btn.tag == 0{
                    btn.setImage(#imageLiteral(resourceName: "Checkbox_Fill").withColor(.white), for: .normal)
                    self.isBookFromBlockedSeats = false
                }
                else if btn.tag == 1{
                    btn.setImage(#imageLiteral(resourceName: "Checkbox_Fill").withColor(.white), for: .normal)
                    self.isBookFromBlockedSeats = true
                }
            }else{
                if btn.tag == 0{
                    btn.setImage(#imageLiteral(resourceName: "Checkbox_Off").withColor(.white), for: .normal)
                }
                else if btn.tag == 1{
                    btn.setImage(#imageLiteral(resourceName: "Checkbox_Off").withColor(.white), for: .normal)
                }
            }
        }
    }
}
extension ConfirmViewContoller : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.selectedUsersNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BookSeatTableViewCell) as! BookSeatTableViewCell
        cell.nameLbl.text = selectedUsersNames[indexPath.row]
        cell.numberLbl.text =  selectedUsersMobileNum[indexPath.row]
        let imgUrl = NSURL(string:selectedUsersProfileUrls[indexPath.row])!
        cell.imgView.sd_setImage(with: imgUrl as URL, placeholderImage: #imageLiteral(resourceName: "ProfilePlaceholder"), options: .cacheMemoryOnly, completed: nil)
        cell.checkBoxWidth.constant = 0
        cell.check_unchekImgView.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension ConfirmViewContoller {
    //MARK:- Book Seats Api
    func bookSeatsApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.UserIds: self.selectedUsers,
                      ApiParams.EventId: self.selectedEvent.eventId!,
                      ApiParams.CreatedOn: TheGlobalPoolManager.getTodayString(),
                      ApiParams.BookFromBlockedSeats: self.isBookFromBlockedSeats] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.BOOK_SEATS, params: param as [String : AnyObject], header: HEADER) { (dataResponse,success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
                if dataResponse.json.exists(){
                    let dict = dataResponse.dictionaryFromJson! as NSDictionary
                    let status = dict.object(forKey: STATUS) as! String
                    let message = dict.object(forKey: MESSAGE) as! String
                    if status == Constants.SUCCESS{
                        TheGlobalPoolManager.showAlertWith(message: message, singleAction: true, callback: { (success) in
                            if success!{
                                self.selectedEvent.seats.available = self.selectedEvent.seats.available - self.selectedUsers.count
                                self.selectedEvent.seats.booked = self.selectedEvent.seats.booked + self.selectedUsers.count
                                self.selectedEvent.seats.blocked = self.selectedEvent.seats.blocked
                                NotificationCenter.default.post(name: Notification.Name("CloseClicked"), object: nil, userInfo: ["SelectedEvent":self.selectedEvent,"BookASeat":true])
                                ez.topMostVC?.dismissVC(completion: nil)
                            }
                        })
                    }else{
                        TheGlobalPoolManager.showAlertWith(message: message, singleAction: true, callback: { (success) in
                            if success!{}
                        })
                    }
                }
            }
        }
    }
}
