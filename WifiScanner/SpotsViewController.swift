//
//  SpotsViewController.swift
//  WifiScanner
//
//  Created by Snappii on 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import SystemConfiguration

class SpotViewCell: UITableViewCell {
    private var backView = UIView()
    private var lblName = UILabel()
    private var lblDetails = UILabel()
    private var imgIcon = UIImageView()
    private var _spot: Spot?
    public var spot: Spot? {
        get {
            return _spot
        }
        set {
            _spot = newValue
            if _spot != nil {
                self.lblName.text = _spot!.name
                if _spot!.name == nil {
                    self.lblName.text = _spot!.ssid
                }
                self.lblDetails.text = "\(_spot!.ssid)  -  \(hidePassword(_spot!.password))"
            }
        }
    }
    public var iconTintColor: UIColor {
        get {
            return imgIcon.tintColor
        }
        set {
            imgIcon.tintColor = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI() {
        self.contentView.backgroundColor = UIColor(hexString: "#EDEDED")
        
        self.contentView.addSubview(backView)
        backView.frame = .zero
        backView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = self.backView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        let cyC = self.backView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        let wC = self.backView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1, constant: -20)
        let hC = self.backView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1, constant: -10)
        NSLayoutConstraint.activate([cxC, cyC, wC, hC])
        backView.backgroundColor = UIColor(hexString: "#DDDDDD")
        
        self.backView.addSubview(imgIcon)
        imgIcon.frame = .zero
        imgIcon.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = self.imgIcon.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 15)
        let cyC1 = self.imgIcon.centerYAnchor.constraint(equalTo: self.backView.centerYAnchor)
        let hC1 = self.imgIcon.heightAnchor.constraint(equalTo: self.backView.heightAnchor, constant: -30)
        let wC1 = self.imgIcon.widthAnchor.constraint(equalTo: self.backView.heightAnchor, constant: -30)
        NSLayoutConstraint.activate([lC1, cyC1, hC1, wC1])
        imgIcon.image = UIImage(named: "wifi_icon")?.withRenderingMode(.alwaysTemplate)
        imgIcon.tintColor = UIColor(hexString: "#AEB4A9")
        imgIcon.contentMode = .scaleAspectFit
        
        self.backView.addSubview(lblName)
        lblName.frame = .zero
        lblName.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = self.lblName.leftAnchor.constraint(equalTo: imgIcon.rightAnchor, constant: 20)
        let tC2 = self.lblName.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 10)
        let rC2 = self.lblName.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -10)
        let hC2 = self.lblName.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC2, tC2, rC2, hC2])
        lblName.textColor = UIColor(hexString: "#202020")
        lblName.font = UIFont.boldSystemFont(ofSize: 24)
        
        self.backView.addSubview(lblDetails)
        lblDetails.frame = .zero
        lblDetails.translatesAutoresizingMaskIntoConstraints = false
        let lC3 = self.lblDetails.leftAnchor.constraint(equalTo: lblName.leftAnchor)
        let tC3 = self.lblDetails.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 10)
        let bC3 = self.lblDetails.bottomAnchor.constraint(equalTo: imgIcon.bottomAnchor)
        let wC3 = self.lblDetails.widthAnchor.constraint(equalTo: lblName.widthAnchor)
        NSLayoutConstraint.activate([lC3, tC3, bC3, wC3])
        lblDetails.textColor = UIColor(hexString: "#606060")
        lblDetails.font = UIFont.systemFont(ofSize: 17)
    }
    
    func hidePassword(_ psw: String) -> String {
        if psw.count < 6 {
            return "****"
        } else {
            var str = ""
            for _ in 0...psw.count - 4 {
                str.append("*")
            }
            let index = psw.index(psw.endIndex, offsetBy: -4)
            let sub = psw[index...]
            let last4 = String(sub)
            str.append(last4)
            return str
        }
    }
}

class SpotsViewController: UITableViewController {
    private var spots = [Spot]()
    public var currentSsid: String {
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    for dictData in interfaceData! {
                        if dictData.key as! String == "SSID" {
                            currentSSID = dictData.value as! String
                        }
                    }
                }
            }
        }
        return currentSSID
    }
    
    override func viewDidLoad() {
        let varmann = Spot(withSSid: "Varmann", andPassword: "Varmann12345678")
        varmann.name = "Test device"
        
        let snp = Spot(withSSid: "Snappii_618", andPassword: "snapp11app")
        snp.name = "Snappii Network"
        
        let gb = Spot(withSSid: "Guest Baza", andPassword: "12345678")
        gb.name = "Random network"
        
        spots.append(varmann)
        spots.append(snp)
        spots.append(gb)
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Spot list"
        
        self.view.backgroundColor = UIColor(hexString: "#EDEDED")
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#C1CAD6")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#404040")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(hexString: "#404040")]
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddAction))
        self.navigationItem.rightBarButtonItem = btnAdd
        
        let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshAction))
        self.navigationItem.leftBarButtonItem = btnRefresh
        
        self.tableView.separatorStyle = .none
        self.tableView.register(SpotViewCell.self, forCellReuseIdentifier: "spotCell")
    }
    
    @objc func onAddAction() {
        let vc = SpotEditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onRefreshAction() {
        self.tableView.reloadData()
    }
    
    //MARK: - table delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spotCell") as! SpotViewCell
        let spot = spots[indexPath.row]
        cell.spot = spot
        cell.selectionStyle = .none
        if spot.ssid == currentSsid {
            cell.iconTintColor = UIColor(hexString: "#00629B")
        } else {
            cell.iconTintColor = UIColor(hexString: "#AEB4A9")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spot = spots[indexPath.row]
        if spot.ssid == currentSsid {
            openSpot(spot)
            return
        }

        if #available(iOS 11.0, *) {
            let hotspotConfig = NEHotspotConfiguration(ssid: spot.ssid, passphrase: spot.password, isWEP: false)
            NEHotspotConfigurationManager.shared.apply(hotspotConfig, completionHandler: { (error) in
                if error != nil {
                    let msg = error!.localizedDescription
                    let alert = UIAlertController(title: "Connection error", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.openSpot(spot)
                }
                self.tableView.reloadData()
            })
        } else {
            openSpot(spot)
        }
    }
    
    func openSpot(_ spot: Spot) {
        let vc = SpotViewController()
        vc.spot = spot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let spot = spots[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { action, index in
            self.onSpotDelete(spot)
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor(hexString: "#DB2B39")
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { action, index in
            self.onSpotEdit(spot)
        })
        editAction.backgroundColor = UIColor(hexString: "#00A9E0")
        
        /*let reorderAction = UITableViewRowAction(style: .normal, title: "Reorder", handler: { action, index in
         self.fieldListView.isEditing = true
         self.fieldListView.reloadData()
         })
         reorderAction.backgroundColor = UIColor(hexString: "#1FD19B")*/
        
        return [editAction, deleteAction]
    }
    
    //MARK: - actions
    
    func onSpotDelete(_ spot: Spot) {
        
    }
    
    func onSpotEdit(_ spot: Spot) {
        
    }
}
