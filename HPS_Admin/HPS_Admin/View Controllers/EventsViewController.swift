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
        self.updateUI()
        tableView.register(UINib(nibName: XIBNames.EventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK:- Update UI
    func updateUI(){
        self.addEventBtn.setImage(#imageLiteral(resourceName: "Add").withColor(#colorLiteral(red: 0.9199201465, green: 0.9765976071, blue: 0.9851337075, alpha: 1)), for: .normal)
        self.addEventBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : addEventBtn.h / 2)
        tableView.tableFooterView = UIView()
        ModelClassManager.getAllEventsApiHitting(self) { (success, response) -> (Void) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    @objc func switchChanged(_ sender : UISwitch){
        let data = ModelClassManager.eventsListModel.events[sender.tag]
        if data.bookingStatus == OPEN{
            ModelClassManager.changeEventStatuslApiHitting(data.eventId!, bookingStatus: CLOSED, viewCon: self) { (success, response) -> (Void) in
                if success{
                    ModelClassManager.getAllEventsApiHitting(self) { (success, response) -> (Void) in
                        if success{
                            self.tableView.reloadData()
                        }
                    }
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
            cell.switch.tag = indexPath.row
            cell.switch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.bookBtn.tag = indexPath.row
            cell.bookBtn.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            cell.balanceLbl.isHidden = true
            cell.bookBtn.isHidden = false
            cell.statusImgView.image = #imageLiteral(resourceName: "created")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startsAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.available!)/\(data.seats.total!) Seats\n", attr2Text: "Available", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.booked!)/\(data.seats.total!) Seats\n", attr2Text: "Booked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.blocked!)/\(data.seats.total!) Seats\n", attr2Text: "Blocked", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case "running":
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "₹ \(data.audit.totalUsersBalance!.toString)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.balanceLbl.isHidden = false
            cell.bookBtn.isHidden = true
            cell.statusImgView.image = #imageLiteral(resourceName: "running")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.playing!)/\(data.seats.booked!)\n", attr2Text: "Players", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.audit.totalBuyIns!)\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.audit.totalcashout!)\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
        case "finished":
            cell.bookStsLbl.isHidden = true
            cell.switch.isHidden = true
            cell.balanceLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("Balance \n", attr2Text: "\(data.audit.totalUsersBalance!.toString)", attr1Color: .white, attr2Color: .white, attr1Font: 12, attr2Font: 14, attr1FontName: .Medium, attr2FontName: .Bold)
            cell.balanceLbl.isHidden = false
            cell.bookBtn.isHidden = true
            cell.statusImgView.image = #imageLiteral(resourceName: "finish")
            cell.timeLbl.text = TheGlobalPoolManager.getFormattedDate(string: data.startedAt!)
            cell.lbl1.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.seats.played!)/\(data.seats.booked!)\n", attr2Text: "Played", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.9058823529, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl2.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.audit.totalBuyIns!)\n", attr2Text: "Buy In's", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.2784313725, green: 0.7490196078, blue: 0.4705882353, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
            cell.lbl3.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.audit.totalcashout!)\n", attr2Text: "Cash Out", attr1Color: #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), attr2Color: #colorLiteral(red: 0.7725490196, green: 0.3607843137, blue: 0.3607843137, alpha: 1), attr1Font:10 , attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Bold)
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
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
