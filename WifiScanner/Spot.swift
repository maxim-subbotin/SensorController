//
//  Spot.swift
//  WifiScanner
//
// 9/20/19.
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
    
    public static var demo: Spot {
        let spot = Spot(withSSid: "Demo", andPassword: "1234")
        spot.name = "Demo device"
        return spot
    }
}

class SpotState {
    public var date = Date()
    public var temperatureDevice: Double = 0
    public var temperatureCurrent: Double = 0
    public var fanSpeedCurrent: Double = 0
    public var valveState: Int = 0
    public var fanSpeed: Double = 0
    public var fanMode: FanMode = .auto
    public var regulatorState: RegulatorState = .off
    
    public static var demo: SpotState {
        let state = SpotState()
        state.date = Date()
        state.temperatureDevice = 25.9
        state.temperatureCurrent = 27
        state.fanSpeedCurrent = 70
        state.fanSpeed = 72
        state.valveState = 1
        state.fanMode = .auto
        state.regulatorState = .on
        return state
    }
}
