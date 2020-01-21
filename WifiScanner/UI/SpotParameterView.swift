//
//  SpotParameterView.swift
//  WifiScanner
//
//  1/16/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotParameterView: UIView {
    private var lblTitle = UILabel()
    private var lblValue = UILabel()
    public var title: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    public var value: String? {
        get {
            return lblValue.text
        }
        set {
            lblValue.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        let offset = CGFloat(10)
        
        self.addSubview(lblTitle)
        lblTitle.textAlignment = .left
        lblTitle.textColor = ColorScheme.current.spotParameterTitleColor
        lblTitle.font = UIFont.systemFont(ofSize: 20)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lC = lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset)
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2 * offset)
        let hC = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.addSubview(lblValue)
        lblValue.textAlignment = .right
        lblValue.textColor = ColorScheme.current.spotParameterValueColor
        lblValue.font = UIFont.systemFont(ofSize: 20)
        lblValue.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblValue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset)
        let tC1 = lblValue.topAnchor.constraint(equalTo: self.topAnchor)
        let wC1 = lblValue.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2 * offset)
        let hC1 = lblValue.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
        
        self.backgroundColor = ColorScheme.current.spotParameterBackgroundColor
    }
}

class SpotParameterViewCell: UITableViewCell {
    internal var paramView = SpotParameterView()
    private var _type: ParameterType?
    public var type: ParameterType? {
        get {
            return _type
        }
        set {
            _type = newValue
            paramView.title = _type?.title
        }
    }
    public var valueTitle: String? {
        get {
            return paramView.value
        }
        set {
            paramView.value = newValue
        }
    }
    public var value: Any?
    public weak var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyUI()
    }
    
    func applyUI() {
        let offset = CGFloat(10)
        
        self.contentView.addSubview(paramView)
        paramView.layer.cornerRadius = 5
        paramView.clipsToBounds = true
        paramView.translatesAutoresizingMaskIntoConstraints = false
        let lC = paramView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: offset)
        let tC = paramView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: offset / 2)
        let wC = paramView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -2 * offset)
        let hC = paramView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -offset)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.paramView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.paramView.addGestureRecognizer(tapGesture)
    }
    
    @objc internal func onTap(_ gesture: UITapGestureRecognizer) {
        print("Tap on cell with type: \(type?.title ?? "--")")
    }
}

protocol SpotEnumParameterViewCellDelegate: class {
    func onEnumParameterSelection(_ val: ValueSelectorItem, forParam param: ParameterType)
}

class SpotEnumParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate, ValueSelectionViewDelegate {
    public var values = [ValueSelectorItem]()
    public var selectedValue: ValueSelectorItem?
    public weak var delegate: SpotEnumParameterViewCellDelegate?
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = ValueSelectorViewController()
        vc.selectionDelegate = self
        vc.values = self.values
        vc.selectedValue = self.selectedValue
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 60 * self.values.count)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: nil)
    }
    
    func onValueSelection(_ val: ValueSelectorItem) {
        if let type = self.type {
            delegate?.onEnumParameterSelection(val, forParam: type)
        }
    }
}
