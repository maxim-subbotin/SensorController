//
//  ConvectorViewController.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ConvectorViewController: UIViewController, SelectedButtonDelegate, ConvectorBottomPanelDelegate, ConvectorManualViewDelegate {
    private var lblTitle = UILabel()
    private var dateView = ConvectorDateTimeView()
    private var bottomPanel = ConvectorBottomPanel()
    private var temperatureView = ConvectorManualView()
    private var fanView = ConvectorManualView()
    private var btnFan = ConvectorBottomButton()
    private var btnTemperature = ConvectorBottomButton()
    private var parametersView = ConvectorParametersView()
    private var weeklyProgrammingView = ConvectorWeeklyProgrammingView()
    private var sleepView = ConvectorSleepView()
    private var lblAuto = UILabel()
    public var spot = Spot()
    public var spotState = SpotState.demo
    public var lblTurnedOff = UILabel()
    
    public var mode = SpotViewMode.prod
    private var connector: Connector?
    
    private var prevColor = UIColor(hexString: "#009CDF")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#009CDF")
        
        applyUI()
        
        if mode == .demo {
            return
        }
        
        if let ip = Tools.getIPAddress() {
            print("Current ip address: \(ip)")
            if let wifiIP = Tools.getWifiAddredd(byCurrentAddress: ip) {
                /*connector = Connector()
                connector?.idAddress = wifiIP
                connector?.delegate = self
                connector?.getAllData()*/
                ModbusCenter.shared.ip = wifiIP
                ModbusCenter.shared.getAllData()
                
                NotificationCenter.default.addObserver(self, selector: #selector(onModbusResponse(_:)), name: .modbusResponse, object: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applyUI() {
        self.view.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12)
        let cxC = lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC, cxC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor(hexString: "#88FFFFFF")
        lblTitle.textColor = .white
        lblTitle.text = spot.name
        lblTitle.font = UIFont.customFont(bySize: 26)
        
        self.view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = dateView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 15)
        let cxC1 = dateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC1 = dateView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC1 = dateView.heightAnchor.constraint(equalToConstant: 75)
        NSLayoutConstraint.activate([tC1, cxC1, wC1, hC1])
        dateView.date = spotState.date
        
        self.view.addSubview(bottomPanel)
        bottomPanel.delegate = self
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = bottomPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5)
        let cxC2 = bottomPanel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC2 = UIDevice.current.isiPad ? bottomPanel.widthAnchor.constraint(equalToConstant: 400) : bottomPanel.widthAnchor.constraint(equalToConstant: 280)
        let hC2 = bottomPanel.heightAnchor.constraint(equalToConstant: UIDevice.current.isiPad ? 60 : 50)
        NSLayoutConstraint.activate([tC2, cxC2, wC2, hC2])
        
        self.view.addSubview(temperatureView)
        temperatureView.delegate = self
        temperatureView.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = temperatureView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 15)
        let cxC3 = temperatureView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC3 = temperatureView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40)
        let bC3 = temperatureView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -90)
        NSLayoutConstraint.activate([tC3, cxC3, wC3, bC3])
        temperatureView.postfix = "°"
        temperatureView.mainTitle = String(format: "%.f", spotState.temperatureCurrent)
        temperatureView.detailText = String(format: "%.f", spotState.temperatureDevice)
        
        self.view.addSubview(fanView)
        fanView.delegate = self
        fanView.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = fanView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 15)
        let cxC6 = fanView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC6 = fanView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40)
        let bC6 = fanView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -90)
        NSLayoutConstraint.activate([tC6, cxC6, wC6, bC6])
        fanView.firstValue = CGFloat(0)
        fanView.lastValue = CGFloat(100)
        fanView.postfix = "%"
        fanView.mainTitle = String(format: "%.f", spotState.fanSpeedCurrent)
        fanView.detailText = String(format: "%.f", spotState.fanSpeed)
        fanView.alpha = 0
        
        let btnOffset = CGFloat(UIDevice.current.isiPad ? 15 : 15)
        
        let btnH = CGFloat(UIDevice.current.isiPad ? 80 : 60)
        self.view.addSubview(btnFan)
        btnFan.selectImage = UIImage(named: "fan_icon_solid")
        btnFan.unselectImage = UIImage(named: "fan_icon_hollow")
        btnFan.type = .fan
        btnFan.translatesAutoresizingMaskIntoConstraints = false
        btnFan.delegate = self
        let lC4 = btnFan.leftAnchor.constraint(equalTo: self.bottomPanel.leftAnchor, constant: -btnOffset)
        let bC4 = btnFan.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -48)
        let wC4 = btnFan.widthAnchor.constraint(equalToConstant: btnH)
        let hC4 = btnFan.heightAnchor.constraint(equalToConstant: btnH)
        btnFan.refresh()
        NSLayoutConstraint.activate([bC4, lC4, wC4, hC4])
        
        self.view.addSubview(btnTemperature)
        btnTemperature.selectImage = UIImage(named: "temperature_icon_solid")
        btnTemperature.unselectImage = UIImage(named: "temperature_icon_hollow")
        btnTemperature.type = .temperature
        btnTemperature.translatesAutoresizingMaskIntoConstraints = false
        btnTemperature.delegate = self
        btnTemperature.selected = true
        let lC5 = btnTemperature.rightAnchor.constraint(equalTo: self.bottomPanel.rightAnchor, constant: btnOffset)
        let bC5 = btnTemperature.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -48)
        let wC5 = btnTemperature.widthAnchor.constraint(equalToConstant: btnH)
        let hC5 = btnTemperature.heightAnchor.constraint(equalToConstant: btnH)
        btnTemperature.refresh()
        NSLayoutConstraint.activate([bC5, lC5, wC5, hC5])
        
        self.view.addSubview(lblAuto)
        lblAuto.text = "Auto"
        lblAuto.backgroundColor = UIColor(hexString: "#009CDF")
        lblAuto.clipsToBounds = true
        lblAuto.layer.cornerRadius = 7
        lblAuto.layer.borderWidth = 2
        lblAuto.layer.borderColor = UIColor.white.cgColor
        lblAuto.font = UIFont.customFont(bySize: 35)
        lblAuto.textColor = .white
        lblAuto.textAlignment = .center
        lblAuto.translatesAutoresizingMaskIntoConstraints = false
        let cxC7 = lblAuto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let cyC7 = lblAuto.centerYAnchor.constraint(equalTo: self.fanView.bottomAnchor, constant: 0)
        cyC7.identifier = "auto_center_y"
        let wC7 = lblAuto.widthAnchor.constraint(equalToConstant: 72)
        let hC7 = lblAuto.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([cxC7, cyC7, wC7, hC7])
        lblAuto.isHidden = true
        
        self.view.addSubview(parametersView)
        parametersView.translatesAutoresizingMaskIntoConstraints = false
        let cxC8 = parametersView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let tC8 = parametersView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 0)
        let wC8 = parametersView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let bC8 = parametersView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor)
        NSLayoutConstraint.activate([bC8, cxC8, wC8, tC8])
        parametersView.backgroundColor = UIColor(hexString: "#009CDF")
        parametersView.isHidden = true
        
        self.view.addSubview(lblTurnedOff)
        lblTurnedOff.text = "TURNED OFF"
        lblTurnedOff.textAlignment = .center
        lblTurnedOff.textColor = UIColor(hexString: "#DADADA")
        lblTurnedOff.font = UIFont.customFont(bySize: 35)
        lblTurnedOff.translatesAutoresizingMaskIntoConstraints = false
        let cxC9 = lblTurnedOff.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let tC9 = lblTurnedOff.centerYAnchor.constraint(equalTo: self.fanView.centerYAnchor, constant: 0)
        let wC9 = lblTurnedOff.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let bC9 = lblTurnedOff.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([bC9, cxC9, wC9, tC9])
        lblTurnedOff.isHidden = true
        
        self.view.addSubview(weeklyProgrammingView)
        weeklyProgrammingView.translatesAutoresizingMaskIntoConstraints = false
        let cxC10 = weeklyProgrammingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let tC10 = weeklyProgrammingView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 0)
        let wC10 = weeklyProgrammingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let bC10 = weeklyProgrammingView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor)
        NSLayoutConstraint.activate([bC10, cxC10, wC10, tC10])
        weeklyProgrammingView.backgroundColor = UIColor(hexString: "#009CDF")
        weeklyProgrammingView.isHidden = true
        
        self.view.addSubview(sleepView)
        sleepView.translatesAutoresizingMaskIntoConstraints = false
        let cxC11 = sleepView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let tC11 = sleepView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 0)
        let wC11 = sleepView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let bC11 = sleepView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor)
        NSLayoutConstraint.activate([bC11, cxC11, wC11, tC11])
        sleepView.backgroundColor = UIColor(hexString: "#009CDF")
        sleepView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let fr = fanView.frame
        let r = min(fr.width, fr.height) - 60
        let dY = (fr.height - r) / 2
        var cyC = lblAuto.constraints.filter({ $0.identifier == "auto_center_y" }).first
        if cyC == nil {
            cyC = self.view.constraints.first(where: { $0.identifier == "auto_center_y" })
        }
        cyC?.constant = -dY
        lblAuto.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    //MARK: - fan/temp button delegates
    
    func onButtonSelection(_ selectedButton: SelectedButton) {
        let cButton = selectedButton as! ConvectorBottomButton
        if cButton.type == .fan {
            btnTemperature.selected = !cButton.selected
            if btnTemperature.selected {
                showTempView()
            } else {
                showFanView()
            }
        }
        if cButton.type == .temperature {
            btnFan.selected = !cButton.selected
            if btnFan.selected {
                showFanView()
            } else {
                showTempView()
            }
        }
    }
    
    func showTempView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.temperatureView.alpha = 1.0
            self.fanView.alpha = 0
            self.lblAuto.isHidden = true
        })
    }
    
    func showFanView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.temperatureView.alpha = 0.0
            self.fanView.alpha = 1
            self.lblAuto.isHidden = false
        })
    }
    
    //MARK: - bottom panel delegate
    
    func onBottomPanelAction(_ action: ConvectorBottomButtomType) {
        if bottomPanel.prevAction == nil || bottomPanel.prevAction! != .exit {
            prevColor = self.view.backgroundColor ?? UIColor(hexString: "#DADADA")
        }
        if action == .exit {
            prevColor = self.view.backgroundColor ?? UIColor(hexString: "#DADADA")
            self.view.backgroundColor = UIColor(hexString: "#DADADA")
            fanView.showContent(false)
            temperatureView.showContent(false)
            lblAuto.isHidden = true
            lblTurnedOff.isHidden = false
            btnFan.isUserInteractionEnabled = false
            btnTemperature.isUserInteractionEnabled = false
            NotificationCenter.default.post(name: ColorScheme.changeBackgroundColor, object: UIColor(hexString: "#DADADA"))
            
            ModbusCenter.shared.shutdown()
        } else {
            self.view.backgroundColor = prevColor
            fanView.showContent(true)
            temperatureView.showContent(true)
            lblAuto.isHidden = false
            lblTurnedOff.isHidden = true
            btnFan.isUserInteractionEnabled = true
            btnTemperature.isUserInteractionEnabled = true
            NotificationCenter.default.post(name: ColorScheme.changeBackgroundColor, object: prevColor)
        }
        if action == .settings {
            ModbusCenter.shared.getAdditionalData()
        }
        
        self.parametersView.isHidden = (action != .settings)
        self.weeklyProgrammingView.isHidden = (action != .calendar)
        self.sleepView.isHidden = (action != .vacation)
    }
    
    //MARK: - fan/temp changes
    
    func onFinalValueChanged(_ view: ConvectorManualView) {
        onManualValueChanged(view)
        
        if view == temperatureView {
            let d = round(Double(view.value))
            ModbusCenter.shared.setDeviceTemperature(d)
        }
        if view == fanView {
            ModbusCenter.shared.setFanSpeed(Double(view.value))
        }
    }
    
    func onManualValueChanged(_ view: ConvectorManualView) {
        if view == temperatureView {
            let val = view.value
            let d = (val - 5.0) / 40
            //009CDF -> 0, 156, 223
            //FFA621 -> 255, 166, 33
            //DF3600 -> 223, 54, 0
            var color: UIColor?
            if d <= 0.5 {
                let r = 2 * d * 255
                let g = 156 + d * (166 - 156) * 2
                let b = 223 + d * (33 - 223) * 2
                color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
            } else {
                let r = 255 + (d - 0.5) * (223 - 255) * 2
                let g = 166 + (d - 0.5) * (54 - 166) * 2
                let b = 33 + (d - 0.5) * (0 - 33) * 2
                color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
            }
            
            self.view.backgroundColor = color
            parametersView.backgroundColor = color
            lblAuto.backgroundColor = color
            NotificationCenter.default.post(name: ColorScheme.changeBackgroundColor, object: color)
        }
    }
    
    func applySpotState(_ spotState: SpotState) {
        self.temperatureView.value = CGFloat(spotState.temperatureDevice)
        self.temperatureView.mainTitle = String(format: "%.f", spotState.temperatureDevice)
        self.temperatureView.detailText = String(format: "%.1f", spotState.temperatureCurrent)
        self.dateView.date = spotState.date
        
        self.fanView.value = CGFloat(spotState.fanSpeed)
        self.fanView.mainTitle = String(format: "%.f", spotState.fanSpeed)
        self.fanView.detailText = String(format: "%.1f", spotState.fanSpeedCurrent)
        
        let d = (CGFloat(spotState.temperatureDevice) - 5.0) / 40
        let color = ConvectorManualView.color(byValue: d)
        self.view.backgroundColor = color
        parametersView.backgroundColor = color
        lblAuto.backgroundColor = color
        NotificationCenter.default.post(name: ColorScheme.changeBackgroundColor, object: color)
    }
    
    //MARK: - auto
    
    //MARK: - connection delegate
    
    @objc func onModbusResponse(_ notification: NSNotification) {
        if notification.object != nil && notification.object is ModbusResponse {
            let response = notification.object as! ModbusResponse
            if response.error != nil {
                
            } else if response.data != nil {
                print("Command result was received. Command = \(response.command)")
                if response.command == .allData {
                    DispatchQueue.main.async {
                        self.spotState = SpotState.parseData(response.data as! [Int])
                        self.applySpotState(self.spotState)
                        if self.spotState.regulatorState == .off {
                            ModbusCenter.shared.turnOn()
                        }
                    }
                }
                if response.command == .additionalData {
                    DispatchQueue.main.async {
                        self.spotState.additionalParams = SpotState.parseAdditionalData(response.data as! [Int])
                        self.parametersView.spotState = self.spotState
                    }
                }
            }
        }
    }
}
