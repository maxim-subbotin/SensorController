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
}
