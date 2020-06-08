//
//  File.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol ConvectorDateTimeViewDelegate: class {
    func onDateSelected(_ date: Date)
}

class ConvectorDateTimeView: UIView, CLDateTimePickerViewControllerDelegate {
    private var lblDate = UILabel()
    private var lblTime = UILabel()
    private var _date = Date()
    public var date: Date {
        get {
            return _date
        }
        set {
            _date = newValue
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.locale = Locale.current
            
            lblTime.text = formatter.string(from: _date)
            
            formatter.dateStyle = .none
            formatter.timeStyle = .none
            formatter.dateFormat = "EEEE, dd MMMM"
            lblDate.text = formatter.string(from: _date)
        }
    }
    public weak var viewController: UIViewController?
    public weak var delegate: ConvectorDateTimeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.addSubview(lblTime)
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTime.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let cxC = lblTime.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let wC = lblTime.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC = lblTime.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, cxC, wC, hC])
        lblTime.textAlignment = .center
        lblTime.textColor = .white
        lblTime.font = UIFont.customFont(bySize: 54)
        
        self.addSubview(lblDate)
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblDate.topAnchor.constraint(equalTo: lblTime.bottomAnchor, constant: 0)
        let cxC1 = lblDate.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let wC1 = lblDate.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC1 = lblDate.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([tC1, cxC1, wC1, hC1])
        lblDate.textAlignment = .center
        lblDate.textColor = .white
        lblDate.font = UIFont.customFont(bySize: 20)
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap() {
        let vc = CLDateTimePickerViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.topOffset = 50
        vc.date = self.date
        vc.delegate = self
        viewController?.present(navVC, animated: true, completion: nil)
    }
    
    func onDateTimeSelection(_ date: Date) {
        delegate?.onDateSelected(date)
    }
}
