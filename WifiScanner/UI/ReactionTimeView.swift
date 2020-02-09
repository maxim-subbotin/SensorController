//
//  ReactionTimeView.swift
//  WifiScanner
//
//  1/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol ReactionTimeViewDelegate: class {
    func onTimeChange(inSeconds sec: Int)
}

extension Int {
    public var minutesAndSeconds: String {
        let minutes = self / 60
        let seconds = self - (60 * minutes)
        
        if minutes == 0 {
            return "\(seconds) sec"
        } else if seconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes) min \(seconds) sec"
        }
    }
}

class ReactionTimeView: UIView, UITextFieldDelegate {
    private var txtField = UITextField()
    private var lblMinutes = UILabel()
    public weak var delegate: ReactionTimeViewDelegate?
    public var time: Int? {
        get {
            return Int(txtField.text ?? "")
        }
        set {
            txtField.text = newValue == nil ? nil : "\(newValue!)"
            lblMinutes.text = newValue == nil ? nil : newValue!.minutesAndSeconds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(txtField)
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtField.delegate = self
        txtField.textAlignment = .center
        txtField.textColor = .white
        txtField.font = UIFont.systemFont(ofSize: 50)
        txtField.keyboardType = .numberPad
        txtField.translatesAutoresizingMaskIntoConstraints = false
        let lC = txtField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5)
        let tC = txtField.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        let wC = txtField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10)
        let hC = txtField.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.addSubview(lblMinutes)
        lblMinutes.textColor = .white
        lblMinutes.textAlignment = .center
        lblMinutes.font = UIFont.systemFont(ofSize: 12)
        lblMinutes.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblMinutes.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5)
        let tC1 = lblMinutes.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        let wC1 = lblMinutes.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10)
        let hC1 = lblMinutes.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
    }
    
    override func becomeFirstResponder() -> Bool {
        return txtField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let val = "\(textField.text ?? "")\(string)"
        
        let numberSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let parts = val.components(separatedBy: numberSet)
        let numberFiltered = parts.joined(separator: "")
        if val != numberFiltered {
            return false
        }
        
        if let intVal = Int(numberFiltered) {
            if intVal > 0 && intVal <= 300 {
                return true
            }
            return false
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let intVal = Int(textField.text ?? "") {
            let minutes = intVal / 60
            let seconds = intVal - (60 * minutes)
            
            if minutes == 0 {
                lblMinutes.text = "\(seconds) sec"
            } else if seconds == 0 {
                lblMinutes.text = "\(minutes) min"
            } else {
                lblMinutes.text = "\(minutes) min \(seconds) sec"
            }
            
            self.delegate?.onTimeChange(inSeconds: intVal)
        } else {
            lblMinutes.text = nil
        }
    }
}

class ReactionTimeViewController: UIViewController, ReactionTimeViewDelegate {
    internal var timeView = ReactionTimeView()
    private var _value: CGFloat = 0
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            timeView.time = Int(_value)
        }
    }
    public weak var delegate: ReactionTimeViewDelegate?
    public var propagateChangesImmediately = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timeView.becomeFirstResponder()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(timeView)
        timeView.delegate = self
        timeView.translatesAutoresizingMaskIntoConstraints = false
        let lC = timeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = timeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = UIDevice.current.isiPad ?
            timeView.widthAnchor.constraint(equalToConstant: 300) :
            timeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = timeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
    
    func onTimeChange(inSeconds sec: Int) {
        if propagateChangesImmediately {
            delegate?.onTimeChange(inSeconds: sec)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !propagateChangesImmediately {
            delegate?.onTimeChange(inSeconds: timeView.time ?? 10)
        }
    }
}

class SpotReactionTimeParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate, ReactionTimeViewDelegate {
    private var _reactionTime: CGFloat = 0
    public var reactionTime: CGFloat {
        get {
            return _reactionTime
        }
        set {
            _reactionTime = newValue
            self.valueTitle = Int(_reactionTime).minutesAndSeconds
        }
    }
    public weak var delegate: ReactionTimeViewDelegate?
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = ReactionTimeViewController()
        vc.value = self.reactionTime
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 100)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: {
            //vc.value = self._fanSpeed
        })
    }
    
    func onTimeChange(inSeconds sec: Int) {
        _reactionTime = CGFloat(sec)
        self.valueTitle = sec.minutesAndSeconds
        delegate?.onTimeChange(inSeconds: sec)
    }
}
