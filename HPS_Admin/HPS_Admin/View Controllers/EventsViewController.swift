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
        self.addEventBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : addEventBtn.h / 2)
        tableView.tableFooterView = UIView()
        self.getAllEventsApiHitting()
    }
    //MARK:- Get All Events Api Hitting
    func getAllEventsApiHitting(){
        TheGlobalPoolManager.showProgress(self.view, title:ToastMessages.Please_Wait)
        APIServices.getUrlSession(urlString: ApiURls.GET_ALL_EVENTS, params: [:], header: HEADER) { (dataResponse) in
            TheGlobalPoolManager.hideProgess(self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                ModelClassManager.eventsListModel  = EventsListModel(fromJson: JSON(dict))
                if ModelClassManager.eventsListModel.success{
                    self.tableView.reloadData()
                }
            }else{
                TheGlobalPoolManager.showToastView("No data available")
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.EventTableViewCell) as! EventTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewCon = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.BookingHistoryVC) as? BookingHistoryVC{
            viewCon.hidesBottomBarWhenPushed = true
            ez.topMostVC?.presentVC(viewCon)
        }
    }
}
