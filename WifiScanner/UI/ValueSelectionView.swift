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
    }
    
    //MARK: - table delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.text = values[indexPath.row].title
        cell.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        cell.textLabel?.textColor = ColorScheme.current.selectorMenuTextColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let val = values[indexPath.row]
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
