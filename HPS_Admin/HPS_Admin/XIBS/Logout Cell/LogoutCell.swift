//
//  LogoutCell.swift
//  HPS_Admin
//
//  Created by Vamsi on 22/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {

    @IBOutlet weak var logoutBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
          self.logoutBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
