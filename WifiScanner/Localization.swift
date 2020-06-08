//
//  Localization.swift
//  WifiScanner
//
//  Created by Snappii on 5/31/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation

class Localization {
    static var main: Localization = {
        let instance = Localization()
        return instance
    }()

    private init() {}
    
    func string(byName name: String, defValue: String) -> String {
        return NSLocalizedString(name, comment: defValue)
    }
    
    public var demo: String {
        return string(byName: "demo", defValue: "Demo")
    }
    
    public var next: String {
        return string(byName: "next", defValue: "Next")
    }
    
    public var back: String {
        return string(byName: "back", defValue: "Back")
    }
    
    public var regulatorTitle: String {
        return string(byName: "regulator_title", defValue: "Regulator title")
    }
    
    public var regulatorTitleDescription: String {
        return string(byName: "regulator_title_description", defValue: "Please enter an area name where the regulator is installed")
    }
    
    public var connectionType: String {
        return string(byName: "connection_type", defValue: "Choose a connection type")
    }
    
    public var directConnection: String {
        return string(byName: "direct_connection", defValue: "Direct connection")
    }
    
    public var internetConnection: String {
        return string(byName: "internet_connection", defValue: "Internet connection")
    }
    
    public var authorization: String {
        return string(byName: "authorization", defValue: "Autorization")
    }
    
    public var emailAddress: String {
        return string(byName: "email_address", defValue: "Email address")
    }
    
    public var password: String {
        return string(byName: "password", defValue: "Password")
    }
    
    public var signUp: String {
        return string(byName: "sign_up", defValue: "Sign up")
    }
    
    public var forgetPassword: String {
        return string(byName: "forget_password", defValue: "Forget password")
    }
    
    public var name: String {
        return string(byName: "name", defValue: "Name")
    }
    
    public var company: String {
        return string(byName: "company", defValue: "Company")
    }
    
    public var passwordAgain: String {
        return string(byName: "passwordAgain", defValue: "Type password again")
    }
    
    public var signUpDescription: String {
        return string(byName: "signUpDescription", defValue: "By submitting your personal information you agree to receive emails from Varmann, also you accept Confidentiality Policy")
    }
    
    public var OK: String {
        return string(byName: "ok", defValue: "OK")
    }
    
    public var accessRecovery: String {
        return string(byName: "access_recovery", defValue: "Access recovery:")
    }
    
    public var accessRecoveryDescription: String {
        return string(byName: "access_recovery_description", defValue: "Enter the email address for access recovery. You will receive an email with instructions for password resetting.")
    }
    
    public var restore: String {
        return string(byName: "restore", defValue: "Restore")
    }
    
    public var impossibleConnect: String {
        return string(byName: "impossible_connect", defValue: "Impossible to connect the regulator")
    }
    
    public var impossibleConnectDescription: String {
        return string(byName: "impossible_connect_description", defValue: "Please make sure the regulator is connected to network and distance from your device to the regulator less than 10 meters.")
    }
    
    public var tryAgain: String {
        return string(byName: "try_again", defValue: "Try again")
    }
    
    public var enterRegulator: String {
        return string(byName: "enter_regulator", defValue: "Enter regulator network ID\nand his password")
    }
    
    public var regulatorNetworkId: String {
        return string(byName: "regulator_network_ID", defValue: "Regulator network ID")
    }
    
    public var regulatorPassword: String {
        return string(byName: "regulator_password", defValue: "Regulator password")
    }
    
    public var connection: String {
        return string(byName: "connection", defValue: "Connection...")
    }
    
    public var cancel: String {
        return string(byName: "cancel", defValue: "Cancel")
    }
    
    public var auto: String {
        return string(byName: "auto", defValue: "Auto")
    }
    
    public var weeklyProgramming: String {
        return string(byName: "weekly_programming", defValue: "Weekly programming")
    }
    
    public var monday: String {
        return string(byName: "monday", defValue: "Monday")
    }
    
    public var tuesday: String {
        return string(byName: "tuesday", defValue: "Tuesday")
    }
    
    public var wednesday: String {
        return string(byName: "wednesday", defValue: "Wednesday")
    }
    
    public var thursday: String {
        return string(byName: "thursday", defValue: "Thursday")
    }
    
    public var friday: String {
        return string(byName: "friday", defValue: "Friday")
    }
    
    public var saturday: String {
        return string(byName: "saturday", defValue: "Saturday")
    }
    
    public var sunday: String {
        return string(byName: "sunday", defValue: "Sunday")
    }
    
    public var mo: String {
        return string(byName: "mo", defValue: "Mo")
    }
    
    public var tu: String {
        return string(byName: "tu", defValue: "Tu")
    }
    
    public var we: String {
        return string(byName: "we", defValue: "We")
    }
    
    public var th: String {
        return string(byName: "th", defValue: "Th")
    }
    
    public var fr: String {
        return string(byName: "fr", defValue: "Fr")
    }
    
    public var sa: String {
        return string(byName: "sa", defValue: "Sa")
    }
    
    public var su: String {
        return string(byName: "su", defValue: "Su")
    }
    
    public var parameters: String {
        return string(byName: "parameters", defValue: "Parameters")
    }
    
    public var fanControlMode: String {
        return string(byName: "fan_control_mode", defValue: "Fan control mode")
    }
    
    public var manualMode: String {
        return string(byName: "manual_mode", defValue: "Manual")
    }
    
    public var autoMode: String {
        return string(byName: "auto_mode", defValue: "Auto")
    }
    
    public var controlSequence: String {
        return string(byName: "control_sequence", defValue: "Control sequence")
    }
    
    public var onlyHeat: String {
        return string(byName: "only_heat", defValue: "Only heat")
    }
    
    public var onlyCold: String {
        return string(byName: "only_cold", defValue: "Only cold")
    }
    
    public var heatAndCold: String {
        return string(byName: "heat_and_cold", defValue: "Heat and cold")
    }
    
    public var regulatorShutdownMode: String {
        return string(byName: "regulator_shutdown_mode", defValue: "Regulator shutdown mode")
    }
    
    public var valveShutdownMode: String {
        return string(byName: "valve_shutdown_mode", defValue: "Valve shutdown mode")
    }
    
    public var fullShutdown: String {
        return string(byName: "full_shutdown", defValue: "Full shutdown")
    }
    
    public var partialShutdown: String {
        return string(byName: "partial_shutdown", defValue: "Partial shutdown")
    }
    
    public var ventilationMode: String {
        return string(byName: "ventilation_mode", defValue: "Ventilation mode")
    }
    
    public var disabled: String {
        return string(byName: "disabled", defValue: "Disabled")
    }
    
    public var enabled: String {
        return string(byName: "enabled", defValue: "Enabled")
    }
    
    public var fanSpeedGraph: String {
        return string(byName: "fan_speed_graph", defValue: "Fan speed graph")
    }
    
    public var graph1: String {
        return string(byName: "graph_1", defValue: "Graph 1")
    }
    
    public var graph2: String {
        return string(byName: "graph_2", defValue: "Graph 2")
    }
    
    public var graph3: String {
        return string(byName: "graph_3", defValue: "Graph 3")
    }
    
    public var temperatureReactionTime: String {
        return string(byName: "temperature_reaction_time", defValue: "Temperature reaction time:")
    }
    
    public var sec: String {
        return string(byName: "sec", defValue: "sec")
    }
    
    public var maxFanSpeedLimit: String {
        return string(byName: "max_fan_speed_limit", defValue: "Max fan speed limit:")
    }
    
    public var temperatureStep: String {
        return string(byName: "temperature_step_for_sleep_mode", defValue: "Temperature step for Sleep mode:")
    }
    
    public var weekProgrammingMode: String {
        return string(byName: "week_programming_mode", defValue: "Week programming mode:")
    }
    
    public var byFanSpeed: String {
        return string(byName: "by_fan_speed", defValue: "By fan speed")
    }
    
    public var byAirTemperature: String {
        return string(byName: "by_air_temperature", defValue: "By air temperature")
    }
    
    public var indicationMode: String {
        return string(byName: "indication_modes", defValue: "Indication modes")
    }
    
    public var displayBrightness: String {
        return string(byName: "display_brightness", defValue: "Display brightness:")
    }
    
    public var displayDimming: String {
        return string(byName: "brightness_dimming", defValue: "Brightness dimming")
    }
    
    public var others: String {
        return string(byName: "others", defValue: "Others")
    }
    
    public var temperatureSensorCalibration: String {
        return string(byName: "temperature_sensor_calibration", defValue: "Temperature sensor calibration:")
    }
    
    public var buttonsBlockMode: String {
        return string(byName: "buttons_block_mode", defValue: "Buttons block mode:")
    }
    
    public var blockModeManual: String {
        return string(byName: "block_mode_manual", defValue: "Manual block")
    }
    
    public var blockModeAuto: String {
        return string(byName: "block_mode_auto", defValue: "Automatic block")
    }
    
    public var blockModeForbid: String {
        return string(byName: "block_mode_forbid", defValue: "Don't block")
    }
    
    public var defaultSettings: String {
        return string(byName: "default_settings", defValue: "Default settings")
    }
    
    public var reset: String {
        return string(byName: "reset", defValue: "Reset")
    }
    
    public var removeDevice: String {
        return string(byName: "remove_device", defValue: "Remove device form list")
    }
    
    public var remove: String {
        return string(byName: "remove", defValue: "Remove")
    }
    
    public var turnedOff: String {
        return string(byName: "turned_off", defValue: "Turned off")
    }
    
    public var yes: String {
        return string(byName: "yes", defValue: "Yes")
    }
    
    public var no: String {
        return string(byName: "no", defValue: "No")
    }
    
    public var restoringMessage: String {
        return string(byName: "restoringMessage", defValue: "The settings will be restored to factory default. Do you want to continue?")
    }
    
    public var warning: String {
        return string(byName: "warning", defValue: "Warning")
    }
    
    public var version: String {
        return string(byName: "version", defValue: "Version")
    }
    
    public var devices: String {
        return string(byName: "devices", defValue: "Devices")
    }
    
    public var deviceViaScan: String {
        return string(byName: "add_device_scan_mode", defValue: "Scan mode")
    }
    
    public var deviceViaManual: String {
        return string(byName: "add_device_manual_mode", defValue: "Manual")
    }
    
    public var dateAndTime: String {
        return string(byName: "date_and_time", defValue: "Date and time")
    }
    
    public var setCurrentDate: String {
        return string(byName: "set_current_date", defValue: "Set current date and time")
    }
}
