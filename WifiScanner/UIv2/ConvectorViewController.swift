//
//  ConvectorViewController.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ConvectorViewController: UIViewController {
    private var lblTitle = UILabel()
    private var dateView = ConvectorDateTimeView()
    private var bottomPanel = ConvectorBottomPanel()
    private var manualView = ConvectorManualView()
    public var spot = Spot()
    public var spotState = SpotState.demo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#009CDF")
        
        applyUI()
    }
    
    func applyUI() {
        self.view.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12)
        let cxC = lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC, cxC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor(hexString: "#88FFFFFF")
        lblTitle.textColor = .white
        lblTitle.text = spot.name
        lblTitle.font = UIFont.customFont(bySize: 26)
        
        self.view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = dateView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 15)
        let cxC1 = dateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC1 = dateView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC1 = dateView.heightAnchor.constraint(equalToConstant: 75)
        NSLayoutConstraint.activate([tC1, cxC1, wC1, hC1])
        dateView.date = spotState.date
        
        self.view.addSubview(bottomPanel)
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = bottomPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5)
        let cxC2 = bottomPanel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC2 = UIDevice.current.isiPad ? bottomPanel.widthAnchor.constraint(equalToConstant: 400) : bottomPanel.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC2 = bottomPanel.heightAnchor.constraint(equalToConstant: UIDevice.current.isiPad ? 60 : 40)
        NSLayoutConstraint.activate([tC2, cxC2, wC2, hC2])
        
        self.view.addSubview(manualView)
        manualView.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = manualView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 15)
        let cxC3 = manualView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let wC3 = manualView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40)
        let bC3 = manualView.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -90)
        NSLayoutConstraint.activate([tC3, cxC3, wC3, bC3])
        manualView.backgroundColor = UIColor(hexString: "#22FFFFFF")
    }
    
}
