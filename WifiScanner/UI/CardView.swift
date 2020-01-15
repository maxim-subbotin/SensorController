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
}

class CardPanelView: CardView {
    private var lblValue = UILabel()
    private var lblTitle = UILabel()
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
