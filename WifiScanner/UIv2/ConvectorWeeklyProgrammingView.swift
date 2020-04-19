//
//  ConvectorWeeklyProgrammingView.swift
//  WifiScanner
//
//  Created by Snappii on 4/19/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit


class ConvectorWeeklyProgrammingView: UIView {
    private var lblTitle = UILabel()
    private var lblDay = DayLabelView()
    private var timeSegment1 = TimeTemperatureView()
    private var timeSegment2 = TimeTemperatureView()
    private var timeSegment3 = TimeTemperatureView()
    private var timeSegment4 = TimeTemperatureView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.clipsToBounds = true
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblTitle)
        lblTitle.text = "Weekly programming"
        lblTitle.textColor = .white
        lblTitle.font = UIFont.customFont(bySize: 25)
        lblTitle.textAlignment = .center
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 38)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(lblDay)
        lblDay.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblDay.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        let lC1 = lblDay.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = lblDay.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC1 = lblDay.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        lblDay.layer.borderColor = UIColor.white.cgColor
        lblDay.layer.borderWidth = 2
        lblDay.layer.cornerRadius = 7
        
        self.addSubview(timeSegment1)
        timeSegment1.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = timeSegment1.topAnchor.constraint(equalTo: lblDay.bottomAnchor, constant: 15)
        let lC2 = timeSegment1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = timeSegment1.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC2 = timeSegment1.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        timeSegment1.temperature = 23
        timeSegment1.startHour = 4
        timeSegment1.endHour = 10
        
        self.addSubview(timeSegment2)
        timeSegment2.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = timeSegment2.topAnchor.constraint(equalTo: timeSegment1.bottomAnchor, constant: 15)
        let lC3 = timeSegment2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC3 = timeSegment2.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC3 = timeSegment2.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        timeSegment2.temperature = 23
        timeSegment2.startHour = 10
        timeSegment2.endHour = 16
        
        self.addSubview(timeSegment3)
        timeSegment3.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = timeSegment3.topAnchor.constraint(equalTo: timeSegment2.bottomAnchor, constant: 15)
        let lC4 = timeSegment3.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC4 = timeSegment3.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC4 = timeSegment3.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        timeSegment3.temperature = 23
        timeSegment3.startHour = 16
        timeSegment3.endHour = 22
        
        self.addSubview(timeSegment4)
        timeSegment4.translatesAutoresizingMaskIntoConstraints = false
        let tC5 = timeSegment4.topAnchor.constraint(equalTo: timeSegment3.bottomAnchor, constant: 15)
        let lC5 = timeSegment4.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC5 = timeSegment4.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC5 = timeSegment4.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC5, lC5, wC5, hC5])
        timeSegment4.temperature = 23
        timeSegment4.startHour = 22
        timeSegment4.endHour = 4
    }
    
}

class DayLabelView: UIView {
    private var lblFirst = UILabel()
    private var lblSecond = UILabel()
    private var btnPrev = UIButton()
    private var btnNext = UIButton()
    private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    private var position = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(lblFirst)
        self.addSubview(lblSecond)
        
        self.addSubview(lblFirst)
        lblFirst.text = days.first
        lblFirst.textColor = .white
        lblFirst.font = UIFont.customFont(bySize: 22)
        lblFirst.textAlignment = .center
        lblFirst.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblFirst.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC = lblFirst.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = lblFirst.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = lblFirst.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(btnPrev)
        btnPrev.setImage(UIImage(named: "prev_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPrev.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = btnPrev.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC1 = btnPrev.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC1 = btnPrev.widthAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        let hC1 = btnPrev.heightAnchor.constraint(equalTo: self.heightAnchor)
        btnPrev.tintColor = .white
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        btnPrev.addTarget(self, action: #selector(onPrevAction), for: .touchUpInside)
        
        self.addSubview(btnNext)
        btnNext.setImage(UIImage(named: "next_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = btnNext.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC2 = btnNext.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC2 = btnNext.widthAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        let hC2 = btnNext.heightAnchor.constraint(equalTo: self.heightAnchor)
        btnNext.tintColor = .white
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        btnNext.addTarget(self, action: #selector(onNextAction), for: .touchUpInside)
    }
    
    @objc func onPrevAction() {
        if position == 0 {
            position = self.days.count - 1
        } else {
            position -= 1
        }
        self.lblFirst.text = self.days[position]
    }
    
    @objc func onNextAction() {
        if position == self.days.count - 1 {
            position = 0
        } else {
            position += 1
        }
        self.lblFirst.text = self.days[position]
    }
}

class TimeTemperatureView: UIView {
    private var lblTime = UILabel()
    private var lblTemperature = UILabel()
    private var btnMinus = UIButton()
    private var btnPlus = UIButton()
    
    private var _temperature = 0
    public var temperature: Int {
        get {
            return _temperature
        }
        set {
            _temperature = newValue
            self.lblTemperature.text = "\(_temperature)°"
        }
    }
    private var _startHour = 0
    private var _endHour = 0
    public var startHour: Int {
        get {
            return _startHour
        }
        set {
            _startHour = newValue
            self.lblTime.text = "\(_startHour):00 - \(_endHour):00"
        }
    }
    public var endHour: Int {
        get {
            return _endHour
        }
        set {
            _endHour = newValue
            self.lblTime.text = "\(_startHour):00 - \(_endHour):00"
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
        self.addSubview(lblTime)
        lblTime.textColor = .white
        lblTime.font = UIFont.customFont(bySize: 25)
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTime.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC = lblTime.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = lblTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
        let hC = lblTime.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        self.addSubview(lblTemperature)
        lblTemperature.textAlignment = .center
        lblTemperature.textColor = .white
        lblTemperature.font = UIFont.customFont(bySize: 25)
        lblTemperature.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblTemperature.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC1 = lblTemperature.leftAnchor.constraint(equalTo: lblTime.rightAnchor, constant: 0)
        let wC1 = lblTemperature.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        let hC1 = lblTemperature.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        
        self.addSubview(btnPlus)
        btnPlus.setImage(UIImage(named: "plus_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPlus.tintColor = .white
        btnPlus.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = btnPlus.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC2 = btnPlus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        let wC2 = btnPlus.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        let hC2 = btnPlus.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        btnPlus.addTarget(self, action: #selector(onPlusAction), for: .touchUpInside)
        
        self.addSubview(btnMinus)
        btnMinus.setImage(UIImage(named: "minus_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnMinus.tintColor = .white
        btnMinus.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = btnMinus.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let lC3 = btnMinus.rightAnchor.constraint(equalTo: btnPlus.leftAnchor, constant: -10)
        let wC3 = btnMinus.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        let hC3 = btnMinus.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        btnMinus.addTarget(self, action: #selector(onMinusAction), for: .touchUpInside)
    }
    
    @objc func onMinusAction() {
        self.temperature -= 1
    }
    
    @objc func onPlusAction() {
        self.temperature += 1
    }
}
