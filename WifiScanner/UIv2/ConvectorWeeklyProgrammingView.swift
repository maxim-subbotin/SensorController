//
//  ConvectorWeeklyProgrammingView.swift
//  WifiScanner
//
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

struct ScheduleRecord {
    public var fanSpeed: Int
    public var temperature: Int
    
    static func parse(fromArray array: [Int]) -> [DayTime: ScheduleRecord]? {
        if array.count != 8 {
            return nil
        }
        var dict = [DayTime: ScheduleRecord]()
        dict[.morning] = ScheduleRecord(fanSpeed: array[0] / 10, temperature: array[4] / 10)
        dict[.noon] = ScheduleRecord(fanSpeed: array[1] / 10, temperature: array[5] / 10)
        dict[.evening] = ScheduleRecord(fanSpeed: array[2] / 10, temperature: array[6] / 10)
        dict[.night] = ScheduleRecord(fanSpeed: array[3] / 10, temperature: array[7] / 10)
        return dict
    }
}


class ConvectorWeeklyProgrammingView: UIView, TimeTemperatureViewDelegate, DayLabelViewDelegate {
    private var lblTitle = UILabel()
    private var lblDay = DayLabelView()
    private var timeSegment1 = TimeTemperatureView()
    private var timeSegment2 = TimeTemperatureView()
    private var timeSegment3 = TimeTemperatureView()
    private var timeSegment4 = TimeTemperatureView()
    private var graph = TemperatureGraphView()
    private var _stopUpdating = false
    private var _scheduleRecords = [DayTime: ScheduleRecord]()
    public var scheduleRecords: [DayTime: ScheduleRecord] {
        get {
            return _scheduleRecords
        }
        set {
            _scheduleRecords = newValue
            _stopUpdating = true
            if let morning = _scheduleRecords[.morning] {
                timeSegment1.temperature = morning.temperature
            }
            if let noon = _scheduleRecords[.noon] {
                timeSegment2.temperature = noon.temperature
            }
            if let evening = _scheduleRecords[.evening] {
                timeSegment3.temperature = evening.temperature
            }
            if let night = _scheduleRecords[.night] {
                timeSegment4.temperature = night.temperature
            }
            _stopUpdating = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onColorNotification(_:)), name: ColorScheme.changeBackgroundColor, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.clipsToBounds = true
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblTitle)
        lblTitle.text = Localization.main.weeklyProgramming.uppercased()
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
        lblDay.delegate = self
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
        timeSegment1.number = 0
        timeSegment1.delegate = self
        
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
        timeSegment2.number = 1
        timeSegment2.delegate = self
        
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
        timeSegment3.number = 2
        timeSegment3.delegate = self
        
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
        timeSegment4.number = 3
        timeSegment4.delegate = self
        
        self.addSubview(graph)
        graph.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = graph.topAnchor.constraint(equalTo: timeSegment4.bottomAnchor, constant: 15)
        let lC6 = graph.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC6 = graph.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(38 + 38))
        let hC6 = graph.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        NSLayoutConstraint.activate([tC6, lC6, wC6, hC6])
        graph.points = [23, 23, 23, 23] //[12, 15, 8, 20]
    }
    
    func onTemperatureChange(_ temp: Int, forNumber num: Int) {
        graph.points[num] = temp
        if _stopUpdating {
            return
        }
        if let day = WeekDay(rawValue: lblDay.position), let time = DayTime(rawValue: num) {
            ModbusCenter.shared.setTemperatureSchedule(forDay: day, time: time, value: temp)
        }
    }
    
    func reloadData() {
        if let day = WeekDay(rawValue: lblDay.position) {
            ModbusCenter.shared.getSchedule(forDay: day)
        }
    }
    
    func onDayChange(_ num: Int) {
        reloadData()
    }
    
    @objc func onColorNotification(_ notification: Notification) {
        if notification.object != nil && notification.object is UIColor {
            let color = notification.object as! UIColor
            self.backgroundColor = color
        }
    }
}

protocol DayLabelViewDelegate: class {
    func onDayChange(_ num: Int)
}

class DayLabelView: UIView {
    private var lblFirst = UILabel()
    private var lblSecond = UILabel()
    private var btnPrev = UIButton()
    private var btnNext = UIButton()
    private var days = [Localization.main.monday,
                        Localization.main.tuesday,
                        Localization.main.wednesday,
                        Localization.main.thursday,
                        Localization.main.friday,
                        Localization.main.saturday,
                        Localization.main.sunday]
    private var _position = 0
    public var position: Int {
        return _position
    }
    public weak var delegate: DayLabelViewDelegate?
    
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
        lblFirst.text = days.first?.uppercased()
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
        if _position == 0 {
            _position = self.days.count - 1
        } else {
            _position -= 1
        }
        self.lblFirst.text = self.days[_position].uppercased()
        delegate?.onDayChange(position)
    }
    
    @objc func onNextAction() {
        if _position == self.days.count - 1 {
            _position = 0
        } else {
            _position += 1
        }
        self.lblFirst.text = self.days[_position].uppercased()
        delegate?.onDayChange(position)
    }
}

protocol TimeTemperatureViewDelegate: class {
    func onTemperatureChange(_ temp: Int, forNumber num: Int)
}

class TimeTemperatureView: UIView {
    private var lblTime = UILabel()
    private var lblTemperature = UILabel()
    private var btnMinus = UIButton()
    private var btnPlus = UIButton()
    public var number = 0
    public weak var delegate: TimeTemperatureViewDelegate?
    
    private var _temperature = 0
    public var temperature: Int {
        get {
            return _temperature
        }
        set {
            _temperature = newValue
            self.lblTemperature.text = "\(_temperature)°"
            delegate?.onTemperatureChange(_temperature, forNumber: number)
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

class TemperatureGraphView: UIView {
    private var _points = [23, 23, 22, 23]
    private var minPoint = 0
    private var maxPoint = 0
    public var points: [Int] {
        get {
            return _points
        }
        set {
            self._points = newValue
            self.minPoint = newValue.min() ?? 0
            self.maxPoint = newValue.max() ?? 0
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let h = rect.height / CGFloat(maxPoint - minPoint + 2)
        var x = CGFloat(0)
        let dx = rect.width / CGFloat(self.points.count)
        let radius = CGFloat(8)
        var i = 0
        var coords = [CGPoint]()
        for p in points {
            let y = CGFloat(maxPoint - p + 1) * h
            if i == 0 {
                x += radius / 2
            }
            if i == points.count - 1 {
                x -= radius / 2
            }
            coords.append(CGPoint(x: x, y: y))

            x += dx
            i += 1
        }
        coords.append(CGPoint(x: x - radius / 2, y: coords.first!.y))
        
        i = 0
        for c in coords {
            let frame = CGRect(x: c.x - radius / 2, y: c.y - radius / 2, width: radius, height: radius)
            let circle = UIBezierPath(ovalIn: frame)
            UIColor.white.setFill()
            circle.fill()
            
            let line = UIBezierPath()
            line.move(to: c)
            if i < coords.count - 1 {
                line.addLine(to: coords[i + 1])
            }
            line.lineWidth = 2
            UIColor.white.setStroke()
            line.stroke()
            
            i += 1
        }
        
        let border = UIBezierPath(rect: CGRect(x: radius / 2, y: radius / 2, width: rect.width - radius, height: rect.height - radius))
        border.lineWidth = 1
        border.stroke()
    }
}
