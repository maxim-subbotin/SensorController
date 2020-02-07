//
//  Connector.swift
//  WifiScanner
//
// 10/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation

enum ConnectorCommand: Int32 {
    case yearMonth = 0x1010
    case dayHour = 0x1011
    case minuteSecond = 0x1012
    case temperatureDevice = 0x1013     // 5...1000
    case temperatureCurrent = 0x1014
    case fanSpeedCurrent = 0x1015       // % x 10
    case valveState = 0x1016
    case fanSpeedDevice = 0x1017        // % x 10
    case fanMode = 0x1018               // 0 - auto, 1 - manual
    case regulatorState = 0x1019        // 0 - OFF, 1 - ON
    case param1 = 0x1020                // ...0x102D
    case allData = 0x8080
}

enum FanMode: Int {
    case auto = 0
    case manual = 1
}

enum RegulatorState: Int {
    case off = 0
    case on = 1
}

protocol ConnectorDelegate: class {
    func onSuccessConnection(_ connector: Connector)
    func onFailConnection(_ connector: Connector)
    func onCommandSuccess(_ connector: Connector, command: ConnectorCommand, data: [AnyObject])
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError)
}

class Connector {
    public var port: Int32 = 502
    public var slaveId: Int32 = 0x01
    private var modbus: SwiftLibModbus
    public var idAddress = "192.168.4.1"
    public weak var delegate: ConnectorDelegate?
    
    init() {
        modbus = SwiftLibModbus(ipAddress: self.idAddress as NSString, port: self.port, device: slaveId)
        //modbus = SwiftLibModbus(ipAddress: "192.168.4.1", port: self.port, device: 1)
        //connect()
    }
    
    deinit {
        delegate = nil
        modbus.disconnect()
    }
    
    func connect() {
        modbus.connect(success: {() in
            print("Modbus is connected")
            self.delegate?.onSuccessConnection(self)
        }, failure: {(error) in
            print("Error on modbus connection")
            self.delegate?.onFailConnection(self)
        })
    }
    
    //MARK: - get commands
    // start address:   0x1010 = 4112
    // end address:     0x102D = 4141
    // block size:      29 bytes
    func getAllData() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1010, count: 10, success: {objects in
            print("Data was received successfully: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .allData, data: objects)
        }, failure: {error in
            print("Error on data receiving")
            self.delegate?.onCommandFail(self, command: .allData, error: error)
        })
    }
    
    func getAllData2() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1018, count: 7, success: {objects in
            print("Data was received successfully: \(objects)")
        }, failure: {error in
            print("Error on data receiving: \(error.code) - \(error.localizedDescription)")
        })
    }
    
    func getYear() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1010, count: 1, success: {objects in
            print("Year: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .yearMonth, data: objects)
        }, failure: {error in
            print("Error on years")
            self.delegate?.onCommandFail(self, command: .yearMonth, error: error)
        })
    }
    
    func getDay() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1011, count: 1, success: {objects in
            print("Day: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .dayHour, data: objects)
        }, failure: {error in
            print("Error on days")
            self.delegate?.onCommandFail(self, command: .dayHour, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getMinute() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1012, count: 1, success: {objects in
            print("Minute: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .minuteSecond, data: objects)
        }, failure: {error in
            print("Error on minutes")
            self.delegate?.onCommandFail(self, command: .minuteSecond, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getDeviceTemperature() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1013, count: 1, success: {objects in
            print("Temperature: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .temperatureDevice, data: objects)
        }, failure: {error in
            print("Error on temperature")
            self.delegate?.onCommandFail(self, command: .temperatureDevice, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getCurrentTemperature() {
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1014, count: 1, success: {objects in
            print("Current temperature: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .temperatureCurrent, data: objects)
        }, failure: {error in
            print("Error on current temperature")
            self.delegate?.onCommandFail(self, command: .temperatureCurrent, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getFanSpeedCurrent() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.fanSpeedCurrent.rawValue, count: 1, success: {objects in
            print("Fan speed: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .fanSpeedCurrent, data: objects)
        }, failure: {error in
            print("Error on fan speed")
            self.delegate?.onCommandFail(self, command: .fanSpeedCurrent, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getValveState() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.valveState.rawValue, count: 1, success: {objects in
            print("Valve state: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .valveState, data: objects)
        }, failure: {error in
            print("Error on valve state")
            self.delegate?.onCommandFail(self, command: .valveState, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getFanSpeed() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.fanSpeedDevice.rawValue, count: 1, success: {objects in
            print("Fan speed: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .fanSpeedDevice, data: objects)
        }, failure: {error in
            print("Error on fan speed")
            self.delegate?.onCommandFail(self, command: .fanSpeedDevice, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getFanMode() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.fanMode.rawValue, count: 1, success: {objects in
            print("Fan mode: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .fanMode, data: objects)
        }, failure: {error in
            print("Error on fan mode")
            self.delegate?.onCommandFail(self, command: .fanMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getRegulatorState() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.regulatorState.rawValue, count: 1, success: {objects in
            print("Regulator state: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .regulatorState, data: objects)
        }, failure: {error in
            print("Error on regulator state")
            self.delegate?.onCommandFail(self, command: .regulatorState, error: error)
        })
        self.modbus.disconnect()
    }
    
    //MAARK: - set commands
    
    func setTemperature(_ temp: Double) {
        connect()
        let i = Int32(temp)
        self.modbus.writeRegister(address: ConnectorCommand.temperatureDevice.rawValue, value: i, success: {
            print("Temperature was changed successfully")
        }, failure: {(error) in
            print("Temparature changing was failed: \(error.localizedDescription)")
            print(error.userInfo)
        })
        self.modbus.disconnect()
    }
    
    func setFanSpeed(_ fanSpeed: Double) {
        connect()
        let i = Int32(fanSpeed)
        self.modbus.writeRegister(address: ConnectorCommand.fanSpeedCurrent.rawValue, value: i, success: {
            print("Fan speed was changed successfully")
        }, failure: {(error) in
            print("Fan speed changing was failed: \(error.localizedDescription)")
            print(error.userInfo)
        })
        self.modbus.disconnect()
    }
    
    func setDate(_ date: Date) {
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: date)
        if  let year = calendarDate.year,
            let month = calendarDate.month,
            let day = calendarDate.day,
            let hour = calendarDate.hour,
            let minute = calendarDate.minute,
            let second = calendarDate.second {
            
            let y = year - Int(round(Double(year) * 0.01)) * 100
            let yearMonth = y + month * 256
            
            connect()
            self.modbus.writeRegister(address: ConnectorCommand.yearMonth.rawValue, value: Int32(yearMonth), success: {
                print("Device year/month was changed successfully")
            }, failure: {(error) in
                print("Device year/month changing was failed: \(error.localizedDescription)")
                print(error.userInfo)
            })
            self.modbus.disconnect()
            
            let dayHour = day * 256 + hour
            connect()
            self.modbus.writeRegister(address: ConnectorCommand.yearMonth.rawValue, value: Int32(dayHour), success: {
                print("Device day/hour was changed successfully")
            }, failure: {(error) in
                print("Device day/hour changing was failed: \(error.localizedDescription)")
                print(error.userInfo)
            })
            self.modbus.disconnect()
        }
        
    }
    
    /*func test() {
        let ip = Tools.getIPAddress()
        
        let modbus = SwiftLibModbus(ipAddress: "192.168.4.1", port: self.port, device: 1)
        modbus.connect(success: {() in
            print("OK")
            
        }, failure: {(error) in

            print("ERROR")
        })
        
        modbus.readRegistersFrom(startAddress: 0x1010, count: 1, success: {objects in
            print("OK")
        }, failure: {error in
            print("ERROR")
        })
    }*/
}
