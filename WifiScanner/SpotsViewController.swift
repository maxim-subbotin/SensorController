//
//  SpotsViewController.swift
//  WifiScanner
//
// 9/20/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import SystemConfiguration

class SpotsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView = SpotsCollectionView()
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
        
        self.view.backgroundColor = ColorScheme.current.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = ColorScheme.current.navigationBarColor
        self.navigationController?.navigationBar.tintColor = ColorScheme.current.navigationTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorScheme.current.navigationTextColor]
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddAction))
        self.navigationItem.rightBarButtonItem = btnAdd
        
        let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshAction))
        self.navigationItem.leftBarButtonItem = btnRefresh
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(SpotCollectionViewCell.self, forCellWithReuseIdentifier: "spotCell")
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let tC = collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70)
        let bC = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        let wC = collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        NSLayoutConstraint.activate([cxC, tC, bC, wC])
    }

    @objc func onAddAction() {
        let vc = SpotEditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onRefreshAction() {
        self.collectionView.reloadData()
    }
    
    //MARK: - table delegates
    
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
 */
    
    //MARK: - collection delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotCell", for: indexPath) as! SpotCollectionViewCell
        cell.stopAnimation()
        let spot = spots[indexPath.row]
        cell.spot = spot
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDemoSpot()
        return
        
        let spot = spots[indexPath.row]
        if spot.ssid == currentSsid {
            openSpot(spot)
            return
        }
        
        if let cell = collectionView.visibleCells.filter({ $0 is SpotCollectionViewCell && ($0 as! SpotCollectionViewCell).spot?.ssid == spot.ssid }).first {
            (cell as! SpotCollectionViewCell).startAnimation()
        }
        
        if #available(iOS 11.0, *) {
            let hotspotConfig = NEHotspotConfiguration(ssid: spot.ssid, passphrase: spot.password, isWEP: false)
            NEHotspotConfigurationManager.shared.apply(hotspotConfig, completionHandler: { (error) in
                if error != nil {
                    let msg = error!.localizedDescription
                    let alert = UIAlertController(title: "Connection error", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.collectionView.reloadData()
                    
                    return
                }
                
                if let ip = Tools.getIPAddress() {
                    print("Connected to network \(spot.ssid) successfully. IP: \(ip)")
                    self.openSpot(spot)
                } else {
                    print("Unable to connect: \(spot.ssid)")
                }
                
                
                self.collectionView.reloadData()
            })
        } else {
            openSpot(spot)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIDevice.current.isiPad ?
            (UIScreen.main.bounds.width - 20) / 2 :
            (UIScreen.main.bounds.width - 10)
        return CGSize(width: w, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func openSpot(_ spot: Spot) {
        let vc = SpotViewController()
        vc.spot = spot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openDemoSpot() {
        let vc = SpotViewController()
        vc.spot = Spot.demo
        vc.spotState = SpotState.demo
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: - actions
    
    func onSpotDelete(_ spot: Spot) {
        
    }
    
    func onSpotEdit(_ spot: Spot) {
        
    }
}
