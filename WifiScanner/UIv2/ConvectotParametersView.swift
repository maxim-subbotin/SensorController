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

class ConvectorParametersView: UIScrollView {
    private var lblParams = UILabel()
    private var fanModeView = ConvectorFanModeParamView()
    private var controlSequenceView = ConvectorCheckboxSetView()
    private var regulatorShutdownModeView = ConvectorCheckboxSetView()
    private var valveShutdownModeView = ConvectorCheckboxSetView()
    private var ventilationModeView = ConvectorSwitchView()
    private var fanSpeedGraphView = ConvectorCheckboxSetView()
    private var temperatureReactionTime = ConvectorTrackBarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.clipsToBounds = true
        
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
        controlSequenceView.title = "Control sequence:"
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
        regulatorShutdownModeView.title = "Regulator shutdown mode:"
        regulatorShutdownModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = regulatorShutdownModeView.topAnchor.constraint(equalTo: controlSequenceView.bottomAnchor, constant: 35)
        let lC4 = regulatorShutdownModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC4 = regulatorShutdownModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC4 = regulatorShutdownModeView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        regulatorShutdownModeView.items = [ValueSelectorItem(withTitle: "Full shutdown", andValue: RegulatorShutdownWorkType.fullShutdown),
        ValueSelectorItem(withTitle: "Partial shutdown", andValue: RegulatorShutdownWorkType.fullShutdown)]
        
        self.addSubview(valveShutdownModeView)
        valveShutdownModeView.title = "Valve shutdown mode:"
        valveShutdownModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC5 = valveShutdownModeView.topAnchor.constraint(equalTo: regulatorShutdownModeView.bottomAnchor, constant: 35)
        let lC5 = valveShutdownModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC5 = valveShutdownModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC5 = valveShutdownModeView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([tC5, lC5, wC5, hC5])
        valveShutdownModeView.items = [ValueSelectorItem(withTitle: "Full shutdown", andValue: RegulatorShutdownWorkType.fullShutdown),
        ValueSelectorItem(withTitle: "Partial shutdown", andValue: RegulatorShutdownWorkType.fullShutdown)]
        
        self.addSubview(ventilationModeView)
        ventilationModeView.title = "Ventilation mode:"
        ventilationModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = ventilationModeView.topAnchor.constraint(equalTo: valveShutdownModeView.bottomAnchor, constant: 35)
        let lC6 = ventilationModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC6 = ventilationModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC6 = ventilationModeView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC6, lC6, wC6, hC6])
        
        self.addSubview(fanSpeedGraphView)
        fanSpeedGraphView.title = "Valve shutdown mode:"
        fanSpeedGraphView.translatesAutoresizingMaskIntoConstraints = false
        let tC7 = fanSpeedGraphView.topAnchor.constraint(equalTo: ventilationModeView.bottomAnchor, constant: 35)
        let lC7 = fanSpeedGraphView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC7 = fanSpeedGraphView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC7 = fanSpeedGraphView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC7, lC7, wC7, hC7])
        fanSpeedGraphView.items = [ValueSelectorItem(withTitle: "Graph 1", andValue: AutoFanSpeedGraphType.graph1),
                                   ValueSelectorItem(withTitle: "Graph 2", andValue: AutoFanSpeedGraphType.graph2),
                                   ValueSelectorItem(withTitle: "Graph 3", andValue: AutoFanSpeedGraphType.graph3)]
        
        self.addSubview(temperatureReactionTime)
        temperatureReactionTime.title = "Temperature reaction time:"
        temperatureReactionTime.translatesAutoresizingMaskIntoConstraints = false
        let tC8 = temperatureReactionTime.topAnchor.constraint(equalTo: fanSpeedGraphView.bottomAnchor, constant: 35)
        let lC8 = temperatureReactionTime.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC8 = temperatureReactionTime.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC8 = temperatureReactionTime.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC8, lC8, wC8, hC8])
        temperatureReactionTime.value = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = CGSize(width: self.frame.width, height: 1200)
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

class ConvectorSwitchView: UIView {
    private var lblTitle = UILabel()
    private var lblDetail = UILabel()
    private var slider = UISwitch()
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    private var _enabled = false
    public var enabled: Bool {
        get {
            return _enabled
        }
        set {
            _enabled = newValue
            slider.isOn = _enabled
        }
    }
    public var positiveTitle = "Enabled"
    public var negativeTitle = "Disabled"
    
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
        let hC = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(lblDetail)
        lblDetail.text = negativeTitle
        lblDetail.textColor = UIColor(hexString: "#DADADA")
        lblDetail.font = UIFont.customFont(bySize: 18)
        lblDetail.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblDetail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0)
        let lC1 = lblDetail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC1 = lblDetail.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC1 = lblDetail.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        
        self.addSubview(slider)
        //slider.thumbTintColor = .red
        //slider.tintColor = .yellow
        //lblDetail.text = "Disabled"
        //lblDetail.textColor = UIColor(hexString: "#DADADA")
        //lblDetail.font = UIFont.customFont(bySize: 18)
        slider.onTintColor = UIColor(hexString: "#31221F1F")
        slider.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = slider.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC2 = slider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC2 = slider.widthAnchor.constraint(equalToConstant: 50)
        let hC2 = slider.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        slider.addTarget(self, action: #selector(onSwitchChange), for: .valueChanged)
    }
    
    @objc func onSwitchChange() {
        _enabled = slider.isOn
        lblDetail.text = _enabled ? positiveTitle : negativeTitle
    }
}

class ConvectorPlusMinusView: UIView {
    private var btnPlus = UIButton()
    private var btnMinus = UIButton()
    private var lblTitle = UILabel()
    public var postfix = "sec"
    private var _value = 0
    public var value: Int {
        get {
            return _value
        }
        set {
            _value = newValue
            lblTitle.text = "\(_value) \(postfix)"
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
        self.isUserInteractionEnabled = true
        
        self.addSubview(btnMinus)
        btnMinus.setImage(UIImage(named: "minus_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnMinus.tintColor = .white
        btnMinus.translatesAutoresizingMaskIntoConstraints = false
        let tC = btnMinus.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC = btnMinus.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = btnMinus.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        let hC = btnMinus.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        btnMinus.addTarget(self, action: #selector(onMinus), for: .touchUpInside)
        
        self.addSubview(btnPlus)
        btnPlus.setImage(UIImage(named: "plus_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPlus.tintColor = .white
        btnPlus.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = btnPlus.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC1 = btnPlus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC1 = btnPlus.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        let hC1 = btnPlus.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        btnPlus.addTarget(self, action: #selector(onPlus), for: .touchUpInside)
        
        self.addSubview(lblTitle)
        lblTitle.text = ""
        lblTitle.textColor = .white
        lblTitle.font = UIFont.customFont(bySize: 50)
        lblTitle.textAlignment = .center
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC2 = lblTitle.leftAnchor.constraint(equalTo: btnMinus.rightAnchor, constant: 0)
        let wC2 = lblTitle.rightAnchor.constraint(equalTo: btnPlus.leftAnchor, constant: 0)
        let hC2 = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
    }
    
    @objc func onPlus() {
        self.value += 1
    }
    
    @objc func onMinus() {
        self.value -= 1
    }
}

class ConvectorPinView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let w = CGFloat(12)
        let path = UIBezierPath(ovalIn: CGRect(x: rect.width / 2 - w / 2, y: rect.height / 2 - w / 2, width: w, height: w))
        UIColor.white.setFill()
        path.fill()
    }
}

class ConvectorSliderView: UIView {
    private var pinView = ConvectorPinView()
    private var _value = CGFloat(0.5)
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            setNeedsDisplay()
        }
    }
    public var activeColor = UIColor.white
    public var inactiveColor = UIColor(hexString: "#50FFFFFF")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.isOpaque = false
        
        self.addSubview(pinView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = CGFloat(2)
        let path1 = UIBezierPath(roundedRect: CGRect(x: 0, y: rect.height / 2 - width / 2, width: rect.width * _value, height: width), cornerRadius: width / 2)
        activeColor.setFill()
        path1.fill()
        
        let path2 = UIBezierPath(roundedRect: CGRect(x: rect.width * _value, y: rect.height / 2 - width / 2, width: rect.width * (1 - _value), height: width), cornerRadius: width / 2)
        inactiveColor.setFill()
        path2.fill()
        
        let w = rect.height
        pinView.frame = CGRect(x: rect.width / 2 - w / 2, y: 0, width: w, height: w)
    }
    
}

class ConvectorTrackBarView: UIView {
    private var lblTitle = UILabel()
    private var plusBar = ConvectorPlusMinusView()
    private var slider = ConvectorSliderView()
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    public var value: Int {
        get {
            return plusBar.value
        }
        set {
            plusBar.value = newValue
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
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 24)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(plusBar)
        plusBar.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = plusBar.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC1 = plusBar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = plusBar.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60)
        let hC1 = plusBar.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        
        self.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = slider.topAnchor.constraint(equalTo: plusBar.bottomAnchor, constant: 15)
        let lC2 = slider.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = slider.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC2 = slider.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
    }
    
    func onDragAction(_ gesture: UIPanGestureRecognizer) {
        
    }
}
