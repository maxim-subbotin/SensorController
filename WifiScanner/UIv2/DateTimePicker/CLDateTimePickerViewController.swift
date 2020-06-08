//
//  CLDateTimePickerViewController.swift
//  CoreslabLib
//
//

import Foundation
import UIKit

protocol CLDateTimePickerViewControllerDelegate: class {
    func onDateTimeSelection(_ date: Date)
}

class CLDateTimePickerViewController: UIViewController {
    private var pickerView = CLDateTimePickerView()
    private var btnCurrentDate = UIButton()
    private var _date: Date?
    public var date: Date? {
        get {
            return pickerView.date
        }
        set {
            _date = newValue
            pickerView.selectedDate = _date
            pickerView.date = _date
        }
    }
    public weak var delegate: CLDateTimePickerViewControllerDelegate?
    public var topOffset = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Localization.main.dateAndTime
        self.view.backgroundColor = .white
        
        self.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let tC = pickerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topOffset)
        let lC = pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let rC = pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let bC = pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        
        self.view.addSubview(btnCurrentDate)
        btnCurrentDate.backgroundColor = UIColor(hexString: "#f0f0f0")
        btnCurrentDate.setTitle(Localization.main.setCurrentDate, for: .normal)
        btnCurrentDate.titleLabel?.font = UIFont.customFont(bySize: 18)
        btnCurrentDate.setTitleColor(UIColor(hexString: "#1084EA"), for: .normal)
        btnCurrentDate.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = btnCurrentDate.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 0)
        let lC1 = btnCurrentDate.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let rC1 = btnCurrentDate.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let bC1 = btnCurrentDate.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([tC1, lC1, rC1, bC1])
        btnCurrentDate.addTarget(self, action: #selector(onCurrentAction), for: .touchUpInside)
        
        let btnClose = UIBarButtonItem(title: Localization.main.back, style: .done, target: self, action: #selector(onCloseAction))
        let btnOK = UIBarButtonItem(title: Localization.main.OK, style: .done, target: self, action: #selector(onSaveAction))
        
        self.navigationItem.leftBarButtonItem = btnClose
        self.navigationItem.rightBarButtonItem = btnOK
    }
    
    @objc func onCloseAction() {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func onSaveAction() {
        if date == nil {
            return
        }

        self.delegate?.onDateTimeSelection(date!)
        self.dismiss(animated: true, completion: {})
    }
    
    @objc private func onCurrentAction() {
        self.date = Date()
    }
}
