//
//  SpotEditViewController.swift
//  WifiScanner
//
// 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotEditViewController: UIViewController {
    private var lblName = UILabel()
    private var txtName = UITextFieldExt()
    private var lblSsid = UILabel()
    private var txtSsid = UITextFieldExt()
    private var lblPassword = UILabel()
    private var txtPassword = UITextFieldExt()
    private var lblPort = UILabel()
    private var txtPort = UITextFieldExt()
    private var lblDescription = UILabel()
    private var txtDescription = UITextView()
    public var isModal = false
    public var spot: Spot? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = (spot != nil && spot!.name != nil) ? spot!.name : "New spot"
        self.view.backgroundColor = ColorScheme.current.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ColorScheme.current.navigationBarColor
        self.navigationController?.navigationBar.tintColor = ColorScheme.current.navigationTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorScheme.current.navigationTextColor]
        
        initUI()
        
        let btnOK = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(onActionOK))
        self.navigationItem.rightBarButtonItem = btnOK
        
        self.preferredContentSize = CGSize(width: 480, height: 480)
    }
    
    func initUI() {
        let views = [lblName, txtName, lblSsid, txtSsid, lblPassword, txtPassword, lblPort, txtPort, lblDescription, txtDescription]
        for v in views {
            self.view.addSubview(v)
        }
        
        lblName.text = "Name"
        lblSsid.text = "Ssid"
        lblPassword.text = "Password"
        lblPort.text = "Port"
        lblDescription.text = "Description"
        
        let leftOffset = CGFloat(10)
        let yOffset = CGFloat(10)
        let lblHeight = CGFloat(30)
        let txtHeight = CGFloat(40)
        var prevView:UIView? = nil
        var i = 0
        for v in views {
            var h = CGFloat(30)
            if v is UILabel {
                h = lblHeight
                (v as! UILabel).textColor = ColorScheme.current.spotCellDetailColor
            }
            if v is UITextFieldExt {
                h = txtHeight
                v.backgroundColor = ColorScheme.current.spotCellBackgroundColor
                v.layer.cornerRadius = 5
                v.layer.borderWidth = 1
                v.layer.borderColor = ColorScheme.current.spotCellDetailColor.cgColor
                (v as! UITextFieldExt).padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                (v as! UITextField).textColor = ColorScheme.current.spotCellTitleColor
                //(v as! UITextField).valueDelegate = self
            }
            if v is UITextView {
                h = txtHeight * 3
                v.backgroundColor = ColorScheme.current.spotCellBackgroundColor
                v.layer.cornerRadius = 5
                v.layer.borderWidth = 1
                v.layer.borderColor = ColorScheme.current.spotCellDetailColor.cgColor
                //(v as! UITextField).padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                (v as! UITextView).textColor = ColorScheme.current.spotCellTitleColor
                (v as! UITextView).font = UIFont.systemFont(ofSize: 17)
            }
            
            v.frame = .zero
            v.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = prevView == nil ? NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 64 + yOffset) :
                NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: prevView, attribute: .bottom, multiplier: 1, constant: yOffset)
            let leftConstraint = NSLayoutConstraint(item: v, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant:leftOffset)
            let rightConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant:-2*leftOffset)
            let heightConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: h)
            heightConstraint.identifier = "height_constraint_\(i)"
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
            prevView = v
            
            i += 1
        }
    }
    
    @objc func onActionOK() {
        if isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
