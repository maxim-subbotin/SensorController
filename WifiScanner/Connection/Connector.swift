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
    
    case controlSequence = 0x1020                // ...0x102D
    case regulatorShutdownMode = 0x1021
    case displayBrightness = 0x1022
    case temperatureSensorCalibration = 0x1023
    case valveShutdownMode = 0x1024
    case ventilationMode = 0x1025
    case autoRegulationGraph = 0x1026
    case temperatureReactionTime = 0x1027
    case maxFanSpeedLimit = 0x1028
    case buttonsBlockMode = 0x1029
    case brightnessDimming = 0x102A
    case temperatureStepSleepMode = 0x102B
    case weekProgrammingMode = 0x102C
    case defaultSettings = 0x102D
    
    case version = 0x102F
    
    case allData = 0x8080
    case additionalData = 0x9090
    case schedule = 0xA0A0
    
    case unknown = 0x6660
}

enum WeekDay: Int {
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
}

enum DayTime: Int {
    case morning = 0
    case noon = 1
    case evening = 2
    case night
}

enum FanMode: Int {
    case auto = 0
    case manual = 1
}

enum RegulatorState: Int {
    case off = 0
    case on = 1
}

enum ValveState: Int {
    case cold = 1
    case hot = 256
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
    
    func free() {
        modbus.disconnect()
        modbus_free(modbus.mb)
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
    
    public var isBusy = false
    
    //MARK: - get commands
    // start address:   0x1010 = 4112
    // end address:     0x102D = 4141
    // block size:      29 bytes
    func getAllData() {
        isBusy = true
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1010, count: 10, success: {objects in
            self.isBusy = false
            print("Data was received successfully: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .allData, data: objects)
        }, failure: {error in
            self.isBusy = false
            print("Error on data receiving")
            self.delegate?.onCommandFail(self, command: .allData, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getAdditionalData() {
        isBusy = true
        connect()
        self.modbus.readRegistersFrom(startAddress: 0x1020, count: 14, success: {objects in
            self.isBusy = false
            print("Data was received successfully: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .additionalData, data: objects)
        }, failure: {error in
            self.isBusy = false
            print("Error on data receiving: \(error.code) - \(error.localizedDescription)")
            self.delegate?.onCommandFail(self, command: .additionalData, error: error)
        })
        self.modbus.disconnect()
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
    
    func getVersion() {
        connect()
        self.modbus.readRegistersFrom(startAddress: ConnectorCommand.version.rawValue, count: 1, success: {objects in
            print("Version: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .version, data: objects)
        }, failure: {error in
            print("Error on version")
            self.delegate?.onCommandFail(self, command: .version, error: error)
        })
        self.modbus.disconnect()
    }
    
    func getSchedule(forDay day: WeekDay) {
        connect()
        let command = 0x1030 + day.rawValue * 0x10
        self.modbus.readRegistersFrom(startAddress: Int32(command), count: 8, success: {objects in
            print("Schedule: \(objects)")
            self.delegate?.onCommandSuccess(self, command: .schedule, data: objects)
        }, failure: {error in
            print("Error on schedule")
            self.delegate?.onCommandFail(self, command: .schedule, error: error)
        })
        self.modbus.disconnect()
    }
    
    //MARK: - set commands
    
    /*func setTemperature(_ temp: Double) {
        connect()
        let i = Int32(temp)
        self.modbus.writeRegister(address: ConnectorCommand.temperatureDevice.rawValue, value: i, success: {
            print("Temperature was changed successfully")
        }, failure: {(error) in
            print("Temparature changing was failed: \(error.localizedDescription)")
            print(error.userInfo)
        })
        self.modbus.disconnect()
    }*/
    
    func setDate(_ date: Date) {
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: date)
        if  let year = calendarDate.year,
            let month = calendarDate.month,
            let day = calendarDate.day,
            let hour = calendarDate.hour,
            let minute = calendarDate.minute,
            let second = calendarDate.second {
            
            let y = year - Int(round(Double(year) * 0.01)) * 100
            let yearMonth = y * 256 + month
            let dayHour = day * 256 + hour
            let minuteSecond = minute * 256 + second
            
            connect()
            self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.yearMonth.rawValue, numberArray: [yearMonth, dayHour, minuteSecond], success: {
                print("Date & time were updated successfully")
                self.delegate?.onCommandSuccess(self, command: .yearMonth, data: [0] as [AnyObject])
            }, failure: {(error) in
                print("Error on date & time updating")
                self.delegate?.onCommandFail(self, command: .yearMonth, error: error)
            })
            self.modbus.disconnect()
        }
    }
    
    func setDeviceTemperature(_ t: Double) {
        let i = Int(t * 10)

        connect()
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.temperatureDevice.rawValue, numberArray: [i], success: {
            print("Device temperature was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .temperatureDevice, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on device temperature updating")
            self.delegate?.onCommandFail(self, command: .temperatureDevice, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setFanSpeed(_ fanSpeed: Double) {
        connect()
        let i = Int(fanSpeed * 10)
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.fanSpeedDevice.rawValue, numberArray: [i], success: {
            print("Fan speed was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .fanSpeedDevice, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on fan speed updating")
            self.delegate?.onCommandFail(self, command: .fanSpeedDevice, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setFanMode(_ mode: FanMode) {
        connect()
        let i = mode.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.fanMode.rawValue, numberArray: [i], success: {
            print("Fan mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .fanMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on fan mode updating")
            self.delegate?.onCommandFail(self, command: .fanMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setRegulatorState(_ state: RegulatorState) {
        connect()
        let i = state.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.regulatorState.rawValue, numberArray: [i], success: {
            print("Regulator state was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .regulatorState, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on regulator state updating")
            self.delegate?.onCommandFail(self, command: .regulatorState, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setControlSequence(_ val: ControlSequenceType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.controlSequence.rawValue, numberArray: [i], success: {
            print("Control sequence was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .controlSequence, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on control sequence updating")
            self.delegate?.onCommandFail(self, command: .controlSequence, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setRegulatorShutdownMode(_ val: RegulatorShutdownWorkType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.regulatorShutdownMode.rawValue, numberArray: [i], success: {
            print("Regulator shutdown mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .regulatorShutdownMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on regulator shutdown mode updating")
            self.delegate?.onCommandFail(self, command: .regulatorShutdownMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setDisplayBrightness(_ val: Int) {
        connect()
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.displayBrightness.rawValue, numberArray: [val], success: {
            print("Display brightness was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .displayBrightness, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on display brightness updating")
            self.delegate?.onCommandFail(self, command: .displayBrightness, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setTemperatureSensorCalibration(_ val: Double) {
        connect()
        let i = Int(val)
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.temperatureSensorCalibration.rawValue, numberArray: [i], success: {
            print("Temperature sensor calibration was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .temperatureSensorCalibration, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on temperature sensor calibration  updating")
            self.delegate?.onCommandFail(self, command: .temperatureSensorCalibration, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setValveShutdownMode(_ val: FanShutdownWorkType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.valveShutdownMode.rawValue, numberArray: [i], success: {
            print("Valve shutdown mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .valveShutdownMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on valve shutdown mode updating")
            self.delegate?.onCommandFail(self, command: .valveShutdownMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setVentilationMode(_ val: VentilationMode) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.ventilationMode.rawValue, numberArray: [i], success: {
            print("Ventilation mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .ventilationMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on ventilation mode updating")
            self.delegate?.onCommandFail(self, command: .ventilationMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setAutoRegulationGraph(_ val: AutoFanSpeedGraphType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.autoRegulationGraph.rawValue, numberArray: [i], success: {
            print("Auto regulation graph was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .autoRegulationGraph, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on auto regulation graph updating")
            self.delegate?.onCommandFail(self, command: .autoRegulationGraph, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setTemperatureReactionTime(_ val: Int) {
        connect()
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.temperatureReactionTime.rawValue, numberArray: [val], success: {
            print("Temperature reaction time was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .temperatureReactionTime, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on temperature reaction time updating")
            self.delegate?.onCommandFail(self, command: .temperatureReactionTime, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setMaxFanSpeedLimit(_ val: Int) {
        connect()
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.maxFanSpeedLimit.rawValue, numberArray: [val], success: {
            print("Max fan speed limit was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .maxFanSpeedLimit, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on max fan speed limit updating")
            self.delegate?.onCommandFail(self, command: .maxFanSpeedLimit, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setButtonsBlockMode(_ val: ButtonBlockMode) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.buttonsBlockMode.rawValue, numberArray: [i], success: {
            print("Buttons block mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .buttonsBlockMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on buttons block mode updating")
            self.delegate?.onCommandFail(self, command: .buttonsBlockMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setBrightnessDimming(_ val: BrightnessDimmingOnSleepType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.brightnessDimming.rawValue, numberArray: [i], success: {
            print("Brightness dimming was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .brightnessDimming, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on brightness dimming updating")
            self.delegate?.onCommandFail(self, command: .brightnessDimming, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setTemperatureStepSleepMode(_ val: Int) {
        connect()
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.temperatureStepSleepMode.rawValue, numberArray: [val], success: {
            print("Temperature step sleep mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .temperatureStepSleepMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on temperature step sleep mode updating")
            self.delegate?.onCommandFail(self, command: .temperatureStepSleepMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setWeekProgrammingMode(_ val: WeekProgramMode) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.weekProgrammingMode.rawValue, numberArray: [i], success: {
            print("Temperature step sleep mode was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .weekProgrammingMode, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on temperature step sleep mode updating")
            self.delegate?.onCommandFail(self, command: .weekProgrammingMode, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setDefaultSettings(_ val: DefaultSettingsType) {
        connect()
        let i = val.rawValue
        self.modbus.writeRegistersFromAndOn(address: ConnectorCommand.defaultSettings.rawValue, numberArray: [i], success: {
            print("Default settings was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .defaultSettings, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on default settings updating")
            self.delegate?.onCommandFail(self, command: .defaultSettings, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setFanSpeedSchedule(forDay day: WeekDay, time: DayTime, andValue val: Int) {
        let command = 0x1030 + day.rawValue * 0x10 + time.rawValue
        connect()
        self.modbus.writeRegistersFromAndOn(address: Int32(command), numberArray: [val * 10], success: {
            print("Schedule fan speed was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .schedule, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on schedule fan speed updating")
            self.delegate?.onCommandFail(self, command: .schedule, error: error)
        })
        self.modbus.disconnect()
    }
    
    func setTemperatureSchedule(forDay day: WeekDay, time: DayTime, andValue val: Int) {
        let command = 0x1034 + day.rawValue * 0x10 + time.rawValue
        connect()
        self.modbus.writeRegistersFromAndOn(address: Int32(command), numberArray: [val * 10], success: {
            print("Schedule temperature was updated successfully")
            self.delegate?.onCommandSuccess(self, command: .schedule, data: [0] as [AnyObject])
        }, failure: {(error) in
            print("Error on schedule temperature updating")
            self.delegate?.onCommandFail(self, command: .schedule, error: error)
        })
        self.modbus.disconnect()
    }
}
