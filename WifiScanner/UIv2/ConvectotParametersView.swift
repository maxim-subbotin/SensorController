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

class ConvectorParametersView: UIScrollView, ConvectorTwoValParamViewDelegate, ConvectorTrackBarViewDelegate, ConvectorCheckboxSetViewDelegate, ConvectorSwitchViewDelegate {
    public weak var parentViewController: UIViewController?
    private var lblParams = UILabel()
    private var fanModeView = ConvectorTwoValParamView()
    private var controlSequenceView = ConvectorCheckboxSetView()
    private var regulatorShutdownModeView = ConvectorCheckboxSetView()
    private var valveShutdownModeView = ConvectorCheckboxSetView()
    private var ventilationModeView = ConvectorSwitchView()
    private var fanSpeedGraphView = ConvectorCheckboxSetView()
    private var temperatureReactionTime = ConvectorTrackBarView()
    private var maxFanSpeedView = ConvectorTrackBarView()
    private var tempStepSleepModeView = ConvectorTrackBarView()
    private var weekProgramModeView = ConvectorCheckboxSetView()
    private var lblIndicationModes = UILabel()
    private var displayBrightnessView = ConvectorTrackBarView()
    private var brightDimmingView = ConvectorTwoValParamView()
    private var lblOther = UILabel()
    private var sensorCalibrationView = ConvectorTrackBarView()
    private var blockModeView = ConvectorCheckboxSetView()
    private var lblDefault = UILabel()
    private var btnDefault = UIButton()
    private var lblVersion = UILabel()
    private var _spotState = SpotState()
    public var spotState: SpotState {
        get {
            return _spotState
        }
        set {
            _spotState = newValue
            self.fanModeView.selectionIndex = _spotState.fanMode == .manual ? 0 : 1
            if let obj = _spotState.additionalParams[.controlSequence] {
                let seq = obj as! ControlSequenceType
                self.controlSequenceView.value = seq
            }
            if let obj = _spotState.additionalParams[.brightnessDimmingOnSleep] {
                let dim = obj as! BrightnessDimmingOnSleepType
                self.brightDimmingView.selectionIndex = dim == .yes ? 0 : 1
            }
            if let obj = _spotState.additionalParams[.reactionTimeOnTemperature] {
                let time = obj as! Int
                self.temperatureReactionTime.value = time
            }
            if let obj = _spotState.additionalParams[.maxFanSpeedLimit] {
                let time = obj as! Int
                self.maxFanSpeedView.value = time
            }
            if let obj = _spotState.additionalParams[.temperatureStepInSleepMode] {
                let time = obj as! Int
                self.tempStepSleepModeView.value = time
            }
            if let obj = _spotState.additionalParams[.displayBrightness] {
                let time = obj as! Int
                self.displayBrightnessView.value = time
            }
            if let obj = _spotState.additionalParams[.temperatureSensorCalibration] {
                let time = obj as! Double
                self.sensorCalibrationView.value = Int(time)
            }
            if let obj = _spotState.additionalParams[.controlSequence] {
                let seq = obj as! ControlSequenceType
                self.controlSequenceView.value = seq
            }
            if let obj = _spotState.additionalParams[.regulatorBehaviourInShutdown] {
                let beh = obj as! RegulatorShutdownWorkType
                self.regulatorShutdownModeView.value = beh
            }
            if let obj = _spotState.additionalParams[.fanWorkModeInShutdown] {
                let beh = obj as! FanShutdownWorkType
                self.valveShutdownModeView.value = beh
            }
            if let obj = _spotState.additionalParams[.autoFanSpeedGraph] {
                let g = obj as! AutoFanSpeedGraphType
                self.fanSpeedGraphView.value = g
            }
            if let obj = _spotState.additionalParams[.weekProgramMode] {
                let w = obj as! WeekProgramMode
                self.weekProgramModeView.value = w
            }
            if let obj = _spotState.additionalParams[.buttonBlockMode] {
                let w = obj as! ButtonBlockMode
                self.blockModeView.value = w
            }
            if let obj = _spotState.additionalParams[.ventilationMode] {
                let m = obj as! VentilationMode
                self.ventilationModeView.enabled = m == .turnOn
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onModbusResponse(_:)), name: .modbusResponse, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applyUI() {
        self.clipsToBounds = true
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblParams)
        lblParams.text = Localization.main.parameters
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
        fanModeView.delegate = self
        fanModeView.title = Localization.main.fanControlMode
        fanModeView.param1Name = Localization.main.manualMode
        fanModeView.param2Name = Localization.main.autoMode
        fanModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = fanModeView.topAnchor.constraint(equalTo: separator.topAnchor, constant: 35)
        let lC2 = fanModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC2 = fanModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC2 = fanModeView.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        
        self.addSubview(controlSequenceView)
        controlSequenceView.delegate = self
        controlSequenceView.title = Localization.main.controlSequence
        controlSequenceView.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = controlSequenceView.topAnchor.constraint(equalTo: fanModeView.bottomAnchor, constant: 35)
        let lC3 = controlSequenceView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC3 = controlSequenceView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC3 = controlSequenceView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        controlSequenceView.items =
            [ValueSelectorItem(withTitle: Localization.main.onlyHeat, andValue: ControlSequenceType.onlyHeat),
             ValueSelectorItem(withTitle: Localization.main.onlyCold, andValue: ControlSequenceType.onlyCold),
             ValueSelectorItem(withTitle: Localization.main.heatAndCold, andValue: ControlSequenceType.heatAndCold)]
        
        self.addSubview(regulatorShutdownModeView)
        var h = CGFloat(120)
        if !Tools.isiPad && Tools.isRussian {
            regulatorShutdownModeView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        regulatorShutdownModeView.delegate = self
        regulatorShutdownModeView.title = Localization.main.regulatorShutdownMode
        regulatorShutdownModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = regulatorShutdownModeView.topAnchor.constraint(equalTo: controlSequenceView.bottomAnchor, constant: 35)
        let lC4 = regulatorShutdownModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC4 = regulatorShutdownModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC4 = regulatorShutdownModeView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        regulatorShutdownModeView.items = [ValueSelectorItem(withTitle: Localization.main.fullShutdown, andValue: RegulatorShutdownWorkType.fullShutdown),
                                           ValueSelectorItem(withTitle: Localization.main.partialShutdown, andValue: RegulatorShutdownWorkType.partialShutdown)]
        
        self.addSubview(valveShutdownModeView)
        h = CGFloat(120)
        if !Tools.isiPad && Tools.isRussian {
            valveShutdownModeView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        valveShutdownModeView.delegate = self
        valveShutdownModeView.title = Localization.main.valveShutdownMode
        valveShutdownModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC5 = valveShutdownModeView.topAnchor.constraint(equalTo: regulatorShutdownModeView.bottomAnchor, constant: 35)
        let lC5 = valveShutdownModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC5 = valveShutdownModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC5 = valveShutdownModeView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC5, lC5, wC5, hC5])
        valveShutdownModeView.items = [ValueSelectorItem(withTitle: Localization.main.fullShutdown, andValue: FanShutdownWorkType.valveClosed),
                                       ValueSelectorItem(withTitle: Localization.main.partialShutdown, andValue: FanShutdownWorkType.valveOpened)]
        
        self.addSubview(ventilationModeView)
        ventilationModeView.delegate = self
        ventilationModeView.title = Localization.main.ventilationMode
        ventilationModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = ventilationModeView.topAnchor.constraint(equalTo: valveShutdownModeView.bottomAnchor, constant: 35)
        let lC6 = ventilationModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC6 = ventilationModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC6 = ventilationModeView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC6, lC6, wC6, hC6])
        
        self.addSubview(fanSpeedGraphView)
        fanSpeedGraphView.delegate = self
        fanSpeedGraphView.title = Localization.main.fanSpeedGraph
        fanSpeedGraphView.translatesAutoresizingMaskIntoConstraints = false
        let tC7 = fanSpeedGraphView.topAnchor.constraint(equalTo: ventilationModeView.bottomAnchor, constant: 35)
        let lC7 = fanSpeedGraphView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC7 = fanSpeedGraphView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC7 = fanSpeedGraphView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC7, lC7, wC7, hC7])
        fanSpeedGraphView.items = [ValueSelectorItem(withTitle: Localization.main.graph1, andValue: AutoFanSpeedGraphType.graph1),
                                   ValueSelectorItem(withTitle: Localization.main.graph2, andValue: AutoFanSpeedGraphType.graph2),
                                   ValueSelectorItem(withTitle: Localization.main.graph3, andValue: AutoFanSpeedGraphType.graph3)]
        
        self.addSubview(temperatureReactionTime)
        h = CGFloat(160)
        if !Tools.isiPad && Tools.isRussian {
            temperatureReactionTime.titleLinesNumber = 2
            h += CGFloat(25)
        }
        temperatureReactionTime.delegate = self
        temperatureReactionTime.title = Localization.main.temperatureReactionTime
        temperatureReactionTime.translatesAutoresizingMaskIntoConstraints = false
        let tC8 = temperatureReactionTime.topAnchor.constraint(equalTo: fanSpeedGraphView.bottomAnchor, constant: 35)
        let lC8 = temperatureReactionTime.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC8 = temperatureReactionTime.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC8 = temperatureReactionTime.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC8, lC8, wC8, hC8])
        temperatureReactionTime.minValue = 1
        temperatureReactionTime.maxValue = 300
        temperatureReactionTime.value = 5
        temperatureReactionTime.postfix = Localization.main.sec
        
        self.addSubview(maxFanSpeedView)
        h = CGFloat(160)
        if !Tools.isiPad && Tools.isRussian {
            maxFanSpeedView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        maxFanSpeedView.delegate = self
        maxFanSpeedView.postfix = "%"
        maxFanSpeedView.title = Localization.main.maxFanSpeedLimit
        maxFanSpeedView.translatesAutoresizingMaskIntoConstraints = false
        let tC9 = maxFanSpeedView.topAnchor.constraint(equalTo: temperatureReactionTime.bottomAnchor, constant: 35)
        let lC9 = maxFanSpeedView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC9 = maxFanSpeedView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC9 = maxFanSpeedView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC9, lC9, wC9, hC9])
        maxFanSpeedView.minValue = 40
        maxFanSpeedView.maxValue = 100
        maxFanSpeedView.value = 45
        
        self.addSubview(tempStepSleepModeView)
        h = CGFloat(160)
        if !Tools.isiPad && Tools.isRussian {
            tempStepSleepModeView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        tempStepSleepModeView.delegate = self
        tempStepSleepModeView.postfix = "°"
        tempStepSleepModeView.title = Localization.main.temperatureStep
        tempStepSleepModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC10 = tempStepSleepModeView.topAnchor.constraint(equalTo: maxFanSpeedView.bottomAnchor, constant: 35)
        let lC10 = tempStepSleepModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC10 = tempStepSleepModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC10 = tempStepSleepModeView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC10, lC10, wC10, hC10])
        tempStepSleepModeView.minValue = 3
        tempStepSleepModeView.maxValue = 10
        tempStepSleepModeView.value = 5
        
        self.addSubview(weekProgramModeView)
        h = CGFloat(160)
        if !Tools.isiPad && Tools.isRussian {
            weekProgramModeView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        weekProgramModeView.delegate = self
        weekProgramModeView.title = Localization.main.weekProgrammingMode
        weekProgramModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC11 = weekProgramModeView.topAnchor.constraint(equalTo: tempStepSleepModeView.bottomAnchor, constant: 35)
        let lC11 = weekProgramModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC11 = weekProgramModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC11 = weekProgramModeView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC11, lC11, wC11, hC11])
        weekProgramModeView.items = [ValueSelectorItem(withTitle: Localization.main.disabled, andValue: WeekProgramMode.disabled),
                                     ValueSelectorItem(withTitle: Localization.main.byFanSpeed, andValue: WeekProgramMode.byFanSpeed),
                                     ValueSelectorItem(withTitle: Localization.main.byAirTemperature, andValue: WeekProgramMode.byAirTemperature)]
        
        self.addSubview(lblIndicationModes)
        lblIndicationModes.text = Localization.main.indicationMode
        lblIndicationModes.textColor = .white
        lblIndicationModes.font = UIFont.customFont(bySize: 25)
        lblIndicationModes.translatesAutoresizingMaskIntoConstraints = false
        let tC12 = lblIndicationModes.topAnchor.constraint(equalTo: weekProgramModeView.bottomAnchor, constant: 25)
        let lC12 = lblIndicationModes.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC12 = lblIndicationModes.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC12 = lblIndicationModes.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC12, lC12, wC12, hC12])
        
        let separator2 = UIView()
        self.addSubview(separator2)
        separator2.backgroundColor = .white
        separator2.alpha = 0.5
        separator2.translatesAutoresizingMaskIntoConstraints = false
        let tC13 = separator2.topAnchor.constraint(equalTo: lblIndicationModes.bottomAnchor, constant: 15)
        let lC13 = separator2.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC13 = separator2.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: -20)
        let hC13 = separator2.heightAnchor.constraint(equalToConstant: 2)
        NSLayoutConstraint.activate([tC13, lC13, wC13, hC13])
        
        self.addSubview(displayBrightnessView)
        displayBrightnessView.delegate = self
        displayBrightnessView.postfix = ""
        displayBrightnessView.title = Localization.main.displayBrightness
        displayBrightnessView.translatesAutoresizingMaskIntoConstraints = false
        let tC14 = displayBrightnessView.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 35)
        let lC14 = displayBrightnessView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC14 = displayBrightnessView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC14 = displayBrightnessView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC14, lC14, wC14, hC14])
        displayBrightnessView.minValue = 1
        displayBrightnessView.maxValue = 5
        displayBrightnessView.value = 3
        
        self.addSubview(brightDimmingView)
        brightDimmingView.delegate = self
        brightDimmingView.title = Localization.main.displayDimming
        brightDimmingView.param1Name = Localization.main.enabled
        brightDimmingView.param2Name = Localization.main.disabled
        brightDimmingView.translatesAutoresizingMaskIntoConstraints = false
        let tC15 = brightDimmingView.topAnchor.constraint(equalTo: displayBrightnessView.bottomAnchor, constant: 35)
        let lC15 = brightDimmingView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC15 = brightDimmingView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC15 = brightDimmingView.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([tC15, lC15, wC15, hC15])
        
        self.addSubview(lblOther)
        lblOther.text = Localization.main.others
        lblOther.textColor = .white
        lblOther.font = UIFont.customFont(bySize: 25)
        lblOther.translatesAutoresizingMaskIntoConstraints = false
        let tC16 = lblOther.topAnchor.constraint(equalTo: brightDimmingView.bottomAnchor, constant: 25)
        let lC16 = lblOther.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC16 = lblOther.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC16 = lblOther.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC16, lC16, wC16, hC16])
        
        let separator3 = UIView()
        self.addSubview(separator3)
        separator3.backgroundColor = .white
        separator3.alpha = 0.5
        separator3.translatesAutoresizingMaskIntoConstraints = false
        let tC17 = separator3.topAnchor.constraint(equalTo: lblOther.bottomAnchor, constant: 15)
        let lC17 = separator3.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC17 = separator3.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: -20)
        let hC17 = separator3.heightAnchor.constraint(equalToConstant: 2)
        NSLayoutConstraint.activate([tC17, lC17, wC17, hC17])

        self.addSubview(sensorCalibrationView)
        sensorCalibrationView.delegate = self
        sensorCalibrationView.postfix = "°"
        sensorCalibrationView.title = Localization.main.temperatureSensorCalibration
        sensorCalibrationView.translatesAutoresizingMaskIntoConstraints = false
        let tC18 = sensorCalibrationView.topAnchor.constraint(equalTo: separator3.bottomAnchor, constant: 35)
        let lC18 = sensorCalibrationView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC18 = sensorCalibrationView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC18 = sensorCalibrationView.heightAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([tC18, lC18, wC18, hC18])
        sensorCalibrationView.minValue = -5
        sensorCalibrationView.maxValue = 5
        sensorCalibrationView.value = 0
        
        self.addSubview(blockModeView)
        h = CGFloat(160)
        if !Tools.isiPad && Tools.isRussian {
            blockModeView.titleLinesNumber = 2
            h += CGFloat(25)
        }
        blockModeView.delegate = self
        blockModeView.title = Localization.main.buttonsBlockMode
        blockModeView.translatesAutoresizingMaskIntoConstraints = false
        let tC19 = blockModeView.topAnchor.constraint(equalTo: sensorCalibrationView.bottomAnchor, constant: 35)
        let lC19 = blockModeView.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC19 = blockModeView.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: 0)
        let hC19 = blockModeView.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([tC19, lC19, wC19, hC19])
        blockModeView.items = [ValueSelectorItem(withTitle: Localization.main.blockModeManual, andValue: ButtonBlockMode.manual),
                               ValueSelectorItem(withTitle: Localization.main.blockModeAuto, andValue: ButtonBlockMode.auto),
                               ValueSelectorItem(withTitle: Localization.main.blockModeForbid, andValue: ButtonBlockMode.forbid)]
        
        self.addSubview(lblDefault)
        lblDefault.text = Localization.main.defaultSettings
        lblDefault.textColor = .white
        lblDefault.font = UIFont.customFont(bySize: 21)
        lblDefault.translatesAutoresizingMaskIntoConstraints = false
        let tC20 = lblDefault.topAnchor.constraint(equalTo: blockModeView.bottomAnchor, constant: 25)
        let lC20 = lblDefault.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC20 = lblDefault.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC20 = lblDefault.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC20, lC20, wC20, hC20])
        
        self.addSubview(btnDefault)
        btnDefault.translatesAutoresizingMaskIntoConstraints = false
        btnDefault.layer.cornerRadius = 15
        btnDefault.setTitle(Localization.main.reset, for: .normal)
        btnDefault.setTitleColor(UIColor(hexString: "#F0F0F0"), for: .highlighted)
        btnDefault.titleLabel?.font = UIFont.customFont(bySize: 21)
        btnDefault.clipsToBounds = true
        btnDefault.layer.borderColor = UIColor.white.cgColor
        btnDefault.layer.borderWidth = 2
        btnDefault.backgroundColor = .clear
        btnDefault.setTitleColor(UIColor.white, for: .normal)
        let tC21 = btnDefault.topAnchor.constraint(equalTo: lblDefault.bottomAnchor, constant: 15)
        let lC21 = btnDefault.leftAnchor.constraint(equalTo: lblDefault.leftAnchor, constant: 0)
        let wC21 = btnDefault.widthAnchor.constraint(equalToConstant: 150)
        let hC21 = btnDefault.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC21, lC21, wC21, hC21])
        btnDefault.addTarget(self, action: #selector(onDefaultButton), for: .touchUpInside)
        
        let separator4 = UIView()
        self.addSubview(separator4)
        separator4.backgroundColor = .white
        separator4.alpha = 0.5
        separator4.translatesAutoresizingMaskIntoConstraints = false
        let tC22 = separator4.topAnchor.constraint(equalTo: btnDefault.bottomAnchor, constant: 15)
        let lC22 = separator4.leftAnchor.constraint(equalTo: lblParams.leftAnchor, constant: 0)
        let wC22 = separator4.widthAnchor.constraint(equalTo: lblParams.widthAnchor, constant: -20)
        let hC22 = separator4.heightAnchor.constraint(equalToConstant: 2)
        NSLayoutConstraint.activate([tC22, lC22, wC22, hC22])
        
        self.addSubview(lblVersion)
        lblVersion.text = "\(Localization.main.version): "
        lblVersion.textColor = .white
        lblVersion.font = UIFont.customFont(bySize: 21)
        lblVersion.translatesAutoresizingMaskIntoConstraints = false
        let tC23 = lblVersion.topAnchor.constraint(equalTo: separator4.bottomAnchor, constant: 25)
        let lC23 = lblVersion.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC23 = lblVersion.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC23 = lblVersion.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC23, lC23, wC23, hC23])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var h = CGFloat(2800)
        if !Tools.isiPad && Tools.isRussian {
            h += 150
        }
        self.contentSize = CGSize(width: self.frame.width, height: h)
    }
    
    //MARK: - two val triggers
    
    func onParamSelection(view: ConvectorTwoValParamView, number n: Int) {
        if view == fanModeView {
            ModbusCenter.shared.setFanMode(n == 0 ? .manual : .auto)
        }
        if view == brightDimmingView {
            ModbusCenter.shared.setBrightnessDimming(n == 0 ? .yes : .no)
        }
    }
    
    //MARK: - track bar delegate
    
    func onParameterChange(view: ConvectorTrackBarView, value: Int) {
        if view == self.temperatureReactionTime {
            ModbusCenter.shared.setTemperatureReactionTime(view.value)
        }
        if view == self.maxFanSpeedView {
            ModbusCenter.shared.setMaxFanSpeedLimit(view.value)
        }
        if view == self.tempStepSleepModeView {
            ModbusCenter.shared.setTemperatureStepSleepMode(view.value)
        }
        if view == self.displayBrightnessView {
            ModbusCenter.shared.setDisplayBrightness(view.value)
        }
        if view == self.sensorCalibrationView {
            if view.value >= 0 {
                ModbusCenter.shared.setTemperatureSensorCalibration(Double(view.value))
            }
        }
    }
    
    //MARK: - checkbox delegate
    
    func onCheckboxSetChanged(_ view: ConvectorCheckboxSetView, value: Any?) {
        if view == self.controlSequenceView {
            ModbusCenter.shared.setControlSequence(value as! ControlSequenceType)
        }
        if view == self.regulatorShutdownModeView {
            ModbusCenter.shared.setRegulatorShutdownMode(value as! RegulatorShutdownWorkType)
        }
        if view == self.valveShutdownModeView {
            ModbusCenter.shared.setValveShutdownMode(value as! FanShutdownWorkType)
        }
        if view == self.fanSpeedGraphView {
            ModbusCenter.shared.setFanSpeedGraph(value as! AutoFanSpeedGraphType)
        }
        if view == self.weekProgramModeView {
            ModbusCenter.shared.setWeeklyProgrammingMode(value as! WeekProgramMode)
        }
        if view == self.blockModeView {
            ModbusCenter.shared.setButtonsBlockMode(value as! ButtonBlockMode)
        }
    }
    
    //MARK: - switch delegate
    
    func onSwitchChanges(_ val: Bool) {
        ModbusCenter.shared.setVentilationMode(val)
    }
    
    //MARK: - buttons
    
    @objc func onDefaultButton() {
        if let vc = self.parentViewController {
            let alert = UIAlertController(title: Localization.main.warning, message: Localization.main.restoringMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Localization.main.yes, style: .default, handler: { action in
                ModbusCenter.shared.resetDefault()
            }))
            alert.addAction(UIAlertAction(title: Localization.main.no, style: .default, handler: { action in
                // skip
            }))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - modbus command callback
    
    @objc func onModbusResponse(_ notification: NSNotification) {        if notification.object != nil && notification.object is ModbusResponse {
            let response = notification.object as! ModbusResponse
            if response.error != nil {
                
            } else if response.command == .version {
                if response.data != nil && response.data is [Int] {
                    if let version = (response.data as! [Int]).first {
                        DispatchQueue.main.async {
                            self.lblVersion.text = "\(Localization.main.version): \(version)"
                        }
                    }
                }
            }
        }
    }
}

protocol ConvectorTwoValParamViewDelegate: class {
    func onParamSelection(view v: ConvectorTwoValParamView, number n: Int)
}

class ConvectorTwoValParamView: UIView {
    private var lblTitle = UILabel()
    private var btnManual = UIButton()
    private var btnAuto = UIButton()
    private var _param1Name = ""
    public var param1Name: String {
        get {
            return _param1Name
        }
        set {
            _param1Name = newValue
            btnManual.setTitle(_param1Name, for: .normal)
        }
    }
    private var _param2Name = ""
    public var param2Name: String {
        get {
            return _param2Name
        }
        set {
            _param2Name = newValue
            btnAuto.setTitle(_param2Name, for: .normal)
        }
    }
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    private var _selectionIndex = 0 // 0 or 1
    public var selectionIndex: Int {
        get {
            return _selectionIndex
        }
        set {
            _selectionIndex = newValue
            if _selectionIndex == 0 {
                selectButton(btnManual)
                deselectButton(btnAuto)
            } else {
                selectButton(btnAuto)
                deselectButton(btnManual)
            }
        }
    }
    private var _buttonTintColor = UIColor(hexString: "#009CDF")
    public var buttonTintColor: UIColor {
        get {
            return _buttonTintColor
        }
        set {
            _buttonTintColor = newValue
            if _selectionIndex == 0 {
                btnManual.setTitleColor(_buttonTintColor, for: .normal)
            } else {
                btnAuto.setTitleColor(_buttonTintColor, for: .normal)
            }
        }
    }
    public weak var delegate: ConvectorTwoValParamViewDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(lblTitle)
        lblTitle.text = ""
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
        btnManual.setTitleColor(buttonTintColor, for: .normal)
        btnManual.setTitle("", for: .normal)
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
        btnAuto.setTitle("", for: .normal)
        btnAuto.titleLabel?.font = UIFont.customFont(bySize: 21)
        btnAuto.clipsToBounds = true
        let tC2 = btnAuto.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC2 = btnAuto.rightAnchor.constraint(equalTo: lblTitle.rightAnchor, constant: 0)
        let wC2 = btnAuto.widthAnchor.constraint(equalTo: lblTitle.widthAnchor, multiplier: 0.5, constant: -10)
        let hC2 = btnAuto.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        btnAuto.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onColorNotification(_:)), name: ColorScheme.changeBackgroundColor, object: nil)
    }
    
    @objc private func onButtonTap(_ button: UIButton) {
        if button == btnManual {
            _selectionIndex = 0
            selectButton(btnManual)
            deselectButton(btnAuto)
            delegate?.onParamSelection(view: self, number: 0)
        } else {
            _selectionIndex = 1
            selectButton(btnAuto)
            deselectButton(btnManual)
            delegate?.onParamSelection(view: self, number: 1)
        }
    }
    
    private func selectButton(_ button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(buttonTintColor, for: .normal)
    }
    
    private func deselectButton(_ button: UIButton) {
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    @objc private func onColorNotification(_ notification: Notification) {
        if notification.object != nil && notification.object is UIColor {
            let color = notification.object as! UIColor
            self.buttonTintColor = color
        }
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

protocol ConvectorCheckboxViewDelegate: class {
    func onCheckboxChange(_ checkbox: ConvectorCheckboxView, value: Bool)
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
    public weak var delegate: ConvectorCheckboxViewDelegate?
    public var allowToClear = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        self.addGestureRecognizer(tapGesture)
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
        
        if _selected {
            let r1 = r - 4
            let path1 = UIBezierPath(ovalIn: CGRect(x: self.frame.width / 2 - r1, y: self.frame.height / 2 - r1, width: 2 * r1, height: 2 * r1))
            UIColor.white.setFill()
            path1.fill()
        }
    }
    
    @objc func onTapAction(_ gesture: UITapGestureRecognizer) {
        if !allowToClear && _selected {
            return
        }
        self.selected = !self.selected
        self.delegate?.onCheckboxChange(self, value: self.selected)
    }
    
}

class ConvectorCheckboxLabeledView: UIView {
    private var _cbxValue = ConvectorCheckboxView()
    public var checkboxView: ConvectorCheckboxView {
        return _cbxValue
    }
    private var label = UILabel()
    public var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    public weak var delegate: ConvectorCheckboxViewDelegate? {
        get {
            return _cbxValue.delegate
        }
        set {
            _cbxValue.delegate = newValue
        }
    }
    public var selected: Bool {
        get {
            return _cbxValue.selected
        }
        set {
            _cbxValue.selected = newValue
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
        
        self.addSubview(_cbxValue)
        _cbxValue.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = _cbxValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC1 = _cbxValue.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC1 = _cbxValue.widthAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        let hC1 = _cbxValue.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
    }
}

protocol ConvectorCheckboxSetViewDelegate: class {
    func onCheckboxSetChanged(_ view: ConvectorCheckboxSetView, value: Any?)
}

class ConvectorCheckboxSetView: UIView, ConvectorCheckboxViewDelegate {
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
    public var checkboxes = [ConvectorCheckboxLabeledView]()
    public var value: Any? {
        get {
            var i = 0
            for check in checkboxes {
                if check.selected {
                    return items[i].value
                }
                i += 1
            }
            return nil
        }
        set {
            if newValue == nil {
                return
            }
            var i = 0
            for item in items {
                if "\(item.value)" == "\(newValue!)" {
                    checkboxes[i].selected = true
                    break
                }
                i += 1
            }
        }
    }
    public weak var delegate: ConvectorCheckboxSetViewDelegate?
    private var _titleLinesNumber = 1
    public var titleLinesNumber: Int {
        get {
            return _titleLinesNumber
        }
        set {
            _titleLinesNumber = newValue
            if let hC = lblTitle.constraints.first(where: { $0.identifier == "title_height" }) {
                hC.constant = CGFloat(25 * self.titleLinesNumber)
                lblTitle.layoutIfNeeded()
            }
            lblTitle.numberOfLines = _titleLinesNumber
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
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: CGFloat(25 * self.titleLinesNumber))
        hC.identifier = "title_height"
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
            checkbox.delegate = self
            checkboxes.append(checkbox)
            
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
    
    func onCheckboxChange(_ checkbox: ConvectorCheckboxView, value: Bool) {
        if value {
            for check in checkboxes {
                if check.checkboxView != checkbox {
                    check.selected = false
                }
            }
        }
        delegate?.onCheckboxSetChanged(self, value: self.value)
    }
}

protocol ConvectorSwitchViewDelegate: class {
    func onSwitchChanges(_ val: Bool)
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
    public var positiveTitle = Localization.main.enabled
    public var negativeTitle = Localization.main.disabled
    public weak var delegate: ConvectorSwitchViewDelegate?
    
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
        self.delegate?.onSwitchChanges(_enabled)
    }
}

protocol ConvectorPlusMinusViewDelegate: class {
    func onPlusMinusBarValueChange(_ val: Int)
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
    public weak var delegate: ConvectorPlusMinusViewDelegate?
    public var minValue = 0
    public var maxValue = 10
    
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
        if self.value >= maxValue {
            return
        }
        self.value += 1
        self.delegate?.onPlusMinusBarValueChange(self.value)
    }
    
    @objc func onMinus() {
        if self.value <= minValue {
            return
        }
        self.value -= 1
        self.delegate?.onPlusMinusBarValueChange(self.value)
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

protocol ConvectorSliderViewDelegate: class {
    func onSliderValueChange(_ value: CGFloat)
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
    public weak var delegate: ConvectorSliderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.isOpaque = false
        
        self.addSubview(pinView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDragAction(_:)))
        pinView.addGestureRecognizer(panGesture)
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
        pinView.frame = CGRect(x: rect.width * _value - w / 2, y: 0, width: w, height: w)
    }
    
    @objc func onDragAction(_ gesture: UIPanGestureRecognizer) {
        let c = gesture.translation(in: pinView)
        var x = pinView.center.x + c.x
        x = max(x, 0)
        x = min(self.frame.width, x)
        //pinView.center = CGPoint(x: x, y: pinView.center.y)
        gesture.setTranslation(.zero, in: pinView)
        
        self.value = x / self.frame.width
        self.delegate?.onSliderValueChange(self.value)
    }
}

protocol ConvectorTrackBarViewDelegate: class {
    func onParameterChange(view: ConvectorTrackBarView, value: Int)
}

class ConvectorTrackBarView: UIView, ConvectorSliderViewDelegate, ConvectorPlusMinusViewDelegate {
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
            let v = CGFloat(newValue - minValue) / CGFloat(maxValue - minValue)
            self.slider.value = v
        }
    }
    private var _minValue = 0
    public var minValue: Int {
        get {
            return _minValue
        }
        set {
            _minValue = newValue
            plusBar.minValue = _minValue
        }
    }
    private var _maxValue = 0
    public var maxValue: Int {
        get {
            return _maxValue
        }
        set {
            _maxValue = newValue
            plusBar.maxValue = _maxValue
        }
    }
    public var postfix: String {
        get {
            return plusBar.postfix
        }
        set {
            plusBar.postfix = newValue
        }
    }
    public weak var delegate: ConvectorTrackBarViewDelegate?
    private var _titleLinesNumber = 1
    public var titleLinesNumber: Int {
        get {
            return _titleLinesNumber
        }
        set {
            _titleLinesNumber = newValue
            if let hC = lblTitle.constraints.first(where: { $0.identifier == "title_height" }) {
                hC.constant = CGFloat(25 * self.titleLinesNumber)
                lblTitle.layoutIfNeeded()
            }
            lblTitle.numberOfLines = _titleLinesNumber
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
        hC.identifier = "title_height"
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(plusBar)
        plusBar.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = plusBar.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC1 = plusBar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = plusBar.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60)
        let hC1 = plusBar.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        plusBar.delegate = self
        
        self.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = slider.topAnchor.constraint(equalTo: plusBar.bottomAnchor, constant: 15)
        let lC2 = slider.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = slider.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC2 = slider.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        slider.delegate = self
    }
    
    func onSliderValueChange(_ value: CGFloat) {
        let v = minValue + Int(CGFloat(maxValue - minValue) * value)
        plusBar.value = v
        self.delegate?.onParameterChange(view: self, value: Int(value))
    }
    
    func onPlusMinusBarValueChange(_ val: Int) {
        self.value = val
        let v = CGFloat(val - minValue) / CGFloat(maxValue - minValue)
        self.slider.value = v
        self.delegate?.onParameterChange(view: self, value: Int(value))
    }
}
