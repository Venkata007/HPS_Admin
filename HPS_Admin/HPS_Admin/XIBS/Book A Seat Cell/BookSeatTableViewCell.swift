//
//  BookSeatTableViewCell.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

class BookSeatTableViewCell: UITableViewCell {

    @IBOutlet weak var viewInView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var check_unchekImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewInView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : 5)
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius: 5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.8781132102, green: 0.8862884641, blue: 0.8903418183, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellSelected(_ isSelectedValue:Bool){
        if isSelectedValue{
            check_unchekImgView.isHighlighted = true
        }else{
            check_unchekImgView.isHighlighted = false
        }
    }
}
