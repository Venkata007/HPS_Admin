//
//  SwitchTableViewCell.swift
//  HPS_Admin
//
//  Created by Vamsi on 11/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var slideToOpenView: UIView!
    
    var onlineString:NSAttributedString{
        let attributeString = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("", attr2Text: "Start Game?", attr1Color: #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 1), attr2Color: #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 1), attr1Font: UIDevice.isPhone() ? 14 : 18, attr2Font: UIDevice.isPhone() ? 16 : 20, attr1FontName: .Regular, attr2FontName: .Medium)
        return attributeString
    }
    var offlineString:NSAttributedString{
        let attributeString = TheGlobalPoolManager.attributedTextWithTwoDifferentTextsWithFont("", attr2Text: "Finish Game?", attr1Color: #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 1), attr2Color: #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 1), attr1Font: UIDevice.isPhone() ? 14 : 18, attr2Font: UIDevice.isPhone() ? 16 : 20, attr1FontName: .Regular, attr2FontName: .Medium)
        return attributeString
    }
    lazy var slideToOpen: SlideToOpenView = {
        let slide = SlideToOpenView(frame: CGRect(x: 0, y: 0, width: self.slideToOpenView.frame.size.width, height: self.slideToOpenView.frame.size.height))
        slide.sliderViewTopDistance = 0
        slide.textLabelLeadingDistance = 40
        slide.sliderCornerRadious = self.slideToOpenView.frame.size.height/2.0
        slide.defaultLabelAttributeText = onlineString
        slide.thumnailImageView.image = #imageLiteral(resourceName: "offline_switch").imageWithInsets(insetDimen: 5)
        slide.thumnailImageView.backgroundColor = .clear
        slide.draggedView.backgroundColor = .clear
        slide.draggedView.alpha = 0.8
        slide.delegate = self as SlideToOpenDelegate
        return slide
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ez.runThisInMainThread {
            self.slideToOpenView.addSubview(self.slideToOpen)
            //self.slideToOpenView.layer.cornerRadius = self.slideToOpenView.frame.size.height/2.0
            self.slideToOpenView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35 ,cornerRadius : self.slideToOpenView.frame.size.height/2.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SwitchTableViewCell : SlideToOpenDelegate{
    func SlideToOpenChangeImage(_ slider:SlideToOpenView, switchStatus: Bool){
        if switchStatus {
            slider.defaultLabelAttributeText = offlineString
            slider.thumnailImageView.image = #imageLiteral(resourceName: "online_switch").imageWithInsets(insetDimen: 15)
            slider.textLabelLeadingDistance = 0
        }else{
            slider.defaultLabelAttributeText = onlineString
            slider.thumnailImageView.image = #imageLiteral(resourceName: "offline_switch").imageWithInsets(insetDimen: 5)
            slider.textLabelLeadingDistance = 40
        }
    }
    func SlideToOpenDelegateDidFinish(_ slider:SlideToOpenView, switchStatus: Bool) {
        var titleText : String = ""
        if switchStatus {
            titleText = titleText + "Start Game?"
            TheGlobalPoolManager.showAlertWith(title: "\(titleText)", message: "", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                    self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                }else{
                    if switchStatus{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                        self.slideToOpen.updateThumbnailViewLeadingPosition(0)
                        self.slideToOpen.isFinished = false
                    }else{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                        self.slideToOpen.updateThumbnailViewLeadingPosition(self.slideToOpen.xEndingPoint)
                        self.slideToOpen.isFinished = true
                    }
                }
            }
        }else{
            titleText = titleText + "Finish Game?"
            TheGlobalPoolManager.showAlertWith(title: "\(titleText)", message: "", singleAction: false, okTitle:"Confirm") { (sucess) in
                if sucess!{
                     self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                }else{
                    if switchStatus{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: false)
                        self.slideToOpen.updateThumbnailViewLeadingPosition(0)
                        self.slideToOpen.isFinished = false
                    }else{
                        self.SlideToOpenChangeImage(self.slideToOpen, switchStatus: true)
                        self.slideToOpen.updateThumbnailViewLeadingPosition(self.slideToOpen.xEndingPoint)
                        self.slideToOpen.isFinished = true
                    }
                }
            }
        }
    }
}

