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
    public var spotHeaderBackgroundColor = UIColor(hexString: "#1B1E2E")
    public var spotHeaderTextColor = UIColor(hexString: "#84899C")
    
    public var selectorMenuBackgroundColor = UIColor(hexString: "#1B1E2E")
    public var selectorMenuTextColor = UIColor.white
    public var selectorCheckboxBorderColor = UIColor(hexString: "#84899C")
    public var selectorCheckboxBackgroundColor = UIColor.white
    
    public var brightnessSelectedCellColor = UIColor(hexString: "#F0F0F0")
    public var brightnessDeselectedCellColor = UIColor(hexString: "#194261")
    
    public var calibratorPointColor = UIColor(hexString: "#84899C")
    
    public var datePickerLabelTextColor = UIColor.white
    public var datePickerInputBackgroundColor = UIColor(hexString: "#596880")
    public var datePickerInputTextColor = UIColor(hexString: "#F6F7EB")
    
    public static var current = ColorScheme()
}
