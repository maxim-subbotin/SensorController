//
//  ConvectotParametersView.swift
//  WifiScanner
//
//  Created on 3/2/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

/*
 types.append(ParameterType(withType: .regulatorBehaviourInShutdown, andTitle: "Regulator shutdown mode"))
 types.append(ParameterType(withType: .displayBrightness, andTitle: "Display brightness"))
 types.append(ParameterType(withType: .temperatureSensorCalibration, andTitle: "Temperature sensor calibration"))
 types.append(ParameterType(withType: .fanWorkModeInShutdown, andTitle: "Valve shutdown mode"))
 types.append(ParameterType(withType: .ventilationMode, andTitle: "Ventilation mode"))
 types.append(ParameterType(withType: .autoFanSpeedGraph, andTitle: "Auto regulation graph"))
 types.append(ParameterType(withType: .reactionTimeOnTemperature, andTitle: "Temperature reaction time"))
 types.append(ParameterType(withType: .maxFanSpeedLimit, andTitle: "Max fan speed limit"))
 types.append(ParameterType(withType: .buttonBlockMode, andTitle: "Buttons block mode"))
 types.append(ParameterType(withType: .brightnessDimmingOnSleep, andTitle: "Brightness dimming"))
 types.append(ParameterType(withType: .temperatureStepInSleepMode, andTitle: "Temperature step for Sleep mode"))
 types.append(ParameterType(withType: .weekProgramMode, andTitle: "Week programming mode"))
 types.append(ParameterType(withType: .defaultSettings, andTitle: "Default settings"))
 */

class ConvectorParametersView: UIView {
    private var lblParams = UILabel()
    private var fanModeView = ConvectorFanModeParamView()
    private var controlSequenceView = ConvectorCheckboxSetView()
    private var regulatorShutdownModeView = ConvectorCheckboxSetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblParams)
        lblParams.text = "Parameters"
        lblParams.textColor = .white
        lblParams.font = UIFont.customFont(bySize: 25)
        lblParams.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblParams.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
        let lC = lblParams.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC = lblParams.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC = lblParams.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        let separator = UIView()
        self.addSubview(separator)
        separator.backgroundColor = .white
        separator.alpha = 0.5
        separator.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = separator.topAnchor.constraint(equalTo: lblParams.bottomAnchor, constant: 15)
        let lC1 = separator.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC1 = separator.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: -20)
        let hC1 = separator.heightAnchor.constraint(equalToConstant: 2)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        
        self.addSubview(fanModeView)
        fanModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = fanModeView.topAnchor.constraint(equalTo: separator.topAnchor, constant: 35)
        let lC2 = fanModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC2 = fanModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC2 = fanModeView.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        
        self.addSubview(controlSequenceView)
        controlSequenceView.title = "Control sequence"
        controlSequenceView.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = controlSequenceView.topAnchor.constraint(equalTo: fanModeView.bottomAnchor, constant: 35)
        let lC3 = controlSequenceView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC3 = controlSequenceView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC3 = controlSequenceView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        controlSequenceView.items =
         [ValueSelectorItem(withTitle: "Only heat", andValue: ControlSequenceType.onlyHeat),
         ValueSelectorItem(withTitle: "Only cold", andValue: ControlSequenceType.onlyCold),
         ValueSelectorItem(withTitle: "Heat and cold", andValue: ControlSequenceType.heatAndCold)]
        
        self.addSubview(regulatorShutdownModeView)
        regulatorShutdownModeView.title = "Regulator shutdown mode"
        regulatorShutdownModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = regulatorShutdownModeView.topAnchor.constraint(equalTo: controlSequenceView.bottomAnchor, constant: 35)
        let lC4 = regulatorShutdownModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC4 = regulatorShutdownModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC4 = regulatorShutdownModeView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        regulatorShutdownModeView.items = [ValueSelectorItem(withTitle: "Full shutdown", andValue: RegulatorShutdownWorkType.fullShutdown),
        ValueSelectorItem(withTitle: "Partial shutdown", andValue: RegulatorShutdownWorkType.fullShutdown)]
    }
}

class ConvectorFanModeParamView: UIView {
    private var lblTitle = UILabel()
    private var btnManual = UIButton()
    private var btnAuto = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(lblTitle)
        lblTitle.text = "Fan control mode"
        lblTitle.textColor = .white
        lblTitle.font = UIFont.customFont(bySize: 21)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(btnManual)
        btnManual.translatesAutoresizingMaskIntoConstraints = false
        btnManual.layer.cornerRadius = 15
        btnManual.backgroundColor = .white
        btnManual.setTitleColor(UIColor(hexString: "#009CDF"), for: .normal)
        btnManual.setTitle("Manual", for: .normal)
        btnManual.titleLabel?.font = UIFont.customFont(bySize: 21)
        btnManual.clipsToBounds = true
        let tC1 = btnManual.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC1 = btnManual.leftAnchor.constraint(equalTo: lblTitle.leftAnchor, constant: 0)
        let wC1 = btnManual.widthAnchor.constraint(equalTo: lblTitle.widthAnchor, multiplier: 0.5, constant: -10)
        let hC1 = btnManual.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        btnManual.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        
        self.addSubview(btnAuto)
        btnAuto.translatesAutoresizingMaskIntoConstraints = false
        btnAuto.layer.cornerRadius = 15
        btnAuto.layer.borderColor = UIColor.white.cgColor
        btnAuto.layer.borderWidth = 2
        btnAuto.backgroundColor = .clear
        btnAuto.setTitleColor(UIColor.white, for: .normal)
        btnAuto.setTitle("Auto", for: .normal)
        btnAuto.titleLabel?.font = UIFont.customFont(bySize: 21)
        btnAuto.clipsToBounds = true
        let tC2 = btnAuto.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC2 = btnAuto.rightAnchor.constraint(equalTo: lblTitle.rightAnchor, constant: 0)
        let wC2 = btnAuto.widthAnchor.constraint(equalTo: lblTitle.widthAnchor, multiplier: 0.5, constant: -10)
        let hC2 = btnAuto.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        btnAuto.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
    }
    
    @objc func onButtonTap(_ button: UIButton) {
        if button == btnManual {
            selectButton(btnManual)
            deselectButton(btnAuto)
        } else {
            selectButton(btnAuto)
            deselectButton(btnManual)
        }
    }
    
    func selectButton(_ button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(UIColor(hexString: "#009CDF"), for: .normal)
    }
    
    func deselectButton(_ button: UIButton) {
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.white, for: .normal)
    }
}

class ConvectorCheckboxView: UIView {
    private var _selected = false
    public var selected: Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = CGFloat(2)
        let r = (min(rect.width, rect.height) - width) / 2
        let path = UIBezierPath(ovalIn: CGRect(x: self.frame.width / 2 - r, y: self.frame.height / 2 - r, width: 2 * r, height: 2 * r))
        path.lineWidth = width
        UIColor.white.setStroke()
        path.stroke()
    }
}

class ConvectorCheckboxLabeledView: UIView {
    private var cbxValue = ConvectorCheckboxView()
    private var label = UILabel()
    public var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.addSubview(label)
        label.text = ""
        label.textColor = .white
        label.font = UIFont.customFont(bySize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        let tC = label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC = label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = label.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = label.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(cbxValue)
        cbxValue.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = cbxValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC1 = cbxValue.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC1 = cbxValue.widthAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        let hC1 = cbxValue.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
    }
}

class ConvectorCheckboxSetView: UIView {
    private var lblTitle = UILabel()
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    private var _items = [ValueSelectorItem]()
    public var items: [ValueSelectorItem] {
        get {
            return _items
        }
        set {
            _items = newValue
            applyItems(_items)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.addSubview(lblTitle)
        lblTitle.text = ""
        lblTitle.textColor = .white
        lblTitle.font = UIFont.customFont(bySize: 21)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
    }
    
    func applyItems(_ items: [ValueSelectorItem]) {
        for s in self.subviews {
            if s is ConvectorCheckboxView {
                s.removeFromSuperview()
            }
        }
        
        let h = CGFloat(25)
        let offset = CGFloat(15)
        var prevView: UIView?
        for item in _items {
            let checkbox = ConvectorCheckboxLabeledView()
            checkbox.title = item.title
            //checkbox.backgroundColor = .yellow
            
            self.addSubview(checkbox)
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            let tC = prevView == nil ? checkbox.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: offset) : checkbox.topAnchor.constraint(equalTo: prevView!.bottomAnchor, constant: offset)
            let lC = checkbox.leftAnchor.constraint(equalTo: self.leftAnchor)
            let wC = checkbox.widthAnchor.constraint(equalTo: self.widthAnchor)
            let hC = checkbox.heightAnchor.constraint(equalToConstant: h)
            NSLayoutConstraint.activate([tC, lC, wC, hC])
            
            prevView = checkbox
        }
    }
}
