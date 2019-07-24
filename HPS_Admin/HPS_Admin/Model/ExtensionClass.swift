//
//  ExtensionClass.swift
//  UrbanEats
//
//  Created by Venkat@Hexadots on 06/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

/**
 * This class was written according to the app recuriment, these are the extension of an existing Types.
 */

import Foundation
import UIKit
import ImageIO
import EZSwiftExtensions

let APP_FONT = "Lato"
enum AppFonts {
    case Bold, Medium, Regular, Black, BlackItalic, BoldItalic, ExtraBold, ExtraBoldItalic, ExtraLight, Italic, Light, LightItalic, MediumItalic, SemiBold, SemiBoldItalic, Thin, ThinItalic
    var fonts:String{
        switch self {
        case .Bold:
            return "\(APP_FONT)-Bold"
        case .Medium:
            return "\(APP_FONT)-Medium"
        case .Regular:
            return "\(APP_FONT)-Regular"
        case .Black:
            return "\(APP_FONT)-Black"
        case .BlackItalic:
            return "\(APP_FONT)-BlackItalic"
        case .BoldItalic:
            return "\(APP_FONT)-BoldItalic"
        case .ExtraBold:
            return "\(APP_FONT)-ExtraBold"
        case .ExtraBoldItalic:
            return "\(APP_FONT)-ExtraBoldItalic"
        case .ExtraLight:
            return "\(APP_FONT)-ExtraLight"
        case .Italic:
            return "\(APP_FONT)-Italic"
        case .Light:
            return "\(APP_FONT)-Light"
        case .LightItalic:
            return "\(APP_FONT)-LightItalic"
        case .MediumItalic:
            return "\(APP_FONT)-MediumItalic"
        case .SemiBold:
            return "\(APP_FONT)-SemiBold"
        case .SemiBoldItalic:
            return "\(APP_FONT)-SemiBoldItalic"
        case .Thin:
            return "\(APP_FONT)-Thin"
        case .ThinItalic:
            return "\(APP_FONT)-ThinItalic"
        }
    }
}
//MARK:- UITeaxt Field
extension UITextField{
    func placeholderColor(_ placeholder:String, color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func leftViewImage(_ image:UIImage){
        self.leftViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.leftView = view
    }
    
    func rightViewImage(_ image:UIImage){
        self.rightViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.rightView = view
    }
}
//MARK:- Date
extension Date {
    var convertedDate:Date {
        let dateFormatter = DateFormatter();
        let dateFormat = "dd-MM-yyyy HH:mm";
        dateFormatter.dateFormat = dateFormat;
        let formattedDate = dateFormatter.string(from: self);
        dateFormatter.locale = NSLocale.current;
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00");
        dateFormatter.dateFormat = dateFormat as String;
        let sourceDate = dateFormatter.date(from: formattedDate as String);
        return sourceDate!;
    }
    func adding(hours: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let convertedDate: String = dateFormatter.string(from: Calendar.current.date(byAdding: .hour, value: hours, to: self)!)
        return convertedDate
    }
}
//MARK:- UIColor
extension UIColor{
    static var themeColor:UIColor{
        return #colorLiteral(red: 0.04705882353, green: 0.7137254902, blue: 0.8470588235, alpha: 1) //F3C02F
    }
    static var blueColor:UIColor{
        return #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 1) //00BB51
    }
    static var placeholderColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7980789812) //FFFFFF Opacity 80%
    }
    static var textFieldTintColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //FFFFFF
    }
    static var borderColor:UIColor{
        return #colorLiteral(red: 0.4745098039, green: 0.9803921569, blue: 1, alpha: 0.6032748288)
    }
    static var yellowColor:UIColor{
        return #colorLiteral(red: 0.7803921569, green: 0.6235294118, blue: 0, alpha: 1)
    }
}
//MARK:- UIFont
extension UIFont{
    static func appFont(_ font:AppFonts, size:CGFloat = 16.0) -> UIFont{
        return UIFont(name: font.fonts, size: size) ??  UIFont(name: AppFonts.Regular.fonts, size: size)!
    }
}
//MARK:- UIButton
extension UIButton{
    func cornerRadius(_ radius:CGFloat = 5.0){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func shadowWithCornerRadius(_ radius:CGFloat = 5.0){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
    }
}
//MARK:- View Controller
extension UIViewController{
    func disableKeyBoardOnTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func tapped(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
    }
}
//MARK:- Version number and Build Number
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
//MARK:- Captilaize First Letter
extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    func toJSON() -> AnyObject? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
    }
}
//MARK:- Text Field Padding
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.003921568627, green: 0.2549019608, blue: 0.3725490196, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
//MARK:- UIView Animation
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float , cornerRadius : CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
extension UIImage{
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}
extension Double{
    var toFloat:Float{
        return Float(self)
    }
}
extension Float{
    var toString:String{
        return "\(self)"
    }
    var toDouble:Double{
        return Double(self)
    }
    var toInt:Int{
        return Int(self)
    }
    var roundToTwoDigits:Float{
        let value = ((self * 100).rounded() / 100)
        return value
    }
}

//MARK:- UI Devices
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
