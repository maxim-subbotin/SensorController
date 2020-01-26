//
//  FanSpeedView.swift
//  WifiScanner
//
//  1/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol RoundRegulatorViewDelegate: class {
    func onValueChanged(_ value: CGFloat, regulator: RoundRegulatorView)
}

class RoundRegulatorView: UIView {
    private var _activeColor = UIColor(hexString: "#06A77D")
    private var _inactiveColor = UIColor(hexString: "#E1DAC7")
    private var _val = CGFloat(0.3) // from range 0...1
    private var _startAngle = -(CGFloat.pi + CGFloat.pi / 4)
    private var _endAngle = CGFloat.pi / 4
    private var _lineWidth = CGFloat(12)
    private var _handleColor = UIColor(hexString: "#DBB4AD")
    private var radius = CGFloat(0)
    private var _minValue = CGFloat(0)
    public var minValue: CGFloat {
        get {
            return _minValue
        }
        set {
            _minValue = newValue
            self.setNeedsDisplay()
        }
    }
    private var _maxValue = CGFloat(100)
    public var maxValue: CGFloat {
        get {
            return _maxValue
        }
        set {
            _maxValue = newValue
            self.setNeedsDisplay()
        }
    }
    public var value: CGFloat {
        get {
            return _minValue + _val * (_maxValue - _minValue)
        }
        set {
            let v = newValue
            _val = (v - _minValue) / (_maxValue - _minValue)
            self.lblValue.text = "\(String(format: "%.0f", v))%"
            self.setNeedsDisplay()
        }
    }
    
    private var lblValue = UILabel()
    
    public weak var delegate: RoundRegulatorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.isOpaque = false
        
        self.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        self.addGestureRecognizer(panGesture)
        
        self.addSubview(lblValue)
        lblValue.textAlignment = .center
        lblValue.textColor = .white
        lblValue.font = UIFont.systemFont(ofSize: 50)
        lblValue.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblValue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let tC = lblValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = lblValue.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = lblValue.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.lblValue.text = "\(String(format: "%.0f", value))%"
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        radius = min(rect.width, rect.height) / 2 - _lineWidth / 2
        
        let valAngle = (_endAngle - _startAngle) * _val + _startAngle
        
        let path2 = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: radius, startAngle: valAngle, endAngle: _endAngle, clockwise: true)
        path2.lineCapStyle = .round
        _inactiveColor.setStroke()
        path2.lineWidth = _lineWidth
        path2.stroke()
        
        let path1 = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: radius, startAngle: _startAngle, endAngle: valAngle, clockwise: true)
        path1.lineCapStyle = .round
        _activeColor.setStroke()
        path1.lineWidth = _lineWidth
        path1.stroke()
    }
    
    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let r = sqrt((center.x - location.x) * (center.x - location.x) + (center.y - location.y) * (center.y - location.y))
        if abs(r - radius) < 15 {
            let dX = location.x - center.x
            let dY = location.y - center.y
            var rad = atan2(dY, dX)
            if dY > 0 && dX < 0 {
                rad -= 2 * CGFloat.pi
            }
            if rad > _endAngle {
                /*let diff = abs(_endAngle - rad)
                if diff > 20 {
                    rad -= 2 * CGFloat.pi
                }*/
                rad = _endAngle
            }
            if rad < _startAngle {
                rad = _startAngle
            }
            _val = (rad - _startAngle) / (_endAngle - _startAngle)
            self.setNeedsDisplay()
            
            self.lblValue.text = "\(String(format: "%.0f", value))%"
            
            self.delegate?.onValueChanged(value, regulator: self)
        }
    }
}

protocol FanSpeedViewDelegate: class {
    func onFanSpeedChanged(_ val: CGFloat)
}

class FanSpeedView: UIView, RoundRegulatorViewDelegate {
    private var regulatorView = RoundRegulatorView()
    public weak var delegate: FanSpeedViewDelegate?
    public var value: CGFloat {
        get {
            return regulatorView.value
        }
        set {
            regulatorView.value = newValue
        }
    }
    public var minValue: CGFloat {
        get {
            return regulatorView.minValue
        }
        set {
            regulatorView.minValue = newValue
        }
    }
    public var maxValue: CGFloat {
        get {
            return regulatorView.maxValue
        }
        set {
            regulatorView.maxValue = newValue
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
        regulatorView.delegate = self
        
        self.addSubview(regulatorView)
        regulatorView.translatesAutoresizingMaskIntoConstraints = false
        let lC = regulatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let tC = regulatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = regulatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = regulatorView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
    
    func onValueChanged(_ value: CGFloat, regulator: RoundRegulatorView) {
        delegate?.onFanSpeedChanged(value)
    }
}

class FanSpeedViewController: UIViewController, FanSpeedViewDelegate {
    internal var fanSpeedView = FanSpeedView()
    private var _value: CGFloat = 0
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            fanSpeedView.value = _value
        }
    }
    public var minValue: CGFloat {
        get {
            return fanSpeedView.minValue
        }
        set {
            fanSpeedView.minValue = newValue
        }
    }
    public var maxValue: CGFloat {
        get {
            return fanSpeedView.maxValue
        }
        set {
            fanSpeedView.maxValue = newValue
        }
    }
    public weak var delegate: FanSpeedViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(fanSpeedView)
        fanSpeedView.delegate = self
        fanSpeedView.translatesAutoresizingMaskIntoConstraints = false
        let lC = fanSpeedView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = fanSpeedView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10)
        let wC = UIDevice.current.isiPad ?
            fanSpeedView.widthAnchor.constraint(equalToConstant: 350) :
            fanSpeedView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = fanSpeedView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
    
    func onFanSpeedChanged(_ val: CGFloat) {
        delegate?.onFanSpeedChanged(val)
    }
}

protocol SpotFanSpeedParameterViewCellDelegate: class {
    func onFanSpeedCellChange(_ value: CGFloat)
}

class SpotFanSpeedParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate, FanSpeedViewDelegate {
    private var _fanSpeed: CGFloat = 0
    public var fanSpeed: CGFloat {
        get {
            return _fanSpeed
        }
        set {
            _fanSpeed = newValue
        }
    }
    public weak var delegate: SpotFanSpeedParameterViewCellDelegate?
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = FanSpeedViewController()
        vc.minValue = 40
        vc.maxValue = 100
        vc.value = self.fanSpeed
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 220)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: {
            //vc.value = self._fanSpeed
        })
    }

    func onFanSpeedChanged(_ val: CGFloat) {
        _fanSpeed = val
        self.valueTitle = "\(String(format: "%.0f", val))"
        delegate?.onFanSpeedCellChange(val)
    }
}
