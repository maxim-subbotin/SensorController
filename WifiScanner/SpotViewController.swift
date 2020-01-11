//
//  SpotViewController.swift
//  WifiScanner
//
//  Created by Snappii on 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

enum CellType: Int {
    case date
    case time
    case temperatureDevice
    case temperatureCurrent
    case fanSpeedCurrent
    case valveState
    case fanSpeed
    case regulatorState
    case fanMode
    
    case unknown
}

class SpotDateCell: UITableViewCell {
    private var lblTitle = UILabel()
    private var separator = UIView()
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    public var cellType: CellType = .unknown
    public weak var delegate: SpotDataCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI() {
        self.contentView.addSubview(lblTitle)
        lblTitle.frame = .zero
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20)
        let tC = lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let hC = lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        NSLayoutConstraint.activate([lC, wC, tC, hC])
        
        self.contentView.addSubview(separator)
        separator.frame = .zero
        separator.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = separator.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0)
        let wC1 = separator.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 0)
        let tC1 = separator.heightAnchor.constraint(equalToConstant: 1)
        let hC1 = separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        NSLayoutConstraint.activate([lC1, wC1, tC1, hC1])
        separator.backgroundColor = UIColor(hexString: "#F0F0F0")
    }
}

protocol SpotDataCellDelegate: class {
    func onCellEditing(_ command: CellType, value: Any)
}

class InputSpotDateCell: SpotDateCell, UITextFieldDelegate {
    internal var txtDate = UITextField()
    public var enabled: Bool {
        get {
            return txtDate.isEnabled
        }
        set {
            txtDate.isEnabled = newValue
        }
    }
    
    override func initUI() {
        super.initUI()
        
        self.contentView.addSubview(txtDate)
        txtDate.frame = .zero
        txtDate.translatesAutoresizingMaskIntoConstraints = false
        let lC = txtDate.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        let wC = txtDate.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20)
        let tC = txtDate.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let hC = txtDate.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        NSLayoutConstraint.activate([lC, wC, tC, hC])
        txtDate.textAlignment = .right
        
        txtDate.delegate = self
    }
}

class DateSpotDateCell: InputSpotDateCell {
    private var _date: Date?
    public var date: Date? {
        get {
            return _date
        }
        set {
            _date = newValue
            txtDate.text = newValue?.dateFormat
        }
    }
    internal var datePicker = UIDatePicker()
    
    override func initUI() {
        super.initUI()
        
        txtDate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(onPickerChange), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(onPickerEnd), for: .editingDidEnd)
    }
    
    @objc func onPickerChange() {
        date = datePicker.date
    }
    
    @objc func onPickerEnd() {
        let d = datePicker.date
        self.delegate?.onCellEditing(cellType, value: d)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onPickerEnd()
    }
}

class TimeSpotDataCell: DateSpotDateCell {
    override public var date: Date? {
        get {
            return super.date
        }
        set {
            super.date = newValue
            txtDate.text = newValue?.timeFormat
        }
    }
    
    override func initUI() {
        super.initUI()
        datePicker.datePickerMode = .time
    }
}

class DoubleSpotDataCell: InputSpotDateCell {
    private var _value: Double = 0
    public var value: Double {
        get {
            return _value
        }
        set {
            _value = newValue
            txtDate.text = "\(_value)"
        }
    }
    
    override func initUI() {
        super.initUI()
        txtDate.keyboardType = .numberPad
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let str = textField.text {
            if let d = Double(str) {
                self.delegate?.onCellEditing(cellType, value: d)
            }
        }
    }
}

class SpotViewController: UIViewController, ConnectorDelegate, UITableViewDelegate, UITableViewDataSource, SpotDataCellDelegate {
    public var spot:Spot? = nil
    
    private var year: Int = -1
    private var month: Int = -1
    private var day: Int = -1
    private var hour: Int = -1
    private var minute: Int = -1
    private var second: Int = -1
    private var date = Date()
    private var temperatureDevice: Double = 0
    private var temperatureCurrent: Double = 0
    private var fanSpeedCurrent: Double = 0
    private var valveState: Int = 0
    private var fanSpeed: Double = 0
    private var fanMode: FanMode = .auto
    private var regulatorState: RegulatorState = .off
    
    /*private var lblYear = UILabel()
    private var lblDay = UILabel()
    private var lblMinute = UILabel()
    private var lblDeviceTemperature = UILabel()
    private var lblCurrentTemperature = UILabel()
    private var lblFanSpeed = UILabel()
    private var lblValveState = UILabel()*/
    
    private var tblData = UITableView()
    
    private var connector = Connector()
    
    private var cells = [CellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (spot != nil && spot!.name != nil) ? spot!.name : "Spot"
        
        self.view.backgroundColor = UIColor(hexString: "#EDEDED")
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#C1CAD6")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#404040")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(hexString: "#404040")]
        
        initUI()
        
        if let ip = Tools.getIPAddress() {
            print("Current ip address: \(ip)")
            if let wifiIP = Tools.getWifiAddredd(byCurrentAddress: ip) {
                connector.idAddress = wifiIP
                connector.delegate = self
                connector.getYear()
            }
        }
    }
    
    func initUI() {
        self.view.addSubview(tblData)
        tblData.frame = .zero
        tblData.translatesAutoresizingMaskIntoConstraints = false
        let lC = tblData.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let wC = tblData.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let tC = tblData.topAnchor.constraint(equalTo: self.view.topAnchor)
        let hC = tblData.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([lC, wC, tC, hC])
        tblData.delegate = self
        tblData.dataSource = self
        tblData.register(DateSpotDateCell.self, forCellReuseIdentifier: "dateCell")
        tblData.register(TimeSpotDataCell.self, forCellReuseIdentifier: "timeCell")
        tblData.register(DoubleSpotDataCell.self, forCellReuseIdentifier: "doubleCell")
        tblData.separatorStyle = .none
        
        /*self.view.addSubview(lblYear)
        lblYear.text = "Year: "
        lblYear.frame = .zero
        lblYear.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblYear.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC = lblYear.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC = lblYear.topAnchor.constraint(equalTo: self.view.topAnchor, constant: offset + 64)
        let hC = lblYear.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC, wC, tC, hC])
        
        self.view.addSubview(lblDay)
        lblDay.text = "Day: "
        lblDay.frame = .zero
        lblDay.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblDay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC1 = lblDay.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC1 = lblDay.topAnchor.constraint(equalTo: lblYear.bottomAnchor, constant: offset)
        let hC1 = lblDay.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC1, wC1, tC1, hC1])
        
        self.view.addSubview(lblMinute)
        lblMinute.text = "Minute: "
        lblMinute.frame = .zero
        lblMinute.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = lblMinute.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC2 = lblMinute.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC2 = lblMinute.topAnchor.constraint(equalTo: lblDay.bottomAnchor, constant: offset)
        let hC2 = lblMinute.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC2, wC2, tC2, hC2])
        
        self.view.addSubview(lblDeviceTemperature)
        lblDeviceTemperature.text = "Device temperature: "
        lblDeviceTemperature.frame = .zero
        lblDeviceTemperature.translatesAutoresizingMaskIntoConstraints = false
        let lC3 = lblDeviceTemperature.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC3 = lblDeviceTemperature.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC3 = lblDeviceTemperature.topAnchor.constraint(equalTo: lblMinute.bottomAnchor, constant: offset)
        let hC3 = lblDeviceTemperature.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC3, wC3, tC3, hC3])
        
        self.view.addSubview(lblCurrentTemperature)
        lblCurrentTemperature.text = "Device temperature: "
        lblCurrentTemperature.frame = .zero
        lblCurrentTemperature.translatesAutoresizingMaskIntoConstraints = false
        let lC4 = lblCurrentTemperature.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC4 = lblCurrentTemperature.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC4 = lblCurrentTemperature.topAnchor.constraint(equalTo: lblDeviceTemperature.bottomAnchor, constant: offset)
        let hC4 = lblCurrentTemperature.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC4, wC4, tC4, hC4])
        
        self.view.addSubview(lblFanSpeed)
        lblFanSpeed.text = "Fan speed: "
        lblFanSpeed.frame = .zero
        lblFanSpeed.translatesAutoresizingMaskIntoConstraints = false
        let lC5 = lblFanSpeed.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)
        let wC5 = lblFanSpeed.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * offset)
        let tC5 = lblFanSpeed.topAnchor.constraint(equalTo: lblCurrentTemperature.bottomAnchor, constant: offset)
        let hC5 = lblFanSpeed.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC5, wC5, tC5, hC5])*/
    }

    //MARK: - connection delegate
    
    func onSuccessConnection(_ connector: Connector) {
        //
    }
    
    func onFailConnection(_ connector: Connector) {
        //
    }
    
    func onCommandSuccess(_ connector: Connector, command: ConnectorCommand, data: [AnyObject]) {
        if command == .yearMonth {
            let i = data.first as! Int
            let bytes = i.twoBytes
            
            year = Int(bytes[0])
            month = Int(bytes[1])
            
            //lblYear.text = "Year: \(i)"
            connector.getDay()
        }
        if command == .dayHour {
            let i = data.first as! Int
            let bytes = i.twoBytes
            
            day = Int(bytes[0])
            hour = Int(bytes[1])
            
            //lblDay.text = "Day: \(i)"
            connector.getMinute()
            
            cells.append(.date)
            tblData.reloadData()
        }
        if command == .minuteSecond {
            let i = data.first as! Int
            let bytes = i.twoBytes
            
            minute = Int(bytes[0])
            second = Int(bytes[1])
            
            //lblMinute.text = "Minute: \(i)"
            connector.getDeviceTemperature()
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = second

            date = Calendar.current.date(from: dateComponents) ?? Date()
            
            cells.append(.time)
            tblData.reloadData()
        }
        if command == .temperatureDevice {
            let i = data.first as! Int
            temperatureDevice = Double(i) * 0.1
            
            //lblDeviceTemperature.text = "Device temperature: \(Double(i) * 0.1)"
            connector.getCurrentTemperature()
            
            cells.append(.temperatureDevice)
            tblData.reloadData()
        }
        if command == .temperatureCurrent {
            let i = data.first as! Int
            
            temperatureCurrent = Double(i) * 0.1
            
            //lblCurrentTemperature.text = "Current temperature: \(Double(i) * 0.1)"
            connector.getFanSpeedCurrent()
            
            cells.append(.temperatureCurrent)
            tblData.reloadData()
        }
        if command == .fanSpeedCurrent {
            let i = data.first as! Int
            fanSpeedCurrent = Double(i) * 0.1
            
            //lblFanSpeed.text = "Fan speed: \(fanSpeedCurrent)"
            connector.getValveState()
            
            cells.append(.fanSpeedCurrent)
            tblData.reloadData()
        }
        if command == .valveState {
            let i = data.first as! Int
            valveState = i
            
            //lblValveState.text = "Valve state"
            connector.getFanSpeed()
            
            cells.append(.valveState)
            tblData.reloadData()
        }
        if command == .fanSpeedDevice {
            let i = data.first as! Int
            fanSpeed = Double(i) * 0.1
            
            //lblValveState.text = "Valve state"
            connector.getFanMode()
            
            cells.append(.fanSpeed)
            tblData.reloadData()
        }
        if command == .fanSpeedDevice {
            let i = data.first as! Int
            fanMode = FanMode(rawValue: i) ?? .auto
            
            connector.getRegulatorState()
            
            cells.append(.fanMode)
            tblData.reloadData()
        }
        if command == .regulatorState {
            let i = data.first as! Int
            regulatorState = RegulatorState(rawValue: i) ?? .off
            
            cells.append(.regulatorState)
            tblData.reloadData()
        }
    }
    
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError) {
        /*if command == .yearMonth {
            lblYear.text = "Year: \(error.localizedDescription)"
        }
        if command == .dayHour {
            lblDay.text = "Day: \(error.localizedDescription)"
        }
        if command == .minuteSecond {
            lblMinute.text = "Minute: \(error.localizedDescription)"
        }
        if command == .temperatureDevice {
            lblDeviceTemperature.text = "Device temperature: \(error.localizedDescription)"
        }
        if command == .temperatureCurrent {
            lblCurrentTemperature.text = "Current temperature: \(error.localizedDescription)"
        }
        if command == .fanSpeedCurrent {
            lblFanSpeed.text = "Fan speed: \(error.localizedDescription)"
        }*/
    }
    
    //MARK: - table delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellType = cells[indexPath.row]
        var spotCell: SpotDateCell?
        if cellType == .date {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateSpotDateCell
            dateCell.title = "Date"
            dateCell.date = date
            spotCell = dateCell
        }
        if cellType == .time {
            let timeCell = tableView.dequeueReusableCell(withIdentifier: "timeCell") as! TimeSpotDataCell
            timeCell.title = "Time"
            timeCell.date = date
            spotCell = timeCell
        }
        if cellType == .temperatureDevice {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Device temperature"
            doubleCell.value = temperatureDevice
            spotCell = doubleCell
        }
        if cellType == .temperatureCurrent {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Current temperature"
            doubleCell.value = temperatureCurrent
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .fanSpeedCurrent {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Current fan speed"
            doubleCell.value = fanSpeedCurrent
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .valveState {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Valve state"
            doubleCell.value = Double(valveState)
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .fanSpeed {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Fan speed"
            doubleCell.value = Double(fanSpeed)
            doubleCell.enabled = true
            spotCell = doubleCell
        }
        if cellType == .fanMode {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Fan mode"
            doubleCell.value = Double(fanMode.rawValue)
            doubleCell.enabled = true
            spotCell = doubleCell
        }
        if cellType == .regulatorState {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Regulator state"
            doubleCell.value = Double(regulatorState.rawValue)
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        spotCell?.delegate = self
        spotCell?.cellType = cellType
        
        return spotCell ?? cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func onCellEditing(_ command: CellType, value: Any) {
        if command == .temperatureDevice {
            let temp = value as! Double
            print("Temperature was changed: \(temp)")
            connector.setTemperature(temp * 10)
        }
        if command == .fanSpeedCurrent {
            let speed = value as! Double
            print("Fan speed was changed: \(speed)")
            connector.setFanSpeed(speed * 10)
        }
        if command == .date || command == .time {
            let date = value as! Date
            print("Attemption to set date: \(date)")
            connector.setDate(date)
        }
    }
}
