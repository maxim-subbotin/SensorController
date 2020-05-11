//
//  RegulatorCellView.swift
//  WifiScanner
//
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class RegulatorCellView: UIView {
    private var iconView = UIImageView()
    private var lblTitle = UILabel()
    private var snowIcon = UIImageView()
    private var sunIcon = UIImageView()
    private var lblTemperature = UILabel()
    private var tempIcon = UIImageView()
    private var lblTempCurrent = UILabel()
    private var btnTurnoff = UIButton()
    private var networkIcon = UIImageView()
    private var separator = UIView()
    private var _spot: Spot?
    public var spot: Spot? {
        get {
            return _spot
        }
        set {
            _spot = newValue
            lblTitle.text = _spot?.name
            //lblDetail.text = _spot?.ssid
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
        self.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        let _tC = separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        let _lC = separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let _wC = separator.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20)
        let _hC = separator.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([_tC, _lC, _wC, _hC])
        separator.backgroundColor = UIColor(hexString: "#767676")
        
        self.addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let tC = iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC = iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        let wC = iconView.widthAnchor.constraint(equalToConstant: 25)
        let hC = iconView.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        iconView.image = UIImage(named: "finger_icon")?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(hexString: "#767676")
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC1 = lblTitle.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10)
        let wC1 = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC1 = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        lblTitle.font = UIFont.customFont(bySize: 20)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        let offset = CGFloat(UIDevice.current.isiPad ? 10 : 2)
        
        self.addSubview(networkIcon)
        networkIcon.contentMode = .scaleAspectFit
        networkIcon.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = networkIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC2 = networkIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -offset)
        let wC2 = networkIcon.widthAnchor.constraint(equalToConstant: 25)
        let hC2 = networkIcon.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        networkIcon.image = UIImage(named: "network_icon")?.withRenderingMode(.alwaysTemplate)
        networkIcon.tintColor = UIColor(hexString: "#767676")
        
        self.addSubview(btnTurnoff)
        btnTurnoff.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = btnTurnoff.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC3 = btnTurnoff.rightAnchor.constraint(equalTo: networkIcon.leftAnchor, constant: -offset)
        let wC3 = btnTurnoff.widthAnchor.constraint(equalToConstant: 25)
        let hC3 = btnTurnoff.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        btnTurnoff.setImage(UIImage(named: "turnoff_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnTurnoff.tintColor = UIColor(hexString: "#767676")
        
        self.addSubview(lblTempCurrent)
        lblTempCurrent.text = "25°C"
        lblTempCurrent.textAlignment = .center
        lblTempCurrent.font = UIFont.customFont(bySize: 25)
        lblTempCurrent.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = lblTempCurrent.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC4 = lblTempCurrent.rightAnchor.constraint(equalTo: btnTurnoff.leftAnchor, constant: -offset)
        let wC4 = lblTempCurrent.widthAnchor.constraint(equalToConstant: 50)
        let hC4 = lblTempCurrent.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        lblTempCurrent.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(tempIcon)
        tempIcon.contentMode = .scaleAspectFit
        tempIcon.translatesAutoresizingMaskIntoConstraints = false
        let tC5 = tempIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC5 = tempIcon.rightAnchor.constraint(equalTo: lblTempCurrent.leftAnchor, constant: -offset)
        let wC5 = tempIcon.widthAnchor.constraint(equalToConstant: 25)
        let hC5 = tempIcon.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC5, lC5, wC5, hC5])
        tempIcon.image = UIImage(named: "temperature_icon")?.withRenderingMode(.alwaysTemplate)
        tempIcon.tintColor = UIColor(hexString: "#767676")
        
        self.addSubview(lblTemperature)
        lblTemperature.text = "22°C"
        lblTemperature.textAlignment = .center
        lblTemperature.font = UIFont.customFont(bySize: 25)
        lblTemperature.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = lblTemperature.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC6 = lblTemperature.rightAnchor.constraint(equalTo: tempIcon.leftAnchor, constant: -offset)
        let wC6 = lblTemperature.widthAnchor.constraint(equalToConstant: 50)
        let hC6 = lblTemperature.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC6, lC6, wC6, hC6])
        lblTemperature.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(sunIcon)
        sunIcon.contentMode = .scaleAspectFit
        sunIcon.translatesAutoresizingMaskIntoConstraints = false
        let tC7 = sunIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC7 = sunIcon.rightAnchor.constraint(equalTo: lblTemperature.leftAnchor, constant: -offset)
        let wC7 = sunIcon.widthAnchor.constraint(equalToConstant: 25)
        let hC7 = sunIcon.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC7, lC7, wC7, hC7])
        sunIcon.image = UIImage(named: "sun_icon")?.withRenderingMode(.alwaysTemplate)
        sunIcon.tintColor = UIColor(hexString: "#767676")
        
        self.addSubview(snowIcon)
        snowIcon.contentMode = .scaleAspectFit
        snowIcon.translatesAutoresizingMaskIntoConstraints = false
        let tC8 = snowIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        let lC8 = snowIcon.rightAnchor.constraint(equalTo: sunIcon.leftAnchor, constant: -offset)
        let wC8 = snowIcon.widthAnchor.constraint(equalToConstant: 25)
        let hC8 = snowIcon.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC8, lC8, wC8, hC8])
        snowIcon.image = UIImage(named: "snow_icon")?.withRenderingMode(.alwaysTemplate)
        snowIcon.tintColor = UIColor(hexString: "#767676")
    }
    
}
