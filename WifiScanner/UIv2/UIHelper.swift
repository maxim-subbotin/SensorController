//
//  UIHelper.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public static func customFont(bySize s: CGFloat) -> UIFont {
        if let font = UIFont(name: "MyriadPro-Cond", size: s) {
            return font
        }
        return UIFont.systemFont(ofSize: s)
    }
}
