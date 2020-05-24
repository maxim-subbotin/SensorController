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
    
    static var shared: ModbusCenter = {
        let instance = ModbusCenter()
        return instance
    }()


    private init() {
        connector.delegate = self
    }
    
    //MARK: - commands
    
    func getAllData() {
        connector.getAllData()
    }
    
    func getAdditionalData() {
        connector.getAdditionalData()
    }
    
    func getVersion() {
        
    }
    
    func getSchedule(forDay day: WeekDay) {
        connector.getSchedule(forDay: day)
    }
    
    func setDeviceTemperature(_ t: Double) {
        connector.setDeviceTemperature(t)
    }
    
    func setFanSpeed(_ s: Double) {
        connector.setFanSpeed(s)
    }
    
    func setFanMode(_ mode: FanMode) {
        connector.setFanMode(mode)
    }
    
    func setBrightnessDimming(_ d: BrightnessDimmingOnSleepType) {
        connector.setBrightnessDimming(d)
    }
    
    func setTemperatureReactionTime(_ t: Int) {
        connector.setTemperatureReactionTime(t)
    }
    
    func setMaxFanSpeedLimit(_ s: Int) {
        connector.setMaxFanSpeedLimit(s)
    }
    
    func setTemperatureStepSleepMode(_ s: Int) {
        connector.setTemperatureStepSleepMode(s)
    }
    
    func setDisplayBrightness(_ b: Int) {
        connector.setDisplayBrightness(b)
    }
    
    func setTemperatureSensorCalibration(_ d: Double) {
        connector.setTemperatureSensorCalibration(d)
    }
    
    func setTemperatureSchedule(forDay day: WeekDay, time: DayTime, value: Int) {
        connector.setTemperatureSchedule(forDay: day, time: time, andValue: value)
    }
    
    func shutdown() {
        connector.setRegulatorState(.off)
    }
    
    func turnOn() {
        connector.setRegulatorState(.on)
    }
    
    //MARK: - connector delegate
    
    func onSuccessConnection(_ connector: Connector) {
        
    }
    
    func onFailConnection(_ connector: Connector) {

    }
    
    func onCommandSuccess(_ connector: Connector, command: ConnectorCommand, data: [AnyObject]) {
        let response = ModbusResponse(withCommand: command)
        response.data = data
        NotificationCenter.default.post(name: .modbusResponse, object: response)
    }
    
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError) {
        print("Command was failed. \(error.description)")
    }
}
