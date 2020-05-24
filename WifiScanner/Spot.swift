//
//  Spot.swift
//  WifiScanner
//
// 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation

class Spot {
    public var id: Int
    public var order: Int = 0
    public var name: String?
    public var ssid: String
    public var password: String
    public var description: String?
    public var port: Int = -1
    
    public init() {
        self.id = Int.random(in: 100...100000)
        self.ssid = ""
        self.password = ""
    }
    
    public init(withSSid s: String, andPassword p: String) {
        self.id = Int.random(in: 100...100000)
        self.ssid = s
        self.password = p
    }
    
    public init(withDict dict: [String: Any]) {
        self.id = dict["id"] as! Int
        if dict["order"] != nil {
            self.order = dict["order"] as! Int
        }
        if dict["name"] != nil {
            self.name = dict["name"] as? String
        }
        self.ssid = dict["ssid"] as! String
        self.password = dict["password"] as! String
        self.description = dict["description"] as? String
        self.port = dict["port"] as! Int
    }
    
    public static var demo: Spot {
        let spot = Spot(withSSid: "Demo", andPassword: "1234")
        spot.name = "Demo device"
        return spot
    }
    
    func toDict() -> [String: Any] {
        var dict = ["id": id, "ssid": ssid, "password": password, "port": port, "order": order] as [String : Any]
        if name != nil {
            dict["name"] = name!
        }
        if description != nil {
            dict["description"] = description!
        }
        return dict
    }
    
    func save() {
        if let data = UserDefaults.standard.data(forKey: "spots") {
            var array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String:Any]]
            if let index = array.firstIndex(where: { $0["id"] != nil && ($0["id"] as! Int) == self.id }) {
                array[index] = self.toDict()
            } else {
                array.append(self.toDict())
            }
            let newData = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(newData, forKey: "spots")
            UserDefaults.standard.synchronize()
        } else {
            let array = [self.toDict()]
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(data, forKey: "spots")
            UserDefaults.standard.synchronize()
        }
    }
    
    func delete() {
        if let data = UserDefaults.standard.data(forKey: "spots") {
            var array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String:Any]]
            if let index = array.firstIndex(where: { $0["id"] != nil && ($0["id"] as! Int) == self.id }) {
                array.remove(at: index)
            }
            let newData = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(newData, forKey: "spots")
            UserDefaults.standard.synchronize()
        }
    }
    
    public static func getSavedSpots() -> [Spot] {
        if let data = UserDefaults.standard.data(forKey: "spots") {
            let array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String:Any]]
            return array.map({ Spot(withDict: $0) })
        }
        return [Spot]()
    }
}

class SpotState {
    public var date = Date()
    public var temperatureDevice: Double = 0
    public var temperatureCurrent: Double = 0
    public var fanSpeedCurrent: Double = 0
    public var valveState: ValveState = .cold
    public var fanSpeed: Double = 0
    public var fanMode: FanMode = .auto
    public var regulatorState: RegulatorState = .off
    public var additionalParams = [SpotAdditionalParamType: Any]()
    
    public static var demo: SpotState {
        let state = SpotState()
        state.date = Date()
        state.temperatureDevice = 25.9
        state.temperatureCurrent = 27
        state.fanSpeedCurrent = 70
        state.fanSpeed = 72
        state.valveState = .cold
        state.fanMode = .auto
        state.regulatorState = .on
        
        var params = [SpotAdditionalParamType: Any]()
        params[.controlSequence] = ControlSequenceType.onlyHeat
        params[.regulatorBehaviourInShutdown] = RegulatorShutdownWorkType.fullShutdown
        params[.displayBrightness] = 3
        params[.temperatureSensorCalibration] = 0.5
        params[.fanWorkModeInShutdown] = FanShutdownWorkType.valveClosed
        params[.ventilationMode] = VentilationMode.turnOff
        params[.autoFanSpeedGraph] = AutoFanSpeedGraphType.graph1
        params[.reactionTimeOnTemperature] = 30
        params[.maxFanSpeedLimit] = 50
        params[.buttonBlockMode] = ButtonBlockMode.manual
        params[.brightnessDimmingOnSleep] = BrightnessDimmingOnSleepType.yes
        params[.temperatureStepInSleepMode] = 5
        params[.weekProgramMode] = WeekProgramMode.byAirTemperature
        params[.defaultSettings] = DefaultSettingsType.no
        
        state.additionalParams = params
        
        return state
    }
    
    public static func parseAdditionalData(_ data: [Int]) -> [SpotAdditionalParamType: Any]{
        var dict = [SpotAdditionalParamType: Any]()
        
        var i = 0
        for d in data {
            if i == 0 {
                let v = ControlSequenceType(rawValue: d) ?? .onlyHeat
                dict[.controlSequence] = v
            }
            if i == 1 {
                let v = RegulatorShutdownWorkType(rawValue: d) ?? .partialShutdown
                dict[.regulatorBehaviourInShutdown] = v
            }
            if i == 2 {
                dict[.displayBrightness] = d
            }
            if i == 3 { // 65486 - why???
                dict[.temperatureSensorCalibration] = Double(d)
            }
            if i == 4 {
                dict[.fanWorkModeInShutdown] = FanShutdownWorkType(rawValue: d) ?? .valveClosed
            }
            if i == 5 {
                dict[.ventilationMode] = VentilationMode(rawValue: d) ?? .turnOff
            }
            if i == 6 {
                dict[.autoFanSpeedGraph] = AutoFanSpeedGraphType(rawValue: d) ?? .graph1
            }
            if i == 7 {
                dict[.reactionTimeOnTemperature] = d
            }
            if i == 8 {
                dict[.maxFanSpeedLimit] = d
            }
            if i == 9 {
                dict[.buttonBlockMode] = ButtonBlockMode(rawValue: d) ?? .manual
            }
            if i == 10 {
                dict[.brightnessDimmingOnSleep] = BrightnessDimmingOnSleepType(rawValue: d) ?? .no
            }
            if i == 11 {
                dict[.temperatureStepInSleepMode] = d
            }
            if i == 12 {
                dict[.weekProgramMode] = WeekProgramMode(rawValue: d) ?? .disabled
            }
            if i == 13 {
                dict[.defaultSettings] = DefaultSettingsType(rawValue: d) ?? .no
            }
            if i == 14 {
                dict[.version] = d
            }
            
            i += 1
        }
        
        return dict
    }
    
    public static func parseData(_ data: [Int]) -> SpotState {
        let spotState = SpotState()
        
        var year = 0
        var month = 0
        var day = 0
        var hour = 0
        var minute = 0
        var second = 0
        
        var i = 0
        for d in data {
            if i == 0 { // year and month
                let bytes = d.twoBytes
                
                year = Int(bytes[0])
                month = Int(bytes[1])
            }
            if i == 1 { // day and hour
                let bytes = d.twoBytes
                
                day = Int(bytes[0])
                hour = Int(bytes[1])
            }
            if i == 2 { // minutes and second
                let bytes = d.twoBytes
                
                minute = Int(bytes[0])
                second = Int(bytes[1])
                
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = hour
                dateComponents.minute = minute
                dateComponents.second = second
                
                spotState.date = Calendar.current.date(from: dateComponents) ?? Date()
            }
            if i == 3 { // temperature
                spotState.temperatureDevice = Double(d) * 0.1
            }
            if i == 4 { // current temperature
                spotState.temperatureCurrent = Double(d) * 0.1
            }
            if i == 5 { // fan speed current
                spotState.fanSpeedCurrent = Double(d) * 0.1
            }
            if i == 6 { // valve state
                // 0x0001 - cold
                // 0x0100 - hot
                spotState.valveState = ValveState(rawValue: d) ?? .cold
            }
            if i == 7 { // fan speed device
                spotState.fanSpeed = Double(d) * 0.1
            }
            if i == 8 { // fan mode
                spotState.fanMode = d == 0 ? .auto : .manual
            }
            if i == 9 { // regulator state
                spotState.regulatorState = d == 0 ? .off : .on
            }
            
            i += 1
        }
        
        return spotState
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
    case version = 15
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
    case disabled = 1
    case byAirTemperature = 2
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
