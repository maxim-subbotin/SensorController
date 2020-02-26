//
//  ConvectorBottomPanel.swift
//  WifiScanner
//
//  Created on 2/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

enum ConvectorBottomButtomType {
    case exit
    case manual
    case calendar
    case vacation
    case settings
}

class SelectedButton: UIImageView {
    public var selectImage: UIImage?
    public var unselectImage: UIImage?
    
    private var _selected = false
    public var selected: Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            self.image = _selected ? selectImage : unselectImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    init() {
        super.init(frame: .zero)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyUI() {
        self.contentMode = .scaleAspectFit
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    func refresh() {
        self.image = _selected ? selectImage : unselectImage
    }
    
    @objc private func onTap() {
        self.selected = !self.selected
    }
}

class ConvectorBottomButton: SelectedButton {
    public var type: ConvectorBottomButtomType = .exit
}

class ConvectorBottomPanel: UIView {
    private var buttons = [ConvectorBottomButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    struct ConvectorButton {
        public var selectedImage: UIImage?
        public var unselectedImage: UIImage?
        public var type: ConvectorBottomButtomType = .exit
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        var btns = [ConvectorButton]()
        btns.append(ConvectorButton(selectedImage: UIImage(named: "exit_icon_solid"), unselectedImage: UIImage(named: "exit_icon_hollow"), type: .exit))
        btns.append(ConvectorButton(selectedImage: UIImage(named: "finger_icon_solid"), unselectedImage: UIImage(named: "finger_icon_hollow"), type: .manual))
        btns.append(ConvectorButton(selectedImage: UIImage(named: "calendar_icon_solid"), unselectedImage: UIImage(named: "calendar_icon_hollow"), type: .calendar))
        btns.append(ConvectorButton(selectedImage: UIImage(named: "vacation_icon_solid"), unselectedImage: UIImage(named: "vacation_icon_hollow"), type: .vacation))
        btns.append(ConvectorButton(selectedImage: UIImage(named: "settings_icon_solid"), unselectedImage: UIImage(named: "settings_icon_hollow"), type: .settings))
        
        let w = CGFloat(1) / CGFloat(btns.count)
        var prevView: UIView?
        for b in btns {
            let button = ConvectorBottomButton()
            button.selectImage = b.selectedImage
            button.unselectImage = b.unselectedImage
            button.type = b.type
            button.refresh()
            buttons.append(button)
            self.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            let tC = button.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            let lC = prevView == nil ? button.leftAnchor.constraint(equalTo: self.leftAnchor) : button.leftAnchor.constraint(equalTo: prevView!.rightAnchor)
            let wC = button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: w)
            let hC = button.heightAnchor.constraint(equalTo: self.heightAnchor)
            NSLayoutConstraint.activate([tC, lC, wC, hC])
            
            prevView = button
        }
    }
}

