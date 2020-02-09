//
//  UITextFieldExt.swift
//  WifiScanner
//
//  Created by Snappii on 2/9/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldExt: UITextField {
    public var padding = UIEdgeInsets.zero
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: padding.left, y: padding.top, width: bounds.width - padding.left - padding.right, height: bounds.height - padding.top - padding.bottom)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: padding.left, y: padding.top, width: bounds.width - padding.left - padding.right, height: bounds.height - padding.top - padding.bottom)
    }
}
