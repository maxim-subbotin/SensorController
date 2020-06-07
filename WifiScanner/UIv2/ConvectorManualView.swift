//
//  ConvectorManualView.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol ConvectorManualViewDelegate: class {
    func onManualValueChanged(_ view: ConvectorManualView)
    func onFinalValueChanged(_ view: ConvectorManualView)
}

class ConvectorManualView: UIView {
    private var lblMainTitle = UILabel()
    private var lblDetailTitle = UILabel()
    private var indicatorPanel = ConvectorIndicatorPanel()
    private var pinView = ConvectorManualPinView()
    private let pinSize = CGFloat(45)
    public var postfix: String?
    public weak var delegate: ConvectorManualViewDelegate?
    
    public var mainTitle: String? {
        get {
            return lblMainTitle.text
        }
        set {
            lblMainTitle.text = "\(newValue ?? "")\(postfix ?? "")"
        }
    }
    public var detailText: String? {
        get {
            return lblDetailTitle.text
        }
        set {
            lblDetailTitle.text = "\(newValue ?? "")\(postfix ?? "")"
        }
    }
    private var _isEnabled = true
    public var isEnabled: Bool {
        get {
            return _isEnabled
        }
        set {
            _isEnabled = newValue
            if _isEnabled {
                let currentColor = pinView.borderColor
                lblMainTitle.textColor = currentColor
                pinView.isUserInteractionEnabled = true
            } else {
                lblMainTitle.textColor = UIColor(hexString: "#DADADA")
                pinView.isUserInteractionEnabled = false
            }
        }
    }
    
    private var _startAngle = -(CGFloat.pi + CGFloat(1.0))
    private var _endAngle = CGFloat(1.0)
    
    public var firstValue = CGFloat(5)
    public var lastValue = CGFloat(45)
    public var _value = CGFloat(0)
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            
            let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            let radius = min(frame.width, frame.height) / 2 - 15

            let v = (_value - firstValue) / (lastValue - firstValue)
            let alpha = (_endAngle - _startAngle) * v + _startAngle
            let dx = cos(alpha) * radius
            let dy = sin(alpha) * radius
            pinView.frame = CGRect(x: center.x + dx - pinSize / 2, y: center.y + dy - pinSize / 2, width: pinSize, height: pinSize)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblMainTitle)
        lblMainTitle.translatesAutoresizingMaskIntoConstraints = false
        let cyC = lblMainTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let cxC = lblMainTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let wC = lblMainTitle.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC = lblMainTitle.heightAnchor.constraint(equalToConstant: 165)
        NSLayoutConstraint.activate([cyC, cxC, wC, hC])
        lblMainTitle.textColor = UIColor(hexString: "#009CDF")
        lblMainTitle.textAlignment = .center
        lblMainTitle.font = UIFont.customFont(bySize: 155)
        
        self.addSubview(lblDetailTitle)
        lblDetailTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblDetailTitle.topAnchor.constraint(equalTo: lblMainTitle.bottomAnchor, constant: -25)
        let cxC1 = lblDetailTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let wC1 = lblDetailTitle.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC1 = lblDetailTitle.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([tC1, cxC1, wC1, hC1])
        lblDetailTitle.textColor = UIColor(hexString: "#DADADA")
        lblDetailTitle.textAlignment = .center
        lblDetailTitle.font = UIFont.customFont(bySize: 50)
        
        self.addSubview(pinView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        pinView.addGestureRecognizer(panGesture)
        
        let topOffset = CGFloat(UIDevice.current.isiPad ? -30 : -10)
        self.addSubview(indicatorPanel)
        indicatorPanel.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = indicatorPanel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let bC2 = indicatorPanel.bottomAnchor.constraint(equalTo: self.lblMainTitle.topAnchor, constant: topOffset)
        let wC2 = indicatorPanel.widthAnchor.constraint(equalToConstant: 100)
        let hC2 = indicatorPanel.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([bC2, lC2, wC2, hC2])
        
        NotificationCenter.default.addObserver(self, selector: #selector(onColorNotification(_:)), name: ColorScheme.changeBackgroundColor, object: nil)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // draw main circle
        let r = min(rect.width, rect.height) / 2 - 30
        let circlePath = UIBezierPath(ovalIn: CGRect(x: rect.width / 2 - r, y: rect.height / 2 - r, width: 2 * r, height: 2 * r))
        UIColor.white.setFill()
        circlePath.fill()
        
        // draw indicator line
        let angle = CGFloat(1)
        let curvePath = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: r + 15, startAngle: -(CGFloat.pi + angle), endAngle: angle, clockwise: true)
        curvePath.lineWidth = 2
        UIColor.white.setStroke()
        curvePath.stroke()
        
        // draw small points
        let dY = (r + 15) * cos(CGFloat.pi / 2 - angle)
        let dX = (r + 15) * sin(CGFloat.pi / 2 - angle)
        let c1 = CGPoint(x: rect.width / 2 + dX, y: rect.height / 2 + dY)
        let pointPath = UIBezierPath(ovalIn: CGRect(x: c1.x - 3, y: c1.y - 3, width: 6, height: 6))
        pointPath.fill()
        
        let c2 = CGPoint(x: rect.width / 2 - dX, y: rect.height / 2 + dY)
        let pointPath2 = UIBezierPath(ovalIn: CGRect(x: c2.x - 3, y: c2.y - 3, width: 6, height: 6))
        pointPath2.fill()
        
        
        pinView.frame = CGRect(x: rect.width / 2 - pinSize / 2, y: rect.height / 2 - r - 15 - pinSize / 2, width: pinSize, height: pinSize)
        pinView.setNeedsDisplay()
    }

    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        //let r = sqrt((center.x - location.x) * (center.x - location.x) + (center.y - location.y) * (center.y - location.y))
        let radius = min(frame.width, frame.height) / 2 - 15
        
        let dX = location.x - center.x
        let dY = location.y - center.y
        let rad = atan2(dY, dX)
        
        if rad > 1 && rad < CGFloat.pi - 1 {
            return
        }
   
        let x = radius * cos(rad)
        let y = radius * sin(rad)
    
        var val = CGFloat(0)
        if rad < 1 && rad > 0 {
            val = (CGFloat.pi - 1.0) + CGFloat.pi * 0.5 + rad
        } else if rad <= 0 && rad > -CGFloat.pi {
            val = (CGFloat.pi - abs(rad)) + 1 //(CGFloat.pi - 1.0) + (CGFloat.pi * 0.5 - abs(rad))
        } else if rad <= -CGFloat.pi {
            val = (CGFloat.pi - abs(rad)) + 1 //(CGFloat.pi * 0.5 - 1) + (CGFloat.pi - abs(rad))
        } else {
            val = rad - (CGFloat.pi - 1.0)
        }
        
        let v = firstValue + (lastValue - firstValue) * val / 4.711
        _value = v
        
        if gesture.state == .ended {
            self.delegate?.onFinalValueChanged(self)
        } else {
            self.delegate?.onManualValueChanged(self)
        }
        
        self.mainTitle = String(format: "%.0f", v)
        
        pinView.frame = CGRect(x: self.frame.width / 2 + x - pinSize / 2, y: self.frame.height / 2 + y - pinSize / 2, width: pinSize, height: pinSize)
            
    }
    
    static func color(byValue d: CGFloat) -> UIColor {
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
        return color ?? .blue
    }
    
    func showContent(_ show: Bool) {
        lblMainTitle.isHidden = !show
        lblDetailTitle.isHidden = !show
        indicatorPanel.isHidden = !show
        isUserInteractionEnabled = show
    }
    
    @objc func onColorNotification(_ notification: Notification) {
        if notification.object != nil && notification.object is UIColor {
            let color = notification.object as! UIColor
            self.pinView.borderColor = color
            if _isEnabled {
                lblMainTitle.textColor = color
            }
        }
    }
}

class ConvectorManualPinView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    private var _borderColor = UIColor(hexString: "#009CDF")
    public var borderColor: UIColor {
        get {
            return _borderColor
        }
        set {
            _borderColor = newValue
            self.layer.borderColor = _borderColor.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = rect.width / 2
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.layer.borderColor = _borderColor.cgColor
        self.layer.borderWidth = 5
        self.backgroundColor = .white
    }
}
