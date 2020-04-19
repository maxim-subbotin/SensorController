//
//  CLDateTimeField.swift
//  CoreslabLib
//
//

import Foundation
import UIKit

protocol CLDateTimeFieldDelegate: class {
    func onDateTimeSelection(date: Date, inInput input: CLDateTimeField)
}

class CLDateTimeField: UIView, CLDateTimePickerViewControllerDelegate {
    private var lblTitle = UILabel()
    private var _date: Date?
    public var date: Date? {
        get {
            return _date
        }
        set {
            _date = newValue
            lblTitle.text = _date?.dateTimeFormat
        }
    }
    public var dateFormat: UIDatePicker.Mode {
        get {
            return .date
        }
        set {
            //
        }
    }
    public var font: UIFont {
        get {
            return lblTitle.font
        }
        set {
            lblTitle.font = newValue
        }
    }
    public var textColor: UIColor {
        get {
            return lblTitle.textColor
        }
        set {
            lblTitle.textColor = newValue
        }
    }
    public var format: String {
        get {
            return ""
        }
        set {
            
        }
    }
    public weak var delegate: CLDateTimeFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor)
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rC = lblTitle.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bC = lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([tC, lC, rC, bC])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func onTap() {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let vc = CLDateTimePickerViewController()
        vc.delegate = self
        vc.date = _date
        vc.preferredContentSize = CGSize(width: 500, height: 600)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        navVC.modalTransitionStyle = .crossDissolve
        navVC.preferredContentSize = CGSize(width: 500, height: 600)
        rootVC?.present(navVC, animated: true, completion: nil)
    }
    
    func onDateTimeSelection(_ date: Date) {
        self.date = date
        delegate?.onDateTimeSelection(date: date, inInput: self)
    }
}
