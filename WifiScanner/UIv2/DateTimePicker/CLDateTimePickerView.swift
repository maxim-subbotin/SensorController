//
//  CLDateTimePickerView.swift
//  CoreslabLib
//
//

import Foundation
import UIKit

class CLDateTimePickerView: UIView {
    private var calendarView = CLCalendarView()
    private var timeView = UIDatePicker()
    private var _date: Date?
    public var date: Date? {
        get {
            let d1 = calendarView.selectedDate
            let d2 = timeView.date

            let parts = Calendar.current.dateComponents([.hour, .minute], from: d2)
            var d = d1!.dateOnly()
            d = Calendar.current.date(byAdding: .hour, value: parts.hour!, to: d)!
            d = Calendar.current.date(byAdding: .minute, value: parts.minute!, to: d)!

            return d
        }
        set {
            _date = newValue
            calendarView.date = _date
            calendarView.selectedDate = _date
            if _date != nil {
                timeView.date = _date!
            }
        }
    }
    public var selectedDate: Date? {
        get {
            return calendarView.selectedDate
        }
        set {
            calendarView.selectedDate = newValue
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
        self.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        let tC = calendarView.topAnchor.constraint(equalTo: self.topAnchor)
        let lC = calendarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rC = calendarView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC = calendarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = lineView.topAnchor.constraint(equalTo: calendarView.bottomAnchor)
        let lC2 = lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let rC2 = lineView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        let bC2 = lineView.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([tC2, lC2, rC2, bC2])
        lineView.backgroundColor = UIColor(hexString: "#F0F0F0")
        
        self.addSubview(timeView)
        timeView.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = timeView.topAnchor.constraint(equalTo: calendarView.bottomAnchor)
        let lC1 = timeView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rC1 = timeView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC1 = timeView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        NSLayoutConstraint.activate([tC1, lC1, rC1, bC1])
        timeView.datePickerMode = .time
    }
}
