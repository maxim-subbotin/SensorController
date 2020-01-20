//
//  ValueSelectionView.swift
//  WifiScanner
//
//  1/19/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class ValueSelectorItem {
    public var title: String
    public var value: Any
    
    init(withTitle t: String, andValue v: Any) {
        self.title = t
        self.value = v
    }
}

class ValueSelectionViewCell: UITableViewCell {
    private var checkView = UIView()
    private var titleView = UILabel()
    public var title: String? {
        get {
            return titleView.text
        }
        set {
            titleView.text = newValue
        }
    }
    public var titleFont: UIFont {
        get {
            return titleView.font
        }
        set {
            titleView.font = newValue
        }
    }
    public var titleColor: UIColor {
        get {
            return titleView.textColor
        }
        set {
            titleView.textColor = newValue
        }
    }
    private var _isSelected = false
    public var choosed: Bool {
        get {
            return _isSelected
        }
        set {
            _isSelected = newValue
            
            checkView.layer.borderColor = ColorScheme.current.selectorCheckboxBorderColor.cgColor
            checkView.layer.borderWidth = 1
            UIView.animate(withDuration: 0.25, animations: {
                self.checkView.backgroundColor = self._isSelected ? ColorScheme.current.selectorCheckboxBackgroundColor : .clear
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        let offset = CGFloat(10)
        let checkboxSize = CGFloat(20)
        
        self.contentView.addSubview(checkView)
        checkView.layer.cornerRadius = checkboxSize / 2
        checkView.translatesAutoresizingMaskIntoConstraints = false
        let lC = checkView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: offset)
        let tC = checkView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        let wC = checkView.widthAnchor.constraint(equalToConstant: checkboxSize)
        let hC = checkView.heightAnchor.constraint(equalToConstant: checkboxSize)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
        
        self.contentView.addSubview(titleView)
        titleView.textColor = ColorScheme.current.selectorMenuTextColor
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = titleView.leftAnchor.constraint(equalTo: self.checkView.rightAnchor, constant: offset)
        let tC1 = titleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        let wC1 = titleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        let hC1 = titleView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)
        NSLayoutConstraint.activate([lC1, tC1, wC1, hC1])
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.contentView.backgroundColor = .clear
    }
}

protocol ValueSelectionViewDelegate: class {
    func onValueSelection(_ val: ValueSelectorItem)
}

class ValueSelectionView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private var _values = [ValueSelectorItem]()
    public var values: [ValueSelectorItem] {
        get {
            return _values
        }
        set {
            _values = newValue
            reloadData()
        }
    }
    public weak var selectionDelegate: ValueSelectionViewDelegate?
    public var selectedValue: ValueSelectorItem?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyUI() {
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        self.register(ValueSelectionViewCell.self, forCellReuseIdentifier: "valueCell")
    }
    
    //MARK: - table delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valueCell") as! ValueSelectionViewCell
        let val = values[indexPath.row]
        
        let isSelected = selectedValue != nil && selectedValue!.title == val.title
        cell.choosed = isSelected
        cell.titleFont = isSelected ? UIFont.boldSystemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
        cell.titleColor = isSelected ? ColorScheme.current.selectorMenuTextColor : ColorScheme.current.selectorCheckboxBorderColor
        cell.title = val.title
        cell.contentView.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        cell.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        cell.textLabel?.textColor = ColorScheme.current.selectorMenuTextColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let val = values[indexPath.row]
        
        for cell in tableView.visibleCells {
            if cell is ValueSelectionViewCell {
                let valCell = cell as! ValueSelectionViewCell
                if valCell.title == val.title {
                    valCell.choosed = true
                } else {
                    valCell.choosed = false
                }
            }
        }

        self.selectionDelegate?.onValueSelection(val)
    }

}

class ValueSelectorViewController: UIViewController, ValueSelectionViewDelegate {
    private var viewSelector = ValueSelectionView()
    public var values: [ValueSelectorItem] {
        get {
            return viewSelector.values
        }
        set {
            viewSelector.values = newValue
        }
    }
    private weak var _selectionDelegate: ValueSelectionViewDelegate?
    public weak var selectionDelegate: ValueSelectionViewDelegate? {
        get {
            return _selectionDelegate
        }
        set {
            _selectionDelegate = newValue
            viewSelector.selectionDelegate = _selectionDelegate
        }
    }
    public var selectedValue: ValueSelectorItem? {
        get {
            return viewSelector.selectedValue
        }
        set {
            viewSelector.selectedValue = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(viewSelector)
        viewSelector.selectionDelegate = self
        viewSelector.translatesAutoresizingMaskIntoConstraints = false
        let lC = viewSelector.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = viewSelector.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = viewSelector.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = viewSelector.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
    
    func onValueSelection(_ val: ValueSelectorItem) {
        self.dismiss(animated: true, completion: nil)
        
        self.selectionDelegate?.onValueSelection(val)
    }
}
