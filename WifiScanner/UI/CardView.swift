//
//  CardView.swift
//  WifiScanner
//
//  1/15/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    private var _color1 = UIColor.gray
    public var color1: UIColor {
        get {
            return _color1
        }
        set {
            _color1 = newValue
            applyGradient()
        }
    }
    private var _color2 = UIColor.lightGray
    public var color2: UIColor {
        get {
            return _color2
        }
        set {
            _color2 = newValue
            applyGradient()
        }
    }
    private var gradientLayer: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    init() {
        super.init(frame: .zero)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradient()
    }
    
    func applyUI() {
        self.clipsToBounds = true
        applyGradient()
    }
    
    func applyGradient() {
        if gradientLayer != nil {
            gradientLayer?.removeFromSuperlayer()
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = self.bounds
        gradientLayer?.startPoint = CGPoint.zero
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.colors = [color1.cgColor, color2.cgColor]
        self.layer.insertSublayer(gradientLayer!, at: UInt32(0))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}

class CardPanelView: CardView {
    internal var lblValue = UILabel()
    internal var lblTitle = UILabel()
    private var titleHeight = CGFloat(35)
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    public var value: String? {
        get {
            return lblValue.text
        }
        set {
            lblValue.text = newValue
        }
    }
    public var valueColor: UIColor {
        get {
            return lblValue.textColor
        }
        set {
            lblValue.textColor = newValue
        }
    }
    public var valueFont: UIFont {
        get {
            return lblValue.font
        }
        set {
            lblValue.font = newValue
        }
    }
    
    override func applyUI() {
        super.applyUI()
        
        self.addSubview(lblValue)
        lblValue.textAlignment = .center
        lblValue.textColor = .white
        lblValue.font = UIFont.boldSystemFont(ofSize: 40)
        lblValue.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblValue.leftAnchor.constraint(equalTo: self.leftAnchor)
        let tC = lblValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = lblValue.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC = lblValue.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -titleHeight)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.addSubview(lblTitle)
        lblTitle.textAlignment = .center
        lblTitle.textColor = .white
        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor)
        let tC1 = lblTitle.topAnchor.constraint(equalTo: lblValue.bottomAnchor, constant: 0)
        let wC1 = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC1 = lblTitle.heightAnchor.constraint(equalToConstant: titleHeight)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
    }
}

class ValveStateCardView: CardPanelView {
    private var lblState = UILabel()
    
    override func applyUI() {
        super.applyUI()
        
        self.addSubview(lblState)
        lblState.backgroundColor = UIColor(hexString: "#0C3B4F")
        lblState.text = "COLD"
        lblState.textAlignment = .center
        lblState.textColor = .white
        lblState.font = UIFont.boldSystemFont(ofSize: 20)
        lblState.translatesAutoresizingMaskIntoConstraints = false
        let cxC = lblState.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let tC = lblState.centerYAnchor.constraint(equalTo: lblValue.centerYAnchor)
        let wC = lblState.widthAnchor.constraint(equalToConstant: 120)
        let hC = lblState.heightAnchor.constraint(equalToConstant: 40)
        lblState.layer.cornerRadius = 20
        lblState.clipsToBounds = true
        NSLayoutConstraint.activate([cxC, tC, wC, hC])
    }
}

class RegulatorStateCardView: CardPanelView {
    private var lblStatus = UILabel()
    public var onStateColor = UIColor(hexString: "#56AB7B")
    public var offStateColor = UIColor(hexString: "#CE4444")
    private var _state = RegulatorState.off
    public var state: RegulatorState {
        get {
            return _state
        }
        set {
            _state = newValue
            if _state == .off {
                lblStatus.text = "OFF"
                lblStatus.backgroundColor = offStateColor
            }
            if _state == .on {
                lblStatus.text = "ON"
                lblStatus.backgroundColor = onStateColor
            }
        }
    }
    
    override func applyUI() {
        super.applyUI()
        
        self.addSubview(lblStatus)
        lblStatus.textAlignment = .center
        lblStatus.textColor = .white
        lblStatus.font = UIFont.boldSystemFont(ofSize: 20)
        lblStatus.translatesAutoresizingMaskIntoConstraints = false
        let cxC = lblStatus.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let tC = lblStatus.centerYAnchor.constraint(equalTo: lblValue.centerYAnchor)
        let wC = lblStatus.widthAnchor.constraint(equalToConstant: 50)
        let hC = lblStatus.heightAnchor.constraint(equalToConstant: 50)
        lblStatus.backgroundColor = .red
        lblStatus.layer.cornerRadius = 25
        lblStatus.clipsToBounds = true
        NSLayoutConstraint.activate([cxC, tC, wC, hC])
    }
}
