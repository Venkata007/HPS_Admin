//
//  BookingHistoryVC.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import PopOverMenu

class BookingHistoryVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
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
    @IBOutlet var popUpImgs: [UIImageView]!
    @IBOutlet weak var blockSeatsView: UIView!
    @IBOutlet var popUpLbls: [UILabel]!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blockSeatsViewHeight: NSLayoutConstraint!
    @IBOutlet var popUpBtns: [UIButton]!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var ribbonImageView: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    var selectedEvent : EventsData!
    let popOverViewController = PopOverViewController.instantiate()
    var menuItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("CloseClicked"), object: nil)
        tableView.register(UINib(nibName: XIBNames.UsersListCell, bundle: nil), forCellReuseIdentifier: XIBNames.UsersListCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        ez.runThisInMainThread {
            self.updateUI()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(EVENT_UPDATED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(EVENT_BOOKING_UPDATED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(EVENT_BOOKING_ADDED), object: nil)
    }
    @objc func reloadData(_ userInfo:Notification){
        if userInfo.name.rawValue == EVENT_UPDATED{
            let eventData = ModelClassManager.eventsListModel.events.filter({ (eventData) -> Bool in
                return eventData.eventId == self.selectedEvent.eventId
            })
            
            if eventData.count == 1{
                self.selectedEvent = eventData[0]
                self.updateCreatedEventStatus(data: self.selectedEvent)
                if self.selectedEvent.bookingStatus == OPEN{
                    self.switch.setOn(true, animated: false)
                }else{
                    self.switch.setOn(false, animated: false)
                }
            }
        }else if userInfo.name.rawValue == EVENT_BOOKING_UPDATED{
            if let data = userInfo.userInfo as? [String:AnyObject]{
                if let indexRow = data["IndexPath"] as? Int{
                    let indexPath = IndexPath(row: indexRow, section: 0)
                    if let visibleCells = self.tableView.indexPathsForVisibleRows{
                        if visibleCells.contains(indexPath){
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }else if userInfo.name.rawValue == EVENT_BOOKING_ADDED{
            self.tableView.reloadData()
        }
        
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        if let userInfo = notification.userInfo{
            if let event = userInfo["SelectedEvent"] as? EventsData{
                self.selectedEvent = event
                self.updateCreatedEventStatus(data: event)
                if  let _ = userInfo["BookASeat"]{
                    self.getAllBookedUsers(event)
                }
            }
        }
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideTopTop)
    }
    
    //MARK:- Update Created Event
    func updateCreatedEventStatus(data:EventsData){
        self.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
        self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
    }
    
    func isBookingButtonHigh(_ isHigh:Bool){
        self.ribbonImageView.isHidden = isHigh
        self.balanceLbl.isHidden = isHigh
        self.bookBtn.isHidden = !isHigh
    }
    
    //MARK:- Update UI
    func updateUI(){
        self.popUpView.isHidden = true
        self.editBtn.isHidden = true
        for lbl in popUpLbls{
            TheGlobalPoolManager.cornerAndBorder(lbl, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        }
        for imgView in popUpImgs{
            TheGlobalPoolManager.cornerAndBorder(imgView, cornerRadius: imgView.h / 2, borderWidth: 0, borderColor: .clear)
           imgView.image = imgView.image?.imageWithInset(insets: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
        }
        TheGlobalPoolManager.cornerAndBorder(self.bookBtn, cornerRadius: 20, borderWidth: 0, borderColor: .clear)
        self.editBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : editBtn.h / 2)
        TheGlobalPoolManager.cornerAndBorder(statusBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        ez.runThisInMainThread {
            TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 0, borderWidth: 2, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.bottomLeft,.bottomRight], size: CGSize.init(width: 5, height: 0))
            TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.headerView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        }
        if let data  = selectedEvent{
            self.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
            self.coinsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
            if data.seats.available! > 0 {
                self.menuItems = ["Book","Unblock Seats","Block Seats","Delete"]
                self.blockSeatsViewHeight.constant = 40
                self.blockSeatsView.isHidden = false
            }else{
                 self.menuItems = ["Book","Unblock Seats","Delete"]
                self.blockSeatsViewHeight.constant = 0
                self.blockSeatsView.isHidden = true
            }
            switch data.eventStatus! {
            case EVENT_CREATED:
                self.statusBtn.setTitle("Start Game?", for: .normal)
                if data.bookingStatus == "open"{
                    self.switch.isOn = true
                }else{
                    self.switch.isOn = false
                }
                self.switch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                self.isBookingButtonHigh(true)
                self.statusImgView.image = #imageLiteral(resourceName: "created")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
                self.updateCreatedEventStatus(data: data)
            case EVENT_RUNNING:
                self.statusBtn.setTitle("End Game?", for: .normal)
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
                self.statusImgView.image = #imageLiteral(resourceName: "running")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case EVENT_FINISHED:
                self.statusBtn.setTitle("Close Game?", for: .normal)
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
                self.statusImgView.image = #imageLiteral(resourceName: "finish")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            case EVENT_CLOSED:
                self.statusBtn.isHidden = true
                self.bookStsLbl.isHidden = true
                self.switch.isHidden = true
                self.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
                self.isBookingButtonHigh(false)
                self.statusImgView.image = #imageLiteral(resourceName: "closed")
                self.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
                self.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
                self.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            default:
                break
            }
            self.getAllBookedUsers(data)
        }
    }
    func getAllBookedUsers(_ data:EventsData){
        ModelClassManager.getAllBookingsApiHitting(self, progress: true, eventID: data.eventId!) { (success, response) -> (Void) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    @objc func switchChanged(_ sender : UISwitch){
        print(sender.isOn)
        if !sender.isOn{
            TheGlobalPoolManager.showAlertWith(title: "Warning", message: "No user can book seats for this event until reopen. \nNote: Admins can still add users for this event.", singleAction: false, okTitle: "Yes", cancelTitle: "Cancel") { (success) in
                if success!{
                    self.updateBookingStatus(sender.tag)
                }else{
                    sender.setOn(true, animated: false)
                }
            }
        }else{
            self.updateBookingStatus(sender.tag)
        }
    }
    func updateBookingStatus(_ senderTag:Int){
        if let data = self.selectedEvent{
            if data.bookingStatus == OPEN{
                ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: CLOSED, viewCon: self) { (success, response) -> (Void) in
                    if success{
                        self.selectedEvent.bookingStatus = CLOSED
                        //self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        /*
                         ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                         if success{
                         self.tableView.reloadData()
                         }
                         }
                         */
                    }
                }
            }else{
                ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: OPEN, viewCon: self) { (success, response) -> (Void) in
                    if success{
                        self.selectedEvent.bookingStatus = OPEN
                        //self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        /*
                         ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                         if success{
                         self.tableView.reloadData()
                         }
                         }
                         */
                    }
                }
            }
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func menuBtn(_ sender: UIButton) {
        //POP MENU
        self.popOverViewController.set(titles: self.menuItems)
        self.popOverViewController.set(separatorStyle: .singleLine)
        self.popOverViewController.popoverPresentationController?.sourceView = sender
        self.popOverViewController.popoverPresentationController?.sourceRect = sender.bounds
        self.popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.popOverViewController.preferredContentSize = CGSize(width: 140, height: self.menuItems.count * 45)
        self.popOverViewController.presentationController?.delegate = self
        ez.runThisInMainThread {
            self.popOverViewController.completionHandler = { selectRow in
                if let data = self.selectedEvent{
                    if data.seats.available! > 0{
                        if selectRow == 0{
                            if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookASeatViewController) as? BookASeatViewController{
                                viewCon.hidesBottomBarWhenPushed = true
                                viewCon.selectedEvent = self.selectedEvent
                                ez.topMostVC?.presentVC(viewCon)
                            }
                        }else if selectRow == 1{
                            self.blockUnblockPopUpView(false)
                        }else if selectRow == 2{
                            self.blockUnblockPopUpView(true)
                        }else{
                            TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Do you want to delete this event?", singleAction: false, okTitle: "Yes", cancelTitle: "Cancel") { (success) in
                                if success!{
                                    ModelClassManager.deleteEventApiHitting(self.selectedEvent.eventId, progress: true, viewCon: self, completionHandler: { (success, dict) -> (Void) in
                                        if success{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }
                            }
                        }
                    }else{
                        if selectRow == 0{
                            if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookASeatViewController) as? BookASeatViewController{
                                viewCon.hidesBottomBarWhenPushed = true
                                viewCon.selectedEvent = self.selectedEvent
                                ez.topMostVC?.presentVC(viewCon)
                            }
                        }else if selectRow == 1{
                            self.blockUnblockPopUpView(false)
                        }else{
                            TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Do you want to delete this event?", singleAction: false, okTitle: "Yes", cancelTitle: "Cancel") { (success) in
                                if success!{
                                    ModelClassManager.deleteEventApiHitting(self.selectedEvent.eventId, progress: true, viewCon: self, completionHandler: { (success, dict) -> (Void) in
                                        if success{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        self.present(self.popOverViewController, animated: true, completion: nil)
    }
    @IBAction func bookBtn(_ sender: UIButton) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookASeatViewController) as? BookASeatViewController{
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.selectedEvent = self.selectedEvent
            ez.topMostVC?.presentVC(viewCon)
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func editBtn(_ sender: UIButton) {
        if sender.tag == 0{
            sender.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            self.popUpView.isHidden = false
            sender.tag = 1
        }else{
            sender.setImage(#imageLiteral(resourceName: "Pencil"), for: .normal)
            self.popUpView.isHidden = true
            sender.tag = 0
        }
    }
    @IBAction func popUpBtns(_ sender: UIButton) {
        for btn in popUpBtns{
            if btn == sender{
                if btn.tag == 0{
                    self.popUpView.isHidden = true
                    self.editBtn.tag = 0
                    self.editBtn.setImage(#imageLiteral(resourceName: "Pencil"), for: .normal)
                    if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookASeatViewController) as? BookASeatViewController{
                        viewCon.hidesBottomBarWhenPushed = true
                        viewCon.selectedEvent = self.selectedEvent
                        ez.topMostVC?.presentVC(viewCon)
                    }
                }else if btn.tag == 1{
                    self.popUpView.isHidden = true
                    self.blockUnblockPopUpView(false)
                    self.editBtn.tag = 0
                    self.editBtn.setImage(#imageLiteral(resourceName: "Pencil"), for: .normal)
                }else{
                    self.popUpView.isHidden = true
                    self.blockUnblockPopUpView(true)
                    self.editBtn.tag = 0
                    self.editBtn.setImage(#imageLiteral(resourceName: "Pencil"), for: .normal)
                }
            }
        }
    }
    @IBAction func statusBtn(_ sender: UIButton) {
        if let data  = selectedEvent{
            switch data.eventStatus! {
            case "created":
                TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Are you sure\n You want to Start Game?", singleAction: false, okTitle: "Start", cancelTitle: "Cancel") { (success) in
                    if success!{
                        self.startEventApiHitting()
                    }
                }
            case "running":
                TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Are you sure\n You want to End Game?", singleAction: false, okTitle: "End", cancelTitle: "Cancel") { (success) in
                    if success!{
                        self.endEventApiHitting()
                    }
                }
            case "finished":
                if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.CloseEventViewController) as? CloseEventViewController{
                    viewCon.hidesBottomBarWhenPushed = true
                    viewCon.selectedEvent = self.selectedEvent
                    ez.topMostVC?.presentVC(viewCon)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func deleteEvent(_ sender: UIButton) {
        TheGlobalPoolManager.showAlertWith(title: "Alert", message: "Do you want to delete this event?", singleAction: false, okTitle: "Yes", cancelTitle: "Cancel") { (success) in
            if success!{
                ModelClassManager.deleteEventApiHitting(self.selectedEvent.eventId, progress: true, viewCon: self, completionHandler: { (success, dict) -> (Void) in
                    if success{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
extension BookingHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.getAllBookingsModel == nil ? 0 : ModelClassManager.getAllBookingsModel.bookings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.UsersListCell) as! UsersListCell
        let data = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
        cell.rewardPointsLbl.text = "\(data.userEventRewardPoints!.toString)\n points"
        cell.bookingIDLbl.text = data.bookingId!
        cell.userNameLbl.text = data.userName!
        cell.statusImgView.image = TheGlobalPoolManager.getUserStatusImageBasedOnStatus(data.status)
        if data.status == "confirmed"{
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinsAt!)
        }else{
            cell.dateLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.userJoinedAt!)
        }
        cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹   \(TheGlobalPoolManager.formatNumber(data.balance!))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
        if ((data.status == "playing") || (data.status == "completed")){
            cell.buyInsLbl.isHidden = false
            cell.buyInsLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Buy In's & Cash Out\n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.totalBuyIns!))/\(TheGlobalPoolManager.formatNumber(data.cashout!))", attr1Color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), attr2Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
        }else{
            cell.buyInsLbl.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.GetBuyInsViewController) as? GetBuyInsViewController{
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.selectedEvent = self.selectedEvent
            viewCon.selectedUser = ModelClassManager.getAllBookingsModel.bookings[indexPath.row]
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
extension BookingHistoryVC{
    //MARK: -  BlockUnblock Pop Up View
    func blockUnblockPopUpView(_ value : Bool){
        let viewCon = BlockUnblockPopUp(nibName: "BlockUnblockPopUp", bundle: nil)
        viewCon.isBlockBtnClicked = value
        viewCon.selectedEvent = self.selectedEvent
        self.presentPopupViewController(viewCon, animationType: MJPopupViewAnimationFade)
    }
}
extension BookingHistoryVC{
    //MARK:- Start Event Api
    func startEventApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: self.selectedEvent.eventId!,
                      ApiParams.StartedOn:  TheGlobalPoolManager.getTodayString(),
                      ApiParams.StartedById: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.StartedByName: ModelClassManager.adminLoginModel.data.name!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.START_EVENT, params: param as [String : AnyObject], header: HEADER) { (dataResponse, success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
                if dataResponse.json.exists(){
                    let dict = dataResponse.dictionaryFromJson! as NSDictionary
                    let status = dict.object(forKey: STATUS) as! String
                    let message = dict.object(forKey: MESSAGE) as! String
                    if status == Constants.SUCCESS{
                        TheGlobalPoolManager.showToastView(message)
                        ez.topMostVC?.dismissVC(completion: nil)
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                    }
                }
            }
        }
    }
    //MARK:- End Event Api
    func endEventApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        let param = [ ApiParams.EventId: self.selectedEvent.eventId!,
                      ApiParams.EndedOn:  TheGlobalPoolManager.getTodayString(),
                      ApiParams.EndedById: ModelClassManager.adminLoginModel.data.id!,
                      ApiParams.EndedByName: ModelClassManager.adminLoginModel.data.name!] as [String : Any]
        APIServices.patchUrlSession(urlString: ApiURls.END_EVENT, params: param as [String : AnyObject], header: HEADER) { (dataResponse, success) in
            TheGlobalPoolManager.hideProgess(self.view)
            if success{
                if dataResponse.json.exists(){
                    let dict = dataResponse.dictionaryFromJson! as NSDictionary
                    let status = dict.object(forKey: STATUS) as! String
                    let message = dict.object(forKey: MESSAGE) as! String
                    if status == Constants.SUCCESS{
                        TheGlobalPoolManager.showToastView(message)
                        ez.topMostVC?.dismissVC(completion: nil)
                    }else{
                        TheGlobalPoolManager.showToastView(message)
                    }
                }
            }
        }
    }
}
extension BookingHistoryVC : UIAdaptivePresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
