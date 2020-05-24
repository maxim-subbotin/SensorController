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
    
    func setDeviceTemperature(_ t: Double) {
        connector.setDeviceTemperature(t)
    }
    
    func setFanSpeed(_ s: Double) {
        connector.setFanSpeed(s)
    }
    
    func shutdown() {
        
    }
    
    func getVersion() {
        
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
