//
//  DatetimeView.swift
//  WifiScanner
//
//  1/23/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol DatetimeViewDelegate: class {
    func onDateChanging(_ date: Date)
}

class DatetimeView: UIView {
    private var lblDate = UILabel()
    private var lblTime = UILabel()
    private var datePicker = UIDatePicker()
    private var timePicker = UIDatePicker()
    private var _date = Date()
    public var date: Date {
        get {
            return _date
        }
        set {
            _date = newValue
            datePicker.date = _date
            timePicker.date = _date
        }
    }
    public weak var delegate: DatetimeViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(lblDate)
        lblDate.text = "Date"
        lblDate.textAlignment = .center
        lblDate.textColor = ColorScheme.current.datePickerLabelTextColor
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblDate.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let tC = lblDate.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = lblDate.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        let hC = lblDate.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.addSubview(lblTime)
        lblTime.text = "Time"
        lblTime.textAlignment = .center
        lblTime.textColor = ColorScheme.current.datePickerLabelTextColor
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblTime.leftAnchor.constraint(equalTo: lblDate.rightAnchor, constant: 0)
        let tC1 = lblTime.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC1 = lblTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)
        let hC1 = lblTime.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
        
        self.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(onDatePickerChange), for: .valueChanged)
        datePicker.backgroundColor = ColorScheme.current.datePickerInputBackgroundColor
        datePicker.tintColor = ColorScheme.current.datePickerInputTextColor
        datePicker.datePickerMode = .date
        datePicker.setValue(ColorScheme.current.datePickerInputTextColor, forKeyPath: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = datePicker.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let tC2 = datePicker.topAnchor.constraint(equalTo: lblDate.bottomAnchor, constant: 0)
        let wC2 = datePicker.widthAnchor.constraint(equalTo: lblDate.widthAnchor)
        let hC2 = datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([lC2, tC2, wC2, hC2])
        
        self.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(onDatePickerChange), for: .valueChanged)
        timePicker.backgroundColor = ColorScheme.current.datePickerInputBackgroundColor
        timePicker.tintColor = ColorScheme.current.datePickerInputTextColor
        timePicker.datePickerMode = .time
        timePicker.setValue(ColorScheme.current.datePickerInputTextColor, forKeyPath: "textColor")
        timePicker.setValue(false, forKeyPath: "highlightsToday")
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        let lC3 = timePicker.leftAnchor.constraint(equalTo: lblTime.leftAnchor, constant: 0)
        let tC3 = timePicker.topAnchor.constraint(equalTo: lblTime.bottomAnchor, constant: 0)
        let wC3 = timePicker.widthAnchor.constraint(equalTo: lblTime.widthAnchor)
        let hC3 = timePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([lC3, tC3, wC3, hC3])
    }
    
    @objc func onDatePickerChange() {
        let date1 = datePicker.date
        let date2 = timePicker.date
        
        let parts1 = Calendar.current.dateComponents([.day, .year, .month], from: date1)
        let parts2 = Calendar.current.dateComponents([.hour, .minute], from: date2)
        let day = parts1.day ?? 0
        let month = parts1.month ?? 0
        let year = parts1.year ?? 0
        let hour = parts2.hour ?? 0
        let minute = parts2.minute ?? 0

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        _date = Calendar.current.date(from: dateComponents) ?? Date()
        
        delegate?.onDateChanging(_date)
    }
}

class DatetimeViewController: UIViewController {
    private var datetimeView = DatetimeView()
    private var _date: Date = Date()
    public var date: Date {
        get {
            return datetimeView.date
        }
        set {
            _date = newValue
            datetimeView.date = _date
        }
    }
    public weak var delegate: DatetimeViewDelegate? {
        get {
            return datetimeView.delegate
        }
        set {
            datetimeView.delegate = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(datetimeView)
        datetimeView.translatesAutoresizingMaskIntoConstraints = false
        let lC = datetimeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = datetimeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = UIDevice.current.isiPad ?
            datetimeView.widthAnchor.constraint(equalToConstant: 470) :
            datetimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = datetimeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
}
