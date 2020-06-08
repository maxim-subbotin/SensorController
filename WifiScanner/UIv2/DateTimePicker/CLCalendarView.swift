//
//  CLCalendarView.swift
//  CoreslabLib
//
//

import Foundation
import UIKit

class CLCalendarView: UIView, CLCalendarHeaderViewDelegate {
    private var headerView = CLCalendarHeaderView()
    private var monthView = CLMonthView()
    private var _selectedDate: Date?
    public var selectedDate: Date? {
        get {
            return monthView.selectedDate
        }
        set {
            _selectedDate = newValue
            monthView.selectedDate = _selectedDate
        }
    }
    private var _date: Date?
    public var date: Date? {
        get {
            return _date
        }
        set {
            _date = newValue
            monthView.date = _date
            headerView.text = _date == nil ? "" : "\(_date!.month) \(_date!.year)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let tC = headerView.topAnchor.constraint(equalTo: self.topAnchor)
        let lC = headerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let rC = headerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC = headerView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        headerView.delegate = self
        
        self.addSubview(monthView)
        monthView.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = monthView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        let lC1 = monthView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let rC1 = monthView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC1 = monthView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([tC1, lC1, rC1, bC1])
    }
    
    func goToPrevMonth() {
        self.monthView.showPrevMonth()
        _date = self.monthView.date
        headerView.text = _date == nil ? "" : "\(_date!.month) \(_date!.year)"
    }
    
    func goToNextMonth() {
        self.monthView.showNextMonth()
        _date = self.monthView.date
        headerView.text = _date == nil ? "" : "\(_date!.month) \(_date!.year)"
    }
}

protocol CLCalendarHeaderViewDelegate: class {
    func goToPrevMonth()
    func goToNextMonth()
}

class CLCalendarHeaderView: UILabel {
    private var leftArrow = UIButton()
    private var rightArrow = UIButton()
    public weak var delegate: CLCalendarHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        let bundle = Bundle(for: CLCalendarView.self)
        let leftImg = UIImage(named: "cl_left_arrow", in: bundle, compatibleWith: nil)
        let rightImg = UIImage(named: "cl_right_arrow", in: bundle, compatibleWith: nil)
        
        self.addSubview(leftArrow)
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        let tC = leftArrow.topAnchor.constraint(equalTo: self.topAnchor)
        let lC = leftArrow.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let rC = leftArrow.widthAnchor.constraint(equalToConstant: 60)
        let bC = leftArrow.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        leftArrow.setImage(leftImg, for: .normal)
        leftArrow.addTarget(self, action: #selector(onLeftButton), for: .touchUpInside)
            
        self.addSubview(rightArrow)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = rightArrow.topAnchor.constraint(equalTo: self.topAnchor)
        let lC1 = rightArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        let rC1 = rightArrow.widthAnchor.constraint(equalToConstant: 60)
        let bC1 = rightArrow.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([tC1, lC1, rC1, bC1])
        rightArrow.setImage(rightImg, for: .normal)
        rightArrow.addTarget(self, action: #selector(onRightButton), for: .touchUpInside)
        
        self.textAlignment = .center
        self.textColor = UIColor(hexString: "#050505")
        self.font = UIFont.customFont(bySize: 20)
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onHeaderTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func onLeftButton() {
        delegate?.goToPrevMonth()
    }
    
    @objc func onRightButton() {
        delegate?.goToNextMonth()
    }
    
    @objc func onHeaderTap() {
        print("header tap")
    }
}

class CLMonthHeaderView: UIView {
    private var labels = [UILabel]()
    private var titles = [Localization.main.mo,
                          Localization.main.tu,
                          Localization.main.we,
                          Localization.main.th,
                          Localization.main.fr,
                          Localization.main.sa,
                          Localization.main.su]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        var prevView: UIView?
        for i in 0..<7 {
            let lbl = UILabel()
            self.addSubview(lbl)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            let tC = lbl.topAnchor.constraint(equalTo: self.topAnchor)
            let lC = prevView == nil ? lbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0) : lbl.leftAnchor.constraint(equalTo: prevView!.rightAnchor, constant: 0)
            let rC = lbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.142857)
            let bC = lbl.heightAnchor.constraint(equalTo: self.heightAnchor)
            NSLayoutConstraint.activate([tC, lC, rC, bC])
            lbl.textAlignment = .center
            lbl.text = titles[i]
            lbl.textColor = UIColor(hexString: "#A0A0A0")
            lbl.font = UIFont.customFont(bySize: 25)
            prevView = lbl
        }
    }
}

class CLMonthView: UIView, CLWeekViewDelegate {
    private var headerView = CLMonthHeaderView()
    public var selectedDate: Date?
    private var _date: Date?
    public var date: Date? {
        get {
            return _date
        }
        set {
            _date = newValue
            if _date != nil {
                applyDate(_date!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let tC = headerView.topAnchor.constraint(equalTo: self.topAnchor)
        let lC = headerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let rC = headerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC = headerView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
    }
    
    func applyDate(_ date: Date) {
        for v in subviews {
            if v is CLWeekView {
                v.removeFromSuperview()
            }
        }
        
        // need to determine how many weeks in month
        var count = 1
        let currentMonth = date.month
        var startWeeks = [Date]()
        var day = date.firstDayOfMonth
        if day.weekDayNumber == 1 {
            count = 0
        } else {
            var prevDay = day
            while prevDay.weekDayNumber > 0 {
                if prevDay.weekDayNumber == 1 {
                    startWeeks.append(prevDay)
                    break
                }
                prevDay = prevDay.prevDay!
            }
        }
        
        while currentMonth == day.month {
            let number = day.weekDayNumber
            if number == 1 {
                count += 1
                startWeeks.append(day)
            }
            day = day.nextDay!
        }
        
        let weekHeight = CGFloat(50)
        var prevView: UIView?
        for i in 1...startWeeks.count {
            let weekView = CLWeekView()
            weekView.delegate = self
            weekView.selectedDate = self.selectedDate
            weekView.month = date.monthNumber
            weekView.firstDay = startWeeks[i - 1]
            self.addSubview(weekView)
            weekView.translatesAutoresizingMaskIntoConstraints = false
            let tC = prevView == nil ? weekView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0) : weekView.topAnchor.constraint(equalTo: prevView!.bottomAnchor, constant: 0)
            let lC = weekView.leftAnchor.constraint(equalTo: self.leftAnchor)
            let rC = weekView.widthAnchor.constraint(equalTo: self.widthAnchor)
            let bC = weekView.heightAnchor.constraint(equalToConstant: weekHeight)
            NSLayoutConstraint.activate([tC, lC, rC, bC])
            
            prevView = weekView
        }
    }
    
    func showPrevMonth() {
        let d = date?.firstDayOfMonth
        self.date = d!.prevDay!
    }
    
    func showNextMonth() {
        var d = date
        var month = d!.monthNumber
        while d!.monthNumber == month {
            d = d?.nextDay
        }
        self.date = d
    }
    
    func onDaySelected(_ date: Date) {
        self.selectedDate = date
        applyDate(_date!)
    }
}

class CLDayView: UILabel {
    public var date: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CLDayMarker: UIView {
    
}

protocol CLWeekViewDelegate: class {
    func onDaySelected(_ date: Date)
}

class CLWeekView: UIView {
    public var month: Int = 1
    private var _firstDay = Date()
    public var firstDay: Date {
        get {
            return _firstDay
        }
        set {
            _firstDay = newValue
            applyDate(_firstDay)
        }
    }
    public var selectedDate: Date?
    public weak var delegate: CLWeekViewDelegate?
    
    func applyDate(_ date: Date) {
        self.isUserInteractionEnabled = true
        
        var prevView: UIView?
        var day = date
        for i in 0..<7 {
            let lbl = CLDayView()
            lbl.date = day
            self.addSubview(lbl)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            let tC = lbl.topAnchor.constraint(equalTo: self.topAnchor)
            let lC = prevView == nil ? lbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0) : lbl.leftAnchor.constraint(equalTo: prevView!.rightAnchor, constant: 0)
            let rC = lbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.142857)
            let bC = lbl.heightAnchor.constraint(equalTo: self.heightAnchor)
            NSLayoutConstraint.activate([tC, lC, rC, bC])
            lbl.textAlignment = .center
            lbl.text = "\(day.dayNumber)"
            if day.monthNumber == self.month {
                lbl.textColor = UIColor(hexString: "#303030")
            } else {
                lbl.textColor = UIColor(hexString: "#AAAAAA")
            }
            lbl.font = UIFont.customFont(bySize: 20)
            prevView = lbl
            
            if selectedDate != nil && selectedDate!.isSameDay(day) {
                let markerView = CLDayMarker()
                self.insertSubview(markerView, at: 0)
                markerView.translatesAutoresizingMaskIntoConstraints = false
                let tC = markerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                let lC = markerView.centerXAnchor.constraint(equalTo: lbl.centerXAnchor)
                let rC = markerView.widthAnchor.constraint(equalToConstant: 50)
                let bC = markerView.heightAnchor.constraint(equalToConstant: 50)
                NSLayoutConstraint.activate([tC, lC, rC, bC])
                markerView.layer.cornerRadius = 25
                markerView.backgroundColor = UIColor(hexString: "#1084EA")
                markerView.layer.borderColor = UIColor(hexString: "#2A90EA").cgColor
                markerView.layer.borderWidth = 5
                lbl.textColor = UIColor.white
            } else if day.isSameDay(Date()) {
                let markerView = UIView()
                self.insertSubview(markerView, at: 0)
                markerView.translatesAutoresizingMaskIntoConstraints = false
                let tC = markerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                let lC = markerView.centerXAnchor.constraint(equalTo: lbl.centerXAnchor)
                let rC = markerView.widthAnchor.constraint(equalToConstant: 50)
                let bC = markerView.heightAnchor.constraint(equalToConstant: 50)
                NSLayoutConstraint.activate([tC, lC, rC, bC])
                markerView.layer.cornerRadius = 25
                markerView.backgroundColor = UIColor(hexString: "#F9B536")
                markerView.layer.borderColor = UIColor(hexString: "#F4C05F").cgColor
                markerView.layer.borderWidth = 5
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onDayTapGesture(_:)))
            lbl.addGestureRecognizer(tapGesture)
            
            day = day.nextDay!
        }
    }
    
    @objc func onDayTapGesture(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.view is CLDayView {
            self.selectedDate = (tapGesture.view as! CLDayView).date
            delegate?.onDaySelected(self.selectedDate!)
        }
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var weekDayNumber: Int {
        var num = Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
        num -= 1
        if num < 0 {
            num += 7
        }
        return num
    }
    
    var monthNumber: Int {
        return Calendar.current.dateComponents([.month], from: self).month ?? 0
    }
    
    var dayNumber: Int {
        return Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
    
    var firstDayOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth ?? Date()
    }
}
