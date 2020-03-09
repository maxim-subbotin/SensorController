//
//  Extension.swift
//  Infograph
//
//  4/16/19.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}

public extension NSLayoutConstraint {
    static func fill(parentView:UIView, byView childView:UIView) {
        self.fill(parentView: parentView, byView: childView, offset: 0)
    }
    
    static func fill(parentView:UIView, byView childView:UIView, offset:CGFloat) {
        childView.frame = .zero
        childView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: offset)
        let leftConstraint = NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: offset)
        let widthConstraint = NSLayoutConstraint(item: childView, attribute: .width, relatedBy: .equal, toItem: parentView, attribute: .width, multiplier: 1, constant: -2 * offset)
        let heightConstraint = NSLayoutConstraint(item: childView, attribute: .height, relatedBy: .equal, toItem: parentView, attribute: .height, multiplier: 1, constant: -2 * offset)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, widthConstraint, heightConstraint])
    }
}

public extension UIColor {
    /*convenience init(dict:[String:Any]) {
     let r = App.getFloat(dict, key: "red")
     let g = App.getFloat(dict, key: "green")
     let b = App.getFloat(dict, key: "blue")
     let a = App.getFloat(dict, key: "alpha")
     self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
     }*/
    
    convenience init(color:UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func darker() -> UIColor? {
        return adjust(-0.05)
    }
    
    func darker(level:CGFloat) -> UIColor? {
        return adjust(level)
    }
    
    func adjust(_ percentage:CGFloat) -> UIColor? {
        var r:CGFloat=0
        var g:CGFloat=0
        var b:CGFloat=0
        var a:CGFloat=0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r * (1 + percentage), 1.0),
                           green: min(g * (1 + percentage), 1.0),
                           blue: min(b * (1 + percentage), 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
    
    static func randomFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   UIColor.randomFloat(),
                       green: UIColor.randomFloat(),
                       blue:  UIColor.randomFloat(),
                       alpha: 1.0)
    }
    
    var hex: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIDevice {
    public var isiPad:Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension Int {
    var twoBytes : [UInt8] {
        let unsignedSelf = UInt16(bitPattern: Int16(self))
        return [UInt8(truncatingIfNeeded: unsignedSelf >> 8),
                UInt8(truncatingIfNeeded: unsignedSelf)]
    }
}

extension Date {
    var dateFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
