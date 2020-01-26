//
//  ReactionTimeView.swift
//  WifiScanner
//
//  1/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ReactionTimeView: UIView {
    private var txtField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(txtField)
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
    }
    
    override func becomeFirstResponder() -> Bool {
        return txtField.becomeFirstResponder()
    }
}

class ReactionTimeViewController: UIViewController {
    internal var timeView = ReactionTimeView()
    private var _value: CGFloat = 0
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            //fanSpeedView.value = _value
        }
    }
    //public weak var delegate: FanSpeedViewDelegate?
    
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
        //timeView.delegate = self
        timeView.translatesAutoresizingMaskIntoConstraints = false
        let lC = timeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = timeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = UIDevice.current.isiPad ?
            timeView.widthAnchor.constraint(equalToConstant: 300) :
            timeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = timeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
}

class SpotReactionTimeParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate {
    private var _reactionTime: CGFloat = 0
    public var reactionTime: CGFloat {
        get {
            return _reactionTime
        }
        set {
            _reactionTime = newValue
        }
    }
    //public weak var delegate: SpotFanSpeedParameterViewCellDelegate?
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = ReactionTimeViewController()
        //vc.value = self.fanSpeed
        //vc.delegate = self
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
    
    /*func onFanSpeedChanged(_ val: CGFloat) {
        _fanSpeed = val
        self.valueTitle = "\(String(format: "%.0f", val))"
        delegate?.onFanSpeedCellChange(val)
    }*/
}
