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

enum SpotAdditionalParamType: Int {
    case controlSequence = 1
    case regulatorBehaviourInShutdown = 2
    case displayBrightness = 3
    case temperatureSensorCalibration = 4
    case fanWorkModeInShutdown = 5
    case ventilationMode = 6
    case autoFanSpeedGraph = 7
    case reactionTimeOnTemperature = 8
    case maxFanSpeedLimit = 9
    case buttonBlockMode = 10
    case brightnessDimmingOnSleep = 11
    case temperatureStepInSleepMode = 12
    case weekProgramMode = 13
    case defaultSettings = 14
}

enum ControlSequenceType: Int {
    case onlyHeat = 1
    case onlyCold = 2
    case heatAndCold = 3
}

enum RegulatorShutdownWorkType: Int {
    case fullShutdown = 1
    case partialShutdown = 2
}

enum FanShutdownWorkType: Int {
    case valveClosed = 1
    case valveOpened = 2
}

enum VentilationMode: Int {
    case turnOff = 1
    case turnOn = 2
}

enum AutoFanSpeedGraphType: Int {
    case graph1 = 1
    case graph2 = 2
    case graph3 = 3
}

enum ButtonBlockMode: Int {
    case manual = 1
    case auto = 2
    case forbid = 3
}

enum BrightnessDimmingOnSleepType: Int {
    case yes = 1
    case no = 2
}

enum WeekProgramMode: Int {
    case enabled = 1
    case disabled = 2
    case byFanSpeed = 3
}

enum DefaultSettingsType: Int {
    case yes = 1
    case no = 2
}

class ParameterType {
    public var type: SpotAdditionalParamType
    public var title: String
    
    init(withType t: SpotAdditionalParamType, andTitle ttl: String) {
        self.type = t
        self.title = ttl
    }
    
    public static var allTypes: [ParameterType] {
        var types = [ParameterType]()
        types.append(ParameterType(withType: .controlSequence, andTitle: "Control Sequence"))
        types.append(ParameterType(withType: .regulatorBehaviourInShutdown, andTitle: "Regulator shutdown mode"))
        types.append(ParameterType(withType: .displayBrightness, andTitle: "Display brightness"))
        types.append(ParameterType(withType: .temperatureSensorCalibration, andTitle: "Temperature sensor calibration"))
        types.append(ParameterType(withType: .fanWorkModeInShutdown, andTitle: "Valve shutdown mode"))
        types.append(ParameterType(withType: .ventilationMode, andTitle: "Ventilation mode"))
        types.append(ParameterType(withType: .autoFanSpeedGraph, andTitle: "Auto regulation graph"))
        types.append(ParameterType(withType: .reactionTimeOnTemperature, andTitle: "Temperature reaction time"))
        types.append(ParameterType(withType: .maxFanSpeedLimit, andTitle: "Max fan speed limit"))
        types.append(ParameterType(withType: .buttonBlockMode, andTitle: "Buttons block mode"))
        types.append(ParameterType(withType: .brightnessDimmingOnSleep, andTitle: "Brightness dimming"))
        types.append(ParameterType(withType: .temperatureStepInSleepMode, andTitle: "Temperature step for Sleep mode"))
        types.append(ParameterType(withType: .weekProgramMode, andTitle: "Week programming mode"))
        types.append(ParameterType(withType: .defaultSettings, andTitle: "Default settings"))
        return types
    }
}
