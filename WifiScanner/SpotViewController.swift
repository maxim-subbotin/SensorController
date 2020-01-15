//
//  SpotViewController.swift
//  WifiScanner
//
// 9/20/19.
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

class SpotViewController: UIViewController, ConnectorDelegate, UITableViewDelegate, UITableViewDataSource, SpotDataCellDelegate {
    public var spot:Spot? = nil
    
    private var year: Int = -1
    private var month: Int = -1
    private var day: Int = -1
    private var hour: Int = -1
    private var minute: Int = -1
    private var second: Int = -1
    
    private var _spotState = SpotState()
    public var spotState: SpotState {
        get {
            return _spotState
        }
        set {
            _spotState = newValue
            
            cardTemp.value = "\(_spotState.temperatureDevice)°"
            cardFanSpeed.value = "\(_spotState.fanSpeed)%"
        }
    }
    
    private var cardTemp = CardPanelView()
    private var cardFanSpeed = CardPanelView()
    private var cardValveState = CardPanelView()
    private var cardRegState = CardPanelView()
    private var cardPanelView = UIView()
    
    private var tblData = UITableView()
    
    private var connector = Connector()
    
    private var cells = [CellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (spot != nil && spot!.name != nil) ? spot!.name : "Spot"
        
        self.navigationItem.title = spot?.name ?? "Spot"
        
        self.view.backgroundColor = ColorScheme.current.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = ColorScheme.current.navigationBarColor
        self.navigationController?.navigationBar.tintColor = ColorScheme.current.navigationTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorScheme.current.navigationTextColor]
        
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
        applyCardPanel()
    }
    
    func applyCardPanel() {
        let cardPanelHeight = CGFloat(100)

        self.view.addSubview(cardPanelView)
        cardPanelView.translatesAutoresizingMaskIntoConstraints = false
        let lC = cardPanelView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let tC = cardPanelView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80)
        let wC = cardPanelView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC = cardPanelView.heightAnchor.constraint(equalToConstant: cardPanelHeight)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        cardPanelView.addSubview(cardTemp)
        cardPanelView.addSubview(cardFanSpeed)
        cardPanelView.addSubview(cardValveState)
        cardPanelView.addSubview(cardRegState)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            applyCardPanelForiPad()
        } else {
            applyCardPanelForiPhone()
        }

    }

    func applyCardPanelForiPad() {
        let cardOffset = CGFloat(10)
        
        cardTemp.title = "Temperature"
        cardTemp.color1 = UIColor(hexString: "#F67965")
        cardTemp.color2 = UIColor(hexString: "#F66EA6")
        cardTemp.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = cardTemp.leftAnchor.constraint(equalTo: cardPanelView.leftAnchor, constant: cardOffset)
        let tC1 = cardTemp.topAnchor.constraint(equalTo: cardPanelView.topAnchor, constant: 0)
        let wC1 = cardTemp.widthAnchor.constraint(equalToConstant: 150)
        let hC1 = cardTemp.heightAnchor.constraint(equalTo: cardPanelView.heightAnchor)
        cardTemp.layer.cornerRadius = 5
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
        
        
        cardFanSpeed.title = "Fan speed"
        cardFanSpeed.color1 = UIColor(hexString: "#4575FA")
        cardFanSpeed.color2 = UIColor(hexString: "#4430E6")
        cardFanSpeed.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = cardFanSpeed.leftAnchor.constraint(equalTo: cardTemp.rightAnchor, constant: cardOffset)
        let tC2 = cardFanSpeed.topAnchor.constraint(equalTo: cardPanelView.topAnchor, constant: 0)
        let wC2 = cardFanSpeed.widthAnchor.constraint(equalToConstant: 150)
        let hC2 = cardFanSpeed.heightAnchor.constraint(equalTo: cardPanelView.heightAnchor)
        cardFanSpeed.layer.cornerRadius = 5
        NSLayoutConstraint.activate([lC2, tC2, wC2, hC2])
        
        
        cardValveState.title = "Valve state"
        cardValveState.color1 = UIColor(hexString: "#2A3354")
        cardValveState.color2 = UIColor(hexString: "#1B1E2E")
        cardValveState.translatesAutoresizingMaskIntoConstraints = false
        let lC3 = cardValveState.leftAnchor.constraint(equalTo: cardFanSpeed.rightAnchor, constant: cardOffset)
        let tC3 = cardValveState.topAnchor.constraint(equalTo: cardPanelView.topAnchor, constant: 0)
        let wC3 = cardValveState.widthAnchor.constraint(equalToConstant: 150)
        let hC3 = cardValveState.heightAnchor.constraint(equalTo: cardPanelView.heightAnchor)
        cardValveState.layer.cornerRadius = 5
        NSLayoutConstraint.activate([lC3, tC3, wC3, hC3])
        
        
        cardRegState.title = "Regulator state"
        cardRegState.color1 = UIColor(hexString: "#D76065")
        cardRegState.color2 = UIColor(hexString: "#BC7E80")
        cardRegState.translatesAutoresizingMaskIntoConstraints = false
        let lC4 = cardRegState.leftAnchor.constraint(equalTo: cardValveState.rightAnchor, constant: cardOffset)
        let tC4 = cardRegState.topAnchor.constraint(equalTo: cardPanelView.topAnchor, constant: 0)
        let wC4 = cardRegState.widthAnchor.constraint(equalToConstant: 150)
        let hC4 = cardRegState.heightAnchor.constraint(equalTo: cardPanelView.heightAnchor)
        cardRegState.layer.cornerRadius = 5
        NSLayoutConstraint.activate([lC4, tC4, wC4, hC4])
    }
    
    func applyCardPanelForiPhone() {
        applyCardPanelForiPad()
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

            spotState.date = Calendar.current.date(from: dateComponents) ?? Date()
            
            cells.append(.time)
            tblData.reloadData()
        }
        if command == .temperatureDevice {
            let i = data.first as! Int
            spotState.temperatureDevice = Double(i) * 0.1
            
            connector.getCurrentTemperature()
            
            cells.append(.temperatureDevice)
            tblData.reloadData()
        }
        if command == .temperatureCurrent {
            let i = data.first as! Int
            
            spotState.temperatureCurrent = Double(i) * 0.1
            
            connector.getFanSpeedCurrent()
            
            cells.append(.temperatureCurrent)
            tblData.reloadData()
        }
        if command == .fanSpeedCurrent {
            let i = data.first as! Int
            spotState.fanSpeedCurrent = Double(i) * 0.1
            
            connector.getValveState()
            
            cells.append(.fanSpeedCurrent)
            tblData.reloadData()
        }
        if command == .valveState {
            let i = data.first as! Int
            spotState.valveState = i
            
            connector.getFanSpeed()
            
            cells.append(.valveState)
            tblData.reloadData()
        }
        if command == .fanSpeedDevice {
            let i = data.first as! Int
            spotState.fanSpeed = Double(i) * 0.1
            
            connector.getFanMode()
            
            cells.append(.fanSpeed)
            tblData.reloadData()
        }
        if command == .fanSpeedDevice {
            let i = data.first as! Int
            spotState.fanMode = FanMode(rawValue: i) ?? .auto
            
            connector.getRegulatorState()
            
            cells.append(.fanMode)
            tblData.reloadData()
        }
        if command == .regulatorState {
            let i = data.first as! Int
            spotState.regulatorState = RegulatorState(rawValue: i) ?? .off
            
            cells.append(.regulatorState)
            tblData.reloadData()
        }
    }
    
    func onCommandFail(_ connector: Connector, command: ConnectorCommand, error: NSError) {
        //
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
            dateCell.date = spotState.date
            spotCell = dateCell
        }
        if cellType == .time {
            let timeCell = tableView.dequeueReusableCell(withIdentifier: "timeCell") as! TimeSpotDataCell
            timeCell.title = "Time"
            timeCell.date = spotState.date
            spotCell = timeCell
        }
        if cellType == .temperatureDevice {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Device temperature"
            doubleCell.value = spotState.temperatureDevice
            spotCell = doubleCell
        }
        if cellType == .temperatureCurrent {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Current temperature"
            doubleCell.value = spotState.temperatureCurrent
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .fanSpeedCurrent {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Current fan speed"
            doubleCell.value = spotState.fanSpeedCurrent
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .valveState {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Valve state"
            doubleCell.value = Double(spotState.valveState)
            doubleCell.enabled = false
            spotCell = doubleCell
        }
        if cellType == .fanSpeed {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Fan speed"
            doubleCell.value = Double(spotState.fanSpeed)
            doubleCell.enabled = true
            spotCell = doubleCell
        }
        if cellType == .fanMode {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Fan mode"
            doubleCell.value = Double(spotState.fanMode.rawValue)
            doubleCell.enabled = true
            spotCell = doubleCell
        }
        if cellType == .regulatorState {
            let doubleCell = tableView.dequeueReusableCell(withIdentifier: "doubleCell") as! DoubleSpotDataCell
            doubleCell.title = "Regulator state"
            doubleCell.value = Double(spotState.regulatorState.rawValue)
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


// MARK: - cells

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
