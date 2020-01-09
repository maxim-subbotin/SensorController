//
//  Spot.swift
//  WifiScanner
//
//  Created by Snappii on 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation

class Spot {
    public var name: String?
    public var ssid: String
    public var password: String
    public var description: String?
    public var port: Int = -1
    
    public init(withSSid s: String, andPassword p: String) {
        self.ssid = s
        self.password = p
    }
}
