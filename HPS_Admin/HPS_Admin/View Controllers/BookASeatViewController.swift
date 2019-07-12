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
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var bookedLbl: UILabel!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectSlotTimeLbl: UILabel!
    @IBOutlet weak var selectSlotBtn: UIButton!
    @IBOutlet weak var bookSeatsBtn: UIButton!
    @IBOutlet weak var selectSlotView: UIView!
    
     var selectedUsers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: XIBNames.BookSeatTableViewCell, bundle: nil), forCellReuseIdentifier: XIBNames.BookSeatTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.viewInView, corners: [.topLeft,.topRight], size: CGSize.init(width: 5, height: 0))
        TheGlobalPoolManager.cornerAndBorder(self.availableLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.bookedLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
        TheGlobalPoolManager.cornerAndBorder(self.completedLbl, cornerRadius: self.availableLbl.h / 2, borderWidth: 0, borderColor: .clear)
        self.selectSlotView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        self.bookSeatsBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }
    //MARK:- IB Action Outlets
    @IBAction func selectSlotTime(_ sender: UIButton) {
    }
    @IBAction func backBtn(_ sender: UIButton) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    @IBAction func bookSeatsBtn(_ sender: UIButton) {
    }
}
extension BookASeatViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: XIBNames.BookSeatTableViewCell) as! BookSeatTableViewCell
        let selectedValue = selectedUsers.contains(indexPath.row)
        if selectedValue{
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
        let selectedValue = selectedUsers.contains(indexPath.row)
        if !selectedValue {
            selectedUsers.append(indexPath.row)
        }else{
            let indx = selectedUsers.index(of: indexPath.row)
            selectedUsers.remove(at: indx!)
        }
        tableView.reloadData()
        print(selectedUsers)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedValue = selectedUsers.contains(indexPath.row)
        if selectedValue {
            let indx = selectedUsers.index(of: indexPath.row)
            selectedUsers.remove(at: indx!)
        }
        tableView.reloadData()
        print(selectedUsers)
    }
}
