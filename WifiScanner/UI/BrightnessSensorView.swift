//
//  BrightnessSensorView.swift
//  WifiScanner
//
//  1/20/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class BrightnessCellView: UIView {
    public var number: Int = 0
}

protocol BrightnessSensorViewDelegate: class {
    func onBrightnessLevel(_ level: Int)
}

class BrightnessSensorView: UIView {
    private var cells = [BrightnessCellView]()
    private var _level: Int = 3
    public var level: Int {
        get {
            return _level
        }
        set {
            _level = newValue
            for cell in cells {
                cell.backgroundColor = cell.number <= _level ?
                                        ColorScheme.current.brightnessSelectedCellColor :
                                        ColorScheme.current.brightnessDeselectedCellColor
                if cell.number <= _level {
                    cell.layer.shadowColor = UIColor.white.cgColor
                    cell.layer.shadowOpacity = 1
                    cell.layer.shadowOffset = .zero
                    cell.layer.shadowRadius = 4
                } else {
                    cell.layer.shadowRadius = 0
                    cell.layer.shadowOpacity = 0
                }
            }
        }
    }
    public weak var delegate: BrightnessSensorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.isUserInteractionEnabled = true
        
        let offset = CGFloat(10)
        let height = CGFloat(14)
        
        var prevView: UIView?
        for i in 1...5 {
            let btn = BrightnessCellView()
            btn.number = i
            cells.append(btn)
            
            self.addSubview(btn)
            btn.layer.cornerRadius = height / 2
            btn.backgroundColor = ColorScheme.current.brightnessDeselectedCellColor
            btn.translatesAutoresizingMaskIntoConstraints = false
            let lC = prevView == nil ? btn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset) :
                btn.leftAnchor.constraint(equalTo: prevView!.rightAnchor, constant: offset)
            let tC = btn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            let wC = btn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2, constant: -12)
            let hC = btn.heightAnchor.constraint(equalToConstant: height)
            NSLayoutConstraint.activate([lC, tC, wC, hC])

            prevView = btn
            
            btn.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            btn.addGestureRecognizer(gesture)
        }
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        if let v = gesture.view {
            self.level = (v as! BrightnessCellView).number
            self.delegate?.onBrightnessLevel(self.level)
        }
    }
}

class BrightnessSensorViewController: UIViewController, BrightnessSensorViewDelegate {
    private var brSelector = BrightnessSensorView()
    public var level: Int {
        get {
            return brSelector.level
        }
        set {
            brSelector.level = newValue
        }
    }
    public weak var delegate: BrightnessSensorViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(brSelector)
        brSelector.delegate = self
        brSelector.translatesAutoresizingMaskIntoConstraints = false
        let lC = brSelector.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = brSelector.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = brSelector.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = brSelector.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
    
    func onBrightnessLevel(_ level: Int) {
        self.delegate?.onBrightnessLevel(level)
    }
}

class SpotBrightnessParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate, BrightnessSensorViewDelegate {
    private var _level: Int = 0
    public var level: Int {
        get {
            return _level
        }
        set {
            _level = newValue
            self.valueTitle = "\(_level)"
        }
    }
    public weak var delegate: BrightnessSensorViewDelegate?
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = BrightnessSensorViewController()
        vc.level = _level
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 60)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: nil)
    }
    
    func onBrightnessLevel(_ level: Int) {
        self.level = level
        self.delegate?.onBrightnessLevel(level)
    }
}

class PopoverNavigationController: UINavigationController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let r = CGFloat(3)
        if r >= 0 && (view.superview?.layer.cornerRadius)! != r {
            view.superview?.layer.cornerRadius = r
        }
    }
}
