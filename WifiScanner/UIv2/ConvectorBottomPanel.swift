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
    case fan
    case temperature
}

enum ConvectorIndicatorType {
    case cool
    case heat
    case valve
}

class SelectedImageButton: SelectedButton {
    public var selectImage: UIImage?
    public var unselectImage: UIImage?
    
    override public var selected: Bool {
        get {
            return super.selected
        }
        set {
            _selected = newValue
            self.image = _selected ? selectImage : unselectImage
        }
    }
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    init() {
        super.init(frame: .zero)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }*/
    
    /*override func applyUI() {
        self.contentMode = .scaleAspectFit
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
    }*/
    
    override func refresh() {
        self.image = _selected ? selectImage : unselectImage
    }
    
    /*@objc private func onTap() {
        self.selected = !self.selected
    }*/
}

protocol SelectedButtonDelegate: class {
    func onButtonSelection(_ selectedButton: SelectedButton)
}

class SelectedButton: UIImageView {
    public var selectColor = UIColor.blue
    public var unselectColor = UIColor.white
    public weak var delegate: SelectedButtonDelegate?
    public var selectOnly = true
    
    internal var _selected = false
    public var selected: Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            self.tintColor = _selected ? selectColor : unselectColor
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
        self.tintColor = _selected ? selectColor : unselectColor
    }
    
    @objc private func onTap() {
        if selectOnly && self.selected {
            return
        }
        self.selected = !self.selected
        self.delegate?.onButtonSelection(self)
    }
}

class ConvectorBottomButton: SelectedImageButton {
    public var type: ConvectorBottomButtomType = .exit
}

protocol ConvectorBottomPanelDelegate: class {
    func onBottomPanelAction(_ action: ConvectorBottomButtomType)
}

class ConvectorBottomPanel: UIView, SelectedButtonDelegate {
    private var buttons = [ConvectorBottomButton]()
    public weak var delegate: ConvectorBottomPanelDelegate?
    public var prevAction: ConvectorBottomButtomType?
    
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
            button.delegate = self
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
    
    func onButtonSelection(_ selectedButton: SelectedButton) {
        delegate?.onBottomPanelAction((selectedButton as! ConvectorBottomButton).type)
        prevAction = (selectedButton as! ConvectorBottomButton).type
        for btn in buttons {
            if btn.type != (selectedButton as! ConvectorBottomButton).type {
                btn.selected = false
            }
        }
    }
}

class IndicatorImage: UIImageView {
    public var type: ConvectorIndicatorType = .cool
}

class ConvectorIndicatorPanel: UIView {
    private var buttons = [IndicatorImage]()
    public var activeColor = UIColor(hexString: "#009CDF")
    public var inactiveColor = UIColor(hexString: "#DADADA")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    struct Indicator {
        public var type = ConvectorIndicatorType.cool
        public var image: UIImage?
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        var btns = [Indicator]()
        btns.append(Indicator(type: .cool, image: UIImage(named: "cool_icon")?.withRenderingMode(.alwaysTemplate)))
        btns.append(Indicator(type: .heat, image: UIImage(named: "heat_icon")?.withRenderingMode(.alwaysTemplate)))
        btns.append(Indicator(type: .valve, image: UIImage(named: "valve_icon")?.withRenderingMode(.alwaysTemplate)))
        
        let w = CGFloat(1) / CGFloat(btns.count)
        var prevView: UIView?
        for b in btns {
            let button = IndicatorImage()
            button.image = b.image
            button.type = b.type
            button.tintColor = inactiveColor
            button.contentMode = .scaleAspectFit
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
