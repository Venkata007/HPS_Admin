//
//  TAdminCell.swift
//  HPS_Admin
//
//  Created by Vamsi on 10/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class TAdminCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailIDLbl: UILabel!
    @IBOutlet weak var mobileNumLbl: UILabel!
    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 5, borderWidth: 1, borderColor: .borderColor)
        TheGlobalPoolManager.cornerAndBorder(self.profileImgView, cornerRadius: 10, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
