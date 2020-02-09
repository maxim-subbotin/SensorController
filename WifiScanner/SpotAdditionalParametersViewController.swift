//
//  SpotAdditionalParametersViewController.swift
//  WifiScanner
//
//  1/29/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotAdditionalParametersViewController: UITableViewController, SpotEnumParameterViewCellDelegate, BrightnessSensorViewDelegate,
                                              SpotCalibrationParameterViewCellDelegate, SpotFanSpeedParameterViewCellDelegate, ReactionTimeViewDelegate, ConnectorDelegate {
    private var _spotState = SpotState()
    public var spotState: SpotState {
        get {
            return _spotState
        }
        set {
            _spotState = newValue
            
            tableView.reloadData()
        }
    }
    private var paramHeight = CGFloat(55)
    private var parameters = ParameterType.allTypes
    public weak var connector: Connector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorScheme.current.backgroundColor
        self.navigationItem.title = "Additional parameters"
        
        tableView.allowsSelection = false
        tableView.isScrollEnabled = true
        tableView.backgroundColor = ColorScheme.current.backgroundColor
        tableView.separatorStyle = .none
        tableView.register(SpotParameterViewCell.self, forCellReuseIdentifier: "paramCell")
        tableView.register(SpotEnumParameterViewCell.self, forCellReuseIdentifier: "enumCell")
        tableView.register(SpotBrightnessParameterViewCell.self, forCellReuseIdentifier: "brightnessCell")
        tableView.register(SpotCalibrationParameterViewCell.self, forCellReuseIdentifier: "calibratorCell")
        tableView.register(SpotFanSpeedParameterViewCell.self, forCellReuseIdentifier: "fanspeedCell")
        tableView.register(SpotReactionTimeParameterViewCell.self, forCellReuseIdentifier: "reactionCell")
        //tableView.delegate = self
        //tableView.dataSource = self
        
        /*if connector == nil {
            if let ip = Tools.getIPAddress() {
                print("Current ip address: \(ip)")
                if let wifiIP = Tools.getWifiAddredd(byCurrentAddress: ip) {
                    connector = Connector()
                    connector?.idAddress = wifiIP
                    connector?.delegate = self
                    connector?.getAdditionalData()
                }
            }
        }*/
    }
    
    //MARK: - table delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let param = parameters[indexPath.row]
        let value = getExtraParamValue(byType: param.type)
        if value == nil {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "paramCell") as! SpotParameterViewCell)
            cell.type = param
            cell.backgroundColor = ColorScheme.current.backgroundColor
            return cell
        }
        var cell: SpotParameterViewCell?
        if param.type == .controlSequence || param.type == .regulatorBehaviourInShutdown || param.type == .fanWorkModeInShutdown || param.type == .ventilationMode || param.type == .autoFanSpeedGraph || param.type == .buttonBlockMode || param.type == .brightnessDimmingOnSleep || param.type == .temperatureStepInSleepMode || param.type == .weekProgramMode || param.type == .defaultSettings {
            cell = tableView.dequeueReusableCell(withIdentifier: "enumCell") as! SpotEnumParameterViewCell
            (cell as! SpotEnumParameterViewCell).values = items(forType: param.type)
            (cell as! SpotEnumParameterViewCell).selectedValue = item(forType: param.type, andValue: value)
            (cell as! SpotEnumParameterViewCell).delegate = self
        } else if param.type == .displayBrightness {
            cell = tableView.dequeueReusableCell(withIdentifier: "brightnessCell") as! SpotBrightnessParameterViewCell
            (cell as! SpotBrightnessParameterViewCell).level = getExtraParamValue(byType: .displayBrightness) as! Int
            (cell as! SpotBrightnessParameterViewCell).delegate = self
        } else if param.type == .temperatureSensorCalibration {
            cell = tableView.dequeueReusableCell(withIdentifier: "calibratorCell") as! SpotCalibrationParameterViewCell
            let d = getExtraParamValue(byType: .temperatureSensorCalibration) as! Double
            (cell as! SpotCalibrationParameterViewCell).calibration = CGFloat(d)
            (cell as! SpotCalibrationParameterViewCell).delegate = self
        } else if param.type == .maxFanSpeedLimit {
            cell = tableView.dequeueReusableCell(withIdentifier: "fanspeedCell") as! SpotFanSpeedParameterViewCell
            let d = getExtraParamValue(byType: .maxFanSpeedLimit) as! Int
            (cell as! SpotFanSpeedParameterViewCell).fanSpeed = CGFloat(d)
            (cell as! SpotFanSpeedParameterViewCell).delegate = self
        } else if param.type == .reactionTimeOnTemperature {
            cell = tableView.dequeueReusableCell(withIdentifier: "reactionCell") as! SpotReactionTimeParameterViewCell
            let r = getExtraParamValue(byType: .reactionTimeOnTemperature) as! Int
            (cell as! SpotReactionTimeParameterViewCell).reactionTime = CGFloat(r)
            (cell as! SpotReactionTimeParameterViewCell).delegate = self
        } else {
            cell = (tableView.dequeueReusableCell(withIdentifier: "paramCell") as! SpotParameterViewCell)
        }
        
        cell?.value = value
        cell?.type = param
        cell?.valueTitle = getExtraParamFormattedValue(byType: parameters[indexPath.row].type)
        cell?.backgroundColor = ColorScheme.current.backgroundColor
        cell?.viewController = self
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 + 10
    }
    
    //MARK: - params
    
    func getExtraParamValue(byType type: SpotAdditionalParamType) -> Any? {
        return spotState.additionalParams[type]
    }
    
    func getExtraParamFormattedValue(byType type: SpotAdditionalParamType) -> String? {
        if let val = spotState.additionalParams[type] {
            if val is ControlSequenceType {
                switch (val as! ControlSequenceType) {
                case .heatAndCold: return "Heat and cold"
                case .onlyCold: return "Only cold"
                case .onlyHeat: return "Only heat"
                }
            }
            if val is RegulatorShutdownWorkType {
                switch (val as! RegulatorShutdownWorkType) {
                case .fullShutdown: return "Full shutdown"
                case .partialShutdown: return "Partial shutdown"
                }
            }
            if val is FanShutdownWorkType {
                switch (val as! FanShutdownWorkType) {
                case .valveClosed: return "Valve closed"
                case .valveOpened: return "Valve opened"
                }
            }
            if val is VentilationMode {
                switch (val as! VentilationMode) {
                case .turnOff: return "Turn off"
                case .turnOn: return "Turn on"
                }
            }
            if val is AutoFanSpeedGraphType {
                switch (val as! AutoFanSpeedGraphType) {
                case .graph1: return "Graph 1"
                case .graph2: return "Graph 2"
                case .graph3: return "Graph 3"
                }
            }
            if val is ButtonBlockMode {
                switch (val as! ButtonBlockMode) {
                case .auto: return "Auto"
                case .manual: return "Manual"
                case .forbid: return "Forbid"
                }
            }
            if val is BrightnessDimmingOnSleepType {
                switch (val as! BrightnessDimmingOnSleepType) {
                case .no: return "No"
                case .yes: return "Yes"
                }
            }
            if val is WeekProgramMode {
                switch (val as! WeekProgramMode) {
                case .disabled: return "Disabled"
                case .byFanSpeed: return "By fan speed"
                case .byAirTemperature: return "By air temperature"
                }
            }
            if val is DefaultSettingsType {
                switch (val as! DefaultSettingsType) {
                case .no: return "No"
                case .yes: return "Yes"
                }
            }
            
            if type == .reactionTimeOnTemperature {
                let n = val as! NSNumber
                return n.intValue.minutesAndSeconds
            }
            if type == .maxFanSpeedLimit {
                let n = val as! NSNumber
                return "\(n)%"
            }
            if type == .temperatureStepInSleepMode {
                let n = val as! NSNumber
                return "\(n)°"
            }
            if type == .temperatureSensorCalibration {
                let n = val as! NSNumber
                return "\(n)°"
            }
            
            return "\(val)"
            
            if val is NSNumber {
                return "\(val as! NSNumber)"
            }
        }
        return nil
    }
    
    func item(forType type: SpotAdditionalParamType, andValue val: Any) -> ValueSelectorItem? {
        if type == .controlSequence && val is ControlSequenceType {
            switch (val as! ControlSequenceType) {
            case .heatAndCold: return ValueSelectorItem(withTitle: "Heat and cold", andValue: val)
            case .onlyCold: return ValueSelectorItem(withTitle: "Only cold", andValue: val)
            case .onlyHeat: return ValueSelectorItem(withTitle: "Only heat", andValue: val)
            }
        }
        if type == .regulatorBehaviourInShutdown {
            switch (val as! RegulatorShutdownWorkType) {
            case .fullShutdown: return ValueSelectorItem(withTitle: "Full shutdown", andValue: val)
            case .partialShutdown: return ValueSelectorItem(withTitle: "Partial shutdown", andValue: val)
            }
        }
        if type == .fanWorkModeInShutdown {
            switch (val as! FanShutdownWorkType) {
            case .valveClosed: return ValueSelectorItem(withTitle: "Valve closed", andValue: val)
            case .valveOpened: return ValueSelectorItem(withTitle: "Valve opened", andValue: val)
            }
        }
        if type == .ventilationMode {
            switch (val as! VentilationMode) {
            case .turnOff: return ValueSelectorItem(withTitle: "Turn off", andValue: val)
            case .turnOn: return ValueSelectorItem(withTitle: "Turn on", andValue: val)
            }
        }
        if type == .autoFanSpeedGraph {
            switch (val as! AutoFanSpeedGraphType) {
            case .graph1: return ValueSelectorItem(withTitle: "Graph 1", andValue: val)
            case .graph2: return ValueSelectorItem(withTitle: "Graph 2", andValue: val)
            case .graph3: return ValueSelectorItem(withTitle: "Graph 3", andValue: val)
            }
        }
        if type == .buttonBlockMode {
            switch (val as! ButtonBlockMode) {
            case .auto: return ValueSelectorItem(withTitle: "Auto", andValue: val)
            case .manual: return ValueSelectorItem(withTitle: "Manual", andValue: val)
            case .forbid: return ValueSelectorItem(withTitle: "Forbid", andValue: val)
            }
        }
        if type == .brightnessDimmingOnSleep {
            switch (val as! BrightnessDimmingOnSleepType) {
            case .no: return ValueSelectorItem(withTitle: "No", andValue: val)
            case .yes: return ValueSelectorItem(withTitle: "Yes", andValue: val)
            }
        }
        if type == .temperatureStepInSleepMode {
            let t = val as! Int
            return ValueSelectorItem(withTitle: "\(t)°", andValue: t)
        }
        if type == .weekProgramMode {
            switch (val as! WeekProgramMode) {
            case .disabled: return ValueSelectorItem(withTitle: "Disabled", andValue: val)
            case .byFanSpeed: return ValueSelectorItem(withTitle: "By fan speed", andValue: val)
            case .byAirTemperature: return ValueSelectorItem(withTitle: "By air temperature", andValue: val)
            }
        }
        if type == .defaultSettings {
            switch (val as! DefaultSettingsType) {
            case .no: return ValueSelectorItem(withTitle: "No", andValue: val)
            case .yes: return ValueSelectorItem(withTitle: "Yes", andValue: val)
            }
        }
        return nil
    }
    
    func items(forType type: SpotAdditionalParamType) -> [ValueSelectorItem] {
        if type == .controlSequence {
            return [ValueSelectorItem(withTitle: "Only heat", andValue: ControlSequenceType.onlyHeat),
                    ValueSelectorItem(withTitle: "Only cold", andValue: ControlSequenceType.onlyCold),
                    ValueSelectorItem(withTitle: "Heat and cold", andValue: ControlSequenceType.heatAndCold)]
        }
        if type == .regulatorBehaviourInShutdown {
            return [ValueSelectorItem(withTitle: "Full shutdown", andValue: RegulatorShutdownWorkType.fullShutdown),
                    ValueSelectorItem(withTitle: "Partial shutdown", andValue: RegulatorShutdownWorkType.fullShutdown)]
        }
        if type == .fanWorkModeInShutdown {
            return [ValueSelectorItem(withTitle: "Valve closed", andValue: FanShutdownWorkType.valveClosed),
                    ValueSelectorItem(withTitle: "Valve opened", andValue: FanShutdownWorkType.valveOpened)]
        }
        if type == .ventilationMode {
            return [ValueSelectorItem(withTitle: "Turn off", andValue: VentilationMode.turnOff),
                    ValueSelectorItem(withTitle: "Turn on", andValue: VentilationMode.turnOn)]
        }
        if type == .autoFanSpeedGraph {
            return [ValueSelectorItem(withTitle: "Graph 1", andValue: AutoFanSpeedGraphType.graph1),
                    ValueSelectorItem(withTitle: "Graph 2", andValue: AutoFanSpeedGraphType.graph2),
                    ValueSelectorItem(withTitle: "Graph 3", andValue: AutoFanSpeedGraphType.graph3)]
        }
        if type == .buttonBlockMode {
            return [ValueSelectorItem(withTitle: "Auto", andValue: ButtonBlockMode.auto),
                    ValueSelectorItem(withTitle: "Manual", andValue: ButtonBlockMode.manual),
                    ValueSelectorItem(withTitle: "Forbid", andValue: ButtonBlockMode.forbid)]
        }
        if type == .brightnessDimmingOnSleep {
            return [ValueSelectorItem(withTitle: "No", andValue: BrightnessDimmingOnSleepType.no),
                    ValueSelectorItem(withTitle: "Yes", andValue: BrightnessDimmingOnSleepType.yes)]
        }
        if type == .temperatureStepInSleepMode {
            return [ValueSelectorItem(withTitle: "3°", andValue: 3),
                    ValueSelectorItem(withTitle: "4°", andValue: 4),
                    ValueSelectorItem(withTitle: "5°", andValue: 5),
                    ValueSelectorItem(withTitle: "6°", andValue: 6),
                    ValueSelectorItem(withTitle: "7°", andValue: 7),
                    ValueSelectorItem(withTitle: "8°", andValue: 8),
                    ValueSelectorItem(withTitle: "9°", andValue: 9),
                    ValueSelectorItem(withTitle: "10°", andValue: 10)]
        }
        if type == .weekProgramMode {
            return [ValueSelectorItem(withTitle: "Disabled", andValue: WeekProgramMode.disabled),
                    ValueSelectorItem(withTitle: "By fan speed", andValue: WeekProgramMode.byFanSpeed),
                    ValueSelectorItem(withTitle: "By air temperature", andValue: WeekProgramMode.byAirTemperature)]
        }
        if type == .defaultSettings {
            return [ValueSelectorItem(withTitle: "No", andValue: DefaultSettingsType.no),
                    ValueSelectorItem(withTitle: "Yes", andValue: DefaultSettingsType.yes)]
        }
        return [ValueSelectorItem]()
    }
    
    //MARK: - enum param changing callback
    
    func onEnumParameterSelection(_ val: ValueSelectorItem, forParam param: ParameterType) {
        spotState.additionalParams[param.type] = val.value
        
        for cell in tableView.visibleCells {
            if cell is SpotEnumParameterViewCell {
                let paramCell = cell as! SpotEnumParameterViewCell
                if paramCell.type?.type == param.type {
                    paramCell.selectedValue = val
                    paramCell.valueTitle = item(forType: param.type, andValue: val.value)?.title
                }
            }
        }
        
        if param.type == .controlSequence {
            connector?.setControlSequence(val.value as! ControlSequenceType)
        }
        if param.type == .regulatorBehaviourInShutdown {
            connector?.setRegulatorShutdownMode(val.value as! RegulatorShutdownWorkType)
        }
        if param.type == .fanWorkModeInShutdown {
            connector?.setValveShutdownMode(val.value as! FanShutdownWorkType)
        }
        if param.type == .ventilationMode {
            connector?.setVentilationMode(val.value as! VentilationMode)
        }
        if param.type == .autoFanSpeedGraph {
            connector?.setAutoRegulationGraph(val.value as! AutoFanSpeedGraphType)
        }
        if param.type == .buttonBlockMode {
            connector?.setButtonsBlockMode(val.value as! ButtonBlockMode)
        }
    }
    
    //MARK: - brightness sensor delegate
    
    func onBrightnessLevel(_ level: Int) {
        spotState.additionalParams[.displayBrightness] = level
        
        connector?.setDisplayBrightness(level)
    }
    
    //MARK: - temperature calibration
    
    func onCalibrationChange(_ value: CGFloat) {
        spotState.additionalParams[.temperatureSensorCalibration] = Double(value)
        
        connector?.setTemperatureSensorCalibration(Double(value))
    }
    
    //MARK: - device fan speed changing
    
    func onFanSpeedCellChange(_ value: CGFloat) {
        self.spotState.additionalParams[.maxFanSpeedLimit] = Int(value)
        
        connector?.setMaxFanSpeedLimit(Int(round(value)))
    }
    
    //MARK: - func onTimeChange(inSeconds sec: Int)
    
    func onTimeChange(inSeconds sec: Int) {
        self.spotState.additionalParams[.reactionTimeOnTemperature] = sec
        
        connector?.setTemperatureReactionTime(sec)
    }
    
    //MARK: - modbus connections
    
    func onSuccessConnection(_ connector: Connector) {
        
    }
    
    func onFailConnection(_ connector: Connector) {
        
    }
    
    func onCommandSuccess(_ connector: Connector, command: ConnectorCommand, data: [AnyObject]) {
        
    }
    
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError) {
        
    }
}
