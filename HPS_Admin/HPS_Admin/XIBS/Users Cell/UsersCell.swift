//
//  UsersCell.swift
//  HPS_Admin
//
//  Created by Vamsi on 08/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var referalSendBtn: UIButton!
    @IBOutlet weak var referalCodeTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius: 5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
        self.referalSendBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : self.referalSendBtn.h / 2)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
