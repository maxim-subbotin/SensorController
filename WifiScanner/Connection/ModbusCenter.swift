//
//  ModbusCenter.swift
//  WifiScanner
//
//  Created on 5/24/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation

class ModbusResponse {
    public var command: ConnectorCommand
    public var data: [AnyObject]?
    public var error: NSError?
    
    init(withCommand cmd: ConnectorCommand) {
        self.command = cmd
    }
}

extension Notification.Name {
    static let modbusResponse = Notification.Name("modbusResponse")
}

class ModbusCommand {
    public enum Status {
        case scheduled
        case inProgress
        case ended
        case failed
    }
    
    public var id = UUID()
    public var command: ConnectorCommand = .unknown
    public var data: Any?
    public var status: Status = .scheduled
    public var number = 0
    
    init(withCommand cmd: ConnectorCommand) {
        self.command = cmd
    }
    
    init(withCommand cmd: ConnectorCommand, andData d: Any) {
        self.command = cmd
        self.data = d
    }
}

class ModbusCenter: ConnectorDelegate {
    private var connector = Connector()
    public var ip: String {
        get {
            return connector.idAddress
        }
        set {
            connector.idAddress = newValue
        }
    }
    public var queue = [ModbusCommand]()
    private var commandNumber = 0
    
    static var shared: ModbusCenter = {
        let instance = ModbusCenter()
        return instance
    }()


    private init() {
        connector.delegate = self
    }
    
    //MARK: - queue processing
    
    private func addToQueue(_ command: ModbusCommand) {
        command.number = commandNumber
        self.queue.append(command)
        
        // run if the command is only one scheduled
        let countScheduled = self.queue.filter({ $0.status == .scheduled }).count
        let countProgress = self.queue.filter({ $0.status == .inProgress }).count
        if countScheduled == 1 && countProgress == 0 {
            execute(command: command)
        }
        if countProgress == 0 && countScheduled > 1 {
            execute(command: self.queue.filter({ $0.status == .scheduled })[0])
        }
        commandNumber += 1
    }
    
    private func nextCommand() {
        // try to find scheduled commands
        let scheduledCommands = self.queue.filter({ $0.status == .scheduled })
        if scheduledCommands.count > 0 {
            let command = scheduledCommands[0]
            execute(command: command)
        } else {
            let failedCommands = self.queue.filter({ $0.status == .failed })
            if failedCommands.count > 0 {
                let command = scheduledCommands[0]
                execute(command: command)
            }
        }
    }
    
    private func cleanUpCommands() {
        self.queue.removeAll(where: { $0.status == .ended })
    }
    
    //MARK: - commands
    
    func getAllData() {
        addToQueue(ModbusCommand(withCommand: .allData))
        //connector.getAllData()
    }
    
    func getAdditionalData() {
        addToQueue(ModbusCommand(withCommand: .additionalData))
        //connector.getAdditionalData()
    }
    
    func getVersion() {
        addToQueue(ModbusCommand(withCommand: .version))
    }
    
    func getSchedule(forDay day: WeekDay) {
        addToQueue(ModbusCommand(withCommand: .schedule, andData: day))
        //connector.getSchedule(forDay: day)
    }
    
    func setDeviceTemperature(_ t: Double) {
        addToQueue(ModbusCommand(withCommand: .temperatureDevice, andData: t))
        //connector.setDeviceTemperature(t)
    }
    
    func setFanSpeed(_ s: Double) {
        addToQueue(ModbusCommand(withCommand: .fanSpeedDevice, andData: s))
        //connector.setFanSpeed(s)
    }
    
    func setFanMode(_ mode: FanMode) {
        addToQueue(ModbusCommand(withCommand: .fanMode, andData: mode))
        //connector.setFanMode(mode)
    }
    
    func setBrightnessDimming(_ d: BrightnessDimmingOnSleepType) {
        addToQueue(ModbusCommand(withCommand: .brightnessDimming, andData: d))
        //connector.setBrightnessDimming(d)
    }
    
    func setTemperatureReactionTime(_ t: Int) {
        addToQueue(ModbusCommand(withCommand: .temperatureReactionTime, andData: t))
        //connector.setTemperatureReactionTime(t)
    }
    
    func setMaxFanSpeedLimit(_ s: Int) {
        addToQueue(ModbusCommand(withCommand: .maxFanSpeedLimit, andData: s))
        //connector.setMaxFanSpeedLimit(s)
    }
    
    func setTemperatureStepSleepMode(_ s: Int) {
        addToQueue(ModbusCommand(withCommand: .temperatureStepSleepMode, andData: s))
        //connector.setTemperatureStepSleepMode(s)
    }
    
    func setDisplayBrightness(_ b: Int) {
        addToQueue(ModbusCommand(withCommand: .displayBrightness, andData: b))
        //connector.setDisplayBrightness(b)
    }
    
    func setTemperatureSensorCalibration(_ d: Double) {
        addToQueue(ModbusCommand(withCommand: .temperatureSensorCalibration, andData: d))
        //connector.setTemperatureSensorCalibration(d)
    }
    
    func setTemperatureSchedule(forDay day: WeekDay, time: DayTime, value: Int) {
        addToQueue(ModbusCommand(withCommand: .schedule, andData: ["day": day, "time": time, "temperature": value]))
        //connector.setTemperatureSchedule(forDay: day, time: time, andValue: value)
    }
    
    func setControlSequence(_ c: ControlSequenceType) {
        addToQueue(ModbusCommand(withCommand: .controlSequence, andData: c))
    }
    
    func setRegulatorShutdownMode(_ d: RegulatorShutdownWorkType) {
        addToQueue(ModbusCommand(withCommand: .regulatorShutdownMode, andData: d))
    }
    
    func setValveShutdownMode(_ v: FanShutdownWorkType) {
        addToQueue(ModbusCommand(withCommand: .valveShutdownMode, andData: v))
    }
    
    func setFanSpeedGraph(_ g: AutoFanSpeedGraphType) {
        addToQueue(ModbusCommand(withCommand: .autoRegulationGraph, andData: g))
    }
    
    func setWeeklyProgrammingMode(_ m: WeekProgramMode) {
        addToQueue(ModbusCommand(withCommand: .weekProgrammingMode, andData: m))
    }
    
    func setButtonsBlockMode(_ m: ButtonBlockMode) {
        addToQueue(ModbusCommand(withCommand: .buttonsBlockMode, andData: m))
    }
    
    func shutdown() {
        addToQueue(ModbusCommand(withCommand: .regulatorState, andData: RegulatorState.off))
        //connector.setRegulatorState(.off)
    }
    
    func turnOn() {
        addToQueue(ModbusCommand(withCommand: .regulatorState, andData: RegulatorState.on))
        //connector.setRegulatorState(.on)
    }
    
    func resetDefault() {
        addToQueue(ModbusCommand(withCommand: .defaultSettings))
    }
    
    private func execute(command: ModbusCommand) {
        command.status = .inProgress
        if command.command == .allData {
            connector.getAllData()
        }
        if command.command == .additionalData {
            connector.getAdditionalData()
        }
        if command.command == .version {
            connector.getVersion()
        }
        if command.command == .schedule {
            if command.data != nil {
                if command.data is WeekDay {
                    connector.getSchedule(forDay: command.data as! WeekDay)
                }
                if command.data is [String:Any] {
                    let dict = command.data as! [String: Any]
                    let day = dict["day"] as! WeekDay
                    let time = dict["time"] as! DayTime
                    let temp = dict["temperature"] as! Int
                    connector.setTemperatureSchedule(forDay: day, time: time, andValue: temp)
                }
            }
        }
        if command.command == .temperatureDevice {
            connector.setDeviceTemperature(command.data as! Double)
        }
        if command.command == .fanSpeedDevice {
            connector.setFanSpeed(command.data as! Double)
        }
        if command.command == .fanMode {
            connector.setFanMode(command.data as! FanMode)
        }
        if command.command == .brightnessDimming {
            connector.setBrightnessDimming(command.data as! BrightnessDimmingOnSleepType)
        }
        if command.command == .temperatureReactionTime {
            connector.setTemperatureReactionTime(command.data as! Int)
        }
        if command.command == .maxFanSpeedLimit {
            connector.setMaxFanSpeedLimit(command.data as! Int)
        }
        if command.command == .temperatureStepSleepMode {
            connector.setTemperatureStepSleepMode(command.data as! Int)
        }
        if command.command == .displayBrightness {
            connector.setDisplayBrightness(command.data as! Int)
        }
        if command.command == .temperatureSensorCalibration {
            connector.setTemperatureSensorCalibration(command.data as! Double)
        }
        if command.command == .controlSequence {
            connector.setControlSequence(command.data as! ControlSequenceType)
        }
        if command.command == .regulatorShutdownMode {
            connector.setRegulatorShutdownMode(command.data as! RegulatorShutdownWorkType)
        }
        if command.command == .valveShutdownMode {
            connector.setValveShutdownMode(command.data as! FanShutdownWorkType)
        }
        if command.command == .regulatorState {
            if command.data != nil && command.data is RegulatorState {
                connector.setRegulatorState(command.data as! RegulatorState)
            }
        }
        if command.command == .autoRegulationGraph {
            connector.setAutoRegulationGraph(command.data as! AutoFanSpeedGraphType)
        }
        if command.command == .weekProgrammingMode {
            connector.setWeekProgrammingMode(command.data as! WeekProgramMode)
        }
        if command.command == .buttonsBlockMode {
            connector.setButtonsBlockMode(command.data as! ButtonBlockMode)
        }
        if command.command == .defaultSettings {
            connector.setDefaultSettings(.yes)
        }
    }
    
    //MARK: - connector delegate
    
    func onSuccessConnection(_ connector: Connector) {
        
    }
    
    func onFailConnection(_ connector: Connector) {

    }
    
    func onCommandSuccess(_ connector: Connector, command: ConnectorCommand, data: [AnyObject]) {
        let currentCommands = self.queue.filter({ $0.status == .inProgress })
        if currentCommands.count != 1 {
            print("Error - we must have only one running command in queue")
        } else {
            let command = currentCommands[0]
            command.status = .ended
        }
        
        let response = ModbusResponse(withCommand: command)
        response.data = data
        NotificationCenter.default.post(name: .modbusResponse, object: response)
        
        cleanUpCommands()
        nextCommand()
    }
    
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError) {
        let currentCommands = self.queue.filter({ $0.status == .inProgress })
        if currentCommands.count != 1 {
            print("Error - we must have only one running command in queue")
        } else {
            let command = currentCommands[0]
            command.status = .ended
        }
        print("Command was failed. \(error.description)")
        
        cleanUpCommands()
        nextCommand()
    }
}
