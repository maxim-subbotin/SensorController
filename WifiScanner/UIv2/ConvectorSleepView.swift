//
//  ConvectorSleepView.swift
//  WifiScanner
//
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ConvectorSleepView: UIView {
    private var picker = CLDateTimePickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onColorNotification(_:)), name: ColorScheme.changeBackgroundColor, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applyUI() {
        self.clipsToBounds = true
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        let tC = picker.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let lC = picker.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let wC = picker.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
        let hC = picker.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        picker.date = Date()
        picker.backgroundColor = .white
    }
    
    @objc func onColorNotification(_ notification: Notification) {
        if notification.object != nil && notification.object is UIColor {
            let color = notification.object as! UIColor
            self.backgroundColor = color
        }
    }
}
