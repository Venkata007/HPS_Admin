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

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEventBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.EventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        ModelClassManager.adminProfileApiHitting(self, progress: false) { (success, response) -> (Void) in
            if success{}
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
        ModelClassManager.getAllEventsApiHitting(self, progress: true) { (success, response) -> (Void) in
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
        let data = ModelClassManager.eventsListModel.events[senderTag]
        if data.bookingStatus == OPEN{
            ModelClassManager.changeEventStatuslApiHitting(data.eventId!, progress: true, bookingStatus: CLOSED, viewCon: self) { (success, response) -> (Void) in
                if success{
                    ModelClassManager.eventsListModel.events[senderTag].bookingStatus = CLOSED
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
                    ModelClassManager.eventsListModel.events[senderTag].bookingStatus = OPEN
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
    @IBAction func addEventBtn(_ sender: UIButton) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.AddEventViewController) as? AddEventViewController{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
extension EventsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.eventsListModel == nil ? 0 : ModelClassManager.eventsListModel.events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let data = ModelClassManager.eventsListModel.events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventTableViewCell) as! EventTableViewCell
        cell.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.coinsLbl.text = "\(data.eventRewardPoints!.toString)\n points"
        cell.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
        switch data.eventStatus! {
        case "created":
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
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case "running":
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "running")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case "finished":
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "finish")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case "closed":
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(TheGlobalPoolManager.formatNumber(data.audit.totalUsersBalance))", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.isBookingButtonHigh(false)
            cell.statusImgView.image = #imageLiteral(resourceName: "closed")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalBuyIns))\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("₹ \(TheGlobalPoolManager.formatNumber(data.audit.totalCashout))\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:14 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
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
            viewCon.selectedEvent = ModelClassManager.eventsListModel.events[indexPath.row]
            ModelClassManager.getAllBookingsModel = nil
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
