//
//  CompletedEventsViewController.swift
//  HPS_Admin
//
//  Created by Hexadots on 06/08/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CompletedEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.EventTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.EventTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        self.updateUI()
    }
    
    //MARK:- Update UI
    func updateUI(){
        tableView.tableFooterView = UIView()
        ModelClassManager.getAllCompletedEventsApiHitting(self, progress: true) { (success, response) -> (Void) in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backBtnAction(_ sender:UIButton){
        self.dismissVC(completion: nil)
    }

}

extension CompletedEventsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ModelClassManager.completedEventsListModel == nil ? 0 : ModelClassManager.completedEventsListModel.events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let data = ModelClassManager.completedEventsListModel.events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventTableViewCell) as! EventTableViewCell
        cell.eventNameLbl.attributedText = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("\(data.name!)\n", attr2Text: data.eventId!, attr1Color: #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1), attr2Color: .white, attr1Font: 16, attr2Font: 10, attr1FontName: .Bold, attr2FontName: .Medium)
        cell.coinsLbl.text = " \(data.eventRewardPoints!.toString)"
        cell.noOFUsersLbl.text = "\(data.seats.booked!.toString) users"
        switch data.eventStatus! {
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
            viewCon.selectedEvent = ModelClassManager.completedEventsListModel.events[indexPath.row]
            ModelClassManager.getAllBookingsModel = nil
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
