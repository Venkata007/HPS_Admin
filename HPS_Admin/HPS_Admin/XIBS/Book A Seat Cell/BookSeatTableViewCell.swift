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
        TheGlobalPoolManager.cornerAndBorder(self.imgView, cornerRadius: 5, borderWidth: 0.5, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
        TheGlobalPoolManager.cornerAndBorder(self.viewInView, cornerRadius: 5, borderWidth: 1, borderColor: #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellSelected(_ isSelectedValue:Bool){
        if isSelectedValue{
            check_unchekImgView.highlightedImage = #imageLiteral(resourceName: "Checkbox_Fill").withColor(.white)
            check_unchekImgView.isHighlighted = true
        }else{
            check_unchekImgView.image = #imageLiteral(resourceName: "Checkbox_Off").withColor(.white)
            check_unchekImgView.isHighlighted = false
        }
    }
}
