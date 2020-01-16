//
//  SpotParameterView.swift
//  WifiScanner
//
//  1/16/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotParameterView: UIView {
    private var lblTitle = UILabel()
    private var lblValue = UILabel()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        let offset = CGFloat(10)
        
        self.addSubview(lblTitle)
        lblTitle.textAlignment = .left
        lblTitle.textColor = ColorScheme.current.spotParameterTitleColor
        lblTitle.font = UIFont.systemFont(ofSize: 20)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset)
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2 * offset)
        let hC = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.addSubview(lblValue)
        lblValue.textAlignment = .right
        lblValue.textColor = ColorScheme.current.spotParameterValueColor
        lblValue.font = UIFont.systemFont(ofSize: 20)
        lblValue.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblValue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset)
        let tC1 = lblValue.topAnchor.constraint(equalTo: self.topAnchor)
        let wC1 = lblValue.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2 * offset)
        let hC1 = lblValue.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
        
        self.backgroundColor = ColorScheme.current.spotParameterBackgroundColor
    }
}
