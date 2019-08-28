//
//  EventsViewController.swift
//  HPS_Admin
//
//  Created by Vamsi on 08/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SwiftyJSON
import PopOverMenu
class EventsViewController: UIViewController {

    @IBOutlet weak var noEventsStsLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var switchChanged = false
    let popOverViewController = PopOverViewController.instantiate()
    var menuItems = ["Add Event","Events History"]
    var tableViewData = [EventsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.EventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        let font: [AnyHashable : Any] = [NSAttributedStringKey.font : UIFont.appFont(.Medium, size: 16)]
        self.segmentControl.setTitleTextAttributes(font, for: .normal)
        tableView.tableFooterView = UIView()
        self.noEventsStsLbl.isHidden = true
        ModelClassManager.adminProfileApiHitting(self, progress: false) { (success, response) -> (Void) in
            if success{}
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(EVENT_UPDATED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)) , name: NSNotification.Name(EVENT_ADDED), object: nil)
    }
    @objc func reloadData(_ userInfo:Notification){
        if userInfo.name.rawValue == EVENT_UPDATED{
            if let data = userInfo.userInfo as? [String:AnyObject]{
                if let indexRow = data["IndexPath"] as? Int{
                    let indexPath = IndexPath(row: indexRow, section: 0)
                    if !switchChanged{
                        if let visibleCells = self.tableView.indexPathsForVisibleRows{
                            if visibleCells.contains(indexPath){
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        }else if userInfo.name.rawValue == EVENT_ADDED{
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        switchChanged = false
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        ModelClassManager.getAllEventsApiHitting(self, progress: true) { (success, response) -> (Void) in
            if self.segmentControl.selectedSegmentIndex == 0{
                self.tableViewData = ModelClassManager.eventsListModel.createdEvents
                if self.tableViewData.count == 0{
                    self.noEventsStsLbl.isHidden = false
                    self.tableView.isHidden = true
                    self.noEventsStsLbl.text = "No New Events"
                }else{
                    self.noEventsStsLbl.isHidden = true
                    self.tableView.isHidden = false
                }
            }else  if self.segmentControl.selectedSegmentIndex == 1{
                self.tableViewData = ModelClassManager.eventsListModel.runningEvents
                if self.tableViewData.count == 0{
                    self.noEventsStsLbl.isHidden = false
                    self.noEventsStsLbl.text = "No Running Events"
                }else{
                    self.noEventsStsLbl.isHidden = true
                    self.tableView.isHidden = false
                }
            }else  if self.segmentControl.selectedSegmentIndex == 2{
                self.tableViewData = ModelClassManager.eventsListModel.finishedEvents
                if self.tableViewData.count == 0{
                    self.noEventsStsLbl.isHidden = false
                    self.noEventsStsLbl.text = "No Finished Events"
                }else{
                    self.noEventsStsLbl.isHidden = true
                    self.tableView.isHidden = false
                }
            }
            self.tableView.reloadData()
        }
    }
    @objc func switchChanged(_ sender : UISwitch){
        print(sender.isOn)
        if !sender.isOn{
            TheGlobalPoolManager.showAlertWith(title: "Warning", message: "No user can book seats for this event until reopen. \nNote: Admins can still add users for this event.", singleAction: false, okTitle: "Yes", cancelTitle: "Cancel") { (success) in
                if success!{
                    self.updateBookingStatus(sender.tag)
                }else{
                    self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }
            }
        }else{
            self.updateBookingStatus(sender.tag)
        }
    }
    func updateBookingStatus(_ senderTag:Int){
        let data = self.tableViewData[senderTag]
        if data.bookingStatus == OPEN{
            ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: CLOSED, viewCon: self) { (success, response) -> (Void) in
                if success{
                    ModelClassManager.eventsListModel.createdEvents[senderTag].bookingStatus = CLOSED
                    self.tableViewData[senderTag].bookingStatus = CLOSED
                    self.tableView.reloadRows(at: [IndexPath(row: senderTag, section: 0)], with: .none)
                    /*
                     ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                     self.tableView.reloadData()
                     }
                     */
                }
            }
        }else{
            ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: OPEN, viewCon: self) { (success, response) -> (Void) in
                if success{
                    ModelClassManager.eventsListModel.createdEvents[senderTag].bookingStatus = OPEN
                    self.tableViewData[senderTag].bookingStatus = OPEN
                    self.tableView.reloadRows(at: [IndexPath(row: senderTag, section: 0)], with: .none)
                    /*
                     ModelClassManager.getAllEventsApiHitting(self, progress: false) { (success, response) -> (Void) in
                     self.tableView.reloadData()
                     }
                     */
                }
            }
        }
    }
    @objc func buttonTapped(_ sender : UIButton){
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookASeatViewController) as? BookASeatViewController{
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.selectedEvent = ModelClassManager.eventsListModel.events[sender.tag]
            ez.topMostVC?.presentVC(viewCon)
        }
    }
    //MARK:- IB Action Outlets
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.tableViewData = ModelClassManager.eventsListModel.createdEvents
            if self.tableViewData.count == 0{
                self.noEventsStsLbl.isHidden = false
                self.tableView.isHidden = true
                self.noEventsStsLbl.text = "No New Events"
            }else{
                self.noEventsStsLbl.isHidden = true
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        case 1:
            self.tableViewData = ModelClassManager.eventsListModel.runningEvents
            if self.tableViewData.count == 0{
                self.noEventsStsLbl.isHidden = false
                self.noEventsStsLbl.text = "No Running Events"
            }else{
                self.noEventsStsLbl.isHidden = true
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        case 2:
            self.tableViewData = ModelClassManager.eventsListModel.finishedEvents
            if self.tableViewData.count == 0{
                self.noEventsStsLbl.isHidden = false
                self.noEventsStsLbl.text = "No Finished Events"
            }else{
                self.noEventsStsLbl.isHidden = true
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        default:
            break
        }
    }
    @IBAction func addEventBtn(_ sender: UIButton) {
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
                if selectRow == 0{
                    if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.AddEventViewController) as? AddEventViewController{
                        viewCon.hidesBottomBarWhenPushed = true
                        ez.topMostVC?.presentVC(viewCon)
                    }
                }else if selectRow == 1{
                    if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.CompletedEventsViewController) as? CompletedEventsViewController{
                        viewCon.hidesBottomBarWhenPushed = true
                        ez.topMostVC?.presentVC(viewCon)
                    }
                }
            }
        }
        self.present(self.popOverViewController, animated: true, completion: nil)
    }
}
extension EventsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.eventsListModel == nil ? 0 : self.tableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let data = self.tableViewData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventTableViewCell) as! EventTableViewCell
        cell.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.coinsLbl.text = " \(data.eventRewardPoints!.toString)"
        cell.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
        switch data.eventStatus! {
        case EVENT_CREATED:
            if data.bookingStatus == "open"{
                cell.switch.isOn = true
            }else{
                cell.switch.isOn = false
            }
            cell.bookStsLbl.isHidden = false
            cell.switch.isHidden = false
            cell.switch.tag = indexPath.row
            cell.switch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.bookBtn.tag = indexPath.row
            cell.bookBtn.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            cell.isBookingButtonHigh(true)
            cell.statusImgView.image = #imageLiteral(resourceName: "created")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case EVENT_RUNNING:
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "running")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case EVENT_FINISHED:
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "finish")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case EVENT_CLOSED:
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "closed")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookingHistoryVC) as? BookingHistoryVC{
            viewCon.hidesBottomBarWhenPushed = true
            viewCon.selectedEvent = self.tableViewData[indexPath.row]
            ModelClassManager.getAllBookingsModel = nil
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
extension EventsViewController : UIAdaptivePresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
