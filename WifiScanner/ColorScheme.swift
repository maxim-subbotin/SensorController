//
//  ColorScheme.swift
//  WifiScanner
//
//  1/13/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    public var navigationBarColor = UIColor(hexString: "#191919")
    public var navigationTextColor = UIColor.white
    public var backgroundColor = UIColor(hexString: "#111523")
    
    public var spotCellBackgroundColor = UIColor(hexString: "#1B1E2E")
    public var spotCellTitleColor = UIColor.white
    public var spotCellDetailColor = UIColor(hexString: "#868A9E")
    public var spotCellIndicatorDisableColor = UIColor(hexString: "#868A9E")
    public var spotCellIndicatorEnableColor = UIColor(hexString: "#5FC688")
    public var spotCellIndicatorAnimationColor = UIColor(hexString: "#E4DFDA")
    
    public var spotParameterBackgroundColor = UIColor(hexString: "#1B1E2E")
    public var spotParameterTitleColor = UIColor(hexString: "#838A9E")
    public var spotParameterValueColor = UIColor.white
    
    public static var current = ColorScheme()
}
