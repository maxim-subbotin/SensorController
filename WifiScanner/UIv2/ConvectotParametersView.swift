//
//  ConvectotParametersView.swift
//  WifiScanner
//
//  Created on 3/2/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ConvectorParametersView: UIView {
    private var lblParams = UILabel()
    private var fanModeView = ConvectorFanModeParamView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
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
        let hC2 = fanModeView.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
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
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
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
    }
}
