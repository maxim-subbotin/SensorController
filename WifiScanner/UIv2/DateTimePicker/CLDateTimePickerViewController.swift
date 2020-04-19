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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Date and time"
        self.view.backgroundColor = .white
        
        self.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let tC = pickerView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let lC = pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let rC = pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let bC = pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        
        //let bundle = Bundle(for: CLCalendarView.self)
        //let okImg = UIImage(named: "cl_ok_icon", in: bundle, compatibleWith: nil)
        //let closeImg = UIImage(named: "cl_close_icon", in: bundle, compatibleWith: nil)
        
        //let btnClose = UIBarButtonItem(image: closeImg?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(onCloseAction))
        //let btnOK = UIBarButtonItem(image: okImg?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(onSaveAction))
        
        let btnClose = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(onCloseAction))
        let btnOK = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(onSaveAction))
        
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
}
