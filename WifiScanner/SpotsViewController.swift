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

class SpotsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SpotEditViewControllerDelegate, SpotCollectionViewCellDelegate {
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
        spots = Spot.getSavedSpots().sorted(by: { $0.order < $1.order })
        
        /*let varmann = Spot(withSSid: "Varmann", andPassword: "Varmann12345678")
        varmann.name = "Varmann device"
        
        let snp = Spot(withSSid: "garage_ntwrk", andPassword: "snapp11app")
        snp.name = "Garage"
        
        let gb = Spot(withSSid: "lvng_rm", andPassword: "12345678")
        gb.name = "Living room"
        
        let brn = Spot(withSSid: "barn", andPassword: "12345678")
        brn.name = "Barn"
        
        let grn = Spot(withSSid: "grn_house", andPassword: "12345678")
        grn.name = "Greenhouse"
        
        var i = 0
        for s in [varmann, snp, gb, brn, grn] {
            s.order = i
            i += 1
        }
        
        spots.append(varmann)
        spots.append(snp)
        spots.append(gb)
        spots.append(brn)
        spots.append(grn)*/
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Devices"
        
        self.view.backgroundColor = ColorScheme.current.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = ColorScheme.current.navigationBarColor
        self.navigationController?.navigationBar.tintColor = ColorScheme.current.navigationTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorScheme.current.navigationTextColor]
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddAction))
        self.navigationItem.rightBarButtonItem = btnAdd
        
        //let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshAction))
        //self.navigationItem.leftBarButtonItem = btnRefresh
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(SpotCollectionViewCell.self, forCellWithReuseIdentifier: "spotCell")
        
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = ColorScheme.current.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let tC = collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70)
        let bC = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        let wC = collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        NSLayoutConstraint.activate([cxC, tC, bC, wC])
        
        let btnDemo = UIBarButtonItem(title: "Demo", style: .done, target: self, action: #selector(onDemo))
        self.navigationItem.leftBarButtonItem = btnDemo
    }

    @objc func onAddAction() {
        let vc = SpotAddingHelperViewController()
        self.present(vc, animated: true, completion: nil)
        
        //let vc = SpotEditViewController()
        //vc.delegate = self
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onRefreshAction() {
        self.collectionView.reloadData()
    }

    //MARK: - collection delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotCell", for: indexPath) as! SpotCollectionViewCell
        cell.stopAnimation()
        let spot = spots[indexPath.row]
        cell.spot = spot
        cell.isCurrentNetwork = spot.ssid == currentSsid
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                
                if self.currentSsid == spot.ssid {
                    if let ip = Tools.getIPAddress() {
                        print("Connected to network \(spot.ssid) successfully. IP: \(ip)")
                        self.openSpot(spot)
                    }
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
        let colNumber = 1 //UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
        let w = UIDevice.current.isiPad ?
            (UIScreen.main.bounds.width - CGFloat(10 * colNumber)) / CGFloat(colNumber) :
            (UIScreen.main.bounds.width - 10)
        return CGSize(width: w, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func openSpot(_ spot: Spot) {
        let vc = ConvectorViewController() //SpotViewController()
        vc.spot = spot
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    func openDemoSpot(_ indexPath: IndexPath) {
        let spt = spots[indexPath.row]
        let vc = SpotViewController()
        vc.spot = spt
        vc.spotState = SpotState.demo
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: - actions
    
    func onSpotDelete(_ spot: Spot) {
        
    }
    
    func onSpotEdit(_ spot: Spot) {
        
    }
    
    //MARK: - rotate
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.reloadData()
        
        /*guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //here you can do the logic for the cell size if phone is in landscape
        } else {
            //logic if not landscape
        }
        
        flowLayout.invalidateLayout()*/
    }
    
    //MARK: - demo action
    
    @objc func onDemo() {
        let spot = Spot(withSSid: "garage_ntwrk", andPassword: "snapp11app")
        spot.name = "Qtech - Гараж"
        
        let vc = ConvectorViewController()
        vc.mode = .demo
        vc.spot = spot
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
        
        /*
        
        let vc = SpotViewController()
        vc.mode = .demo
        vc.spot = spot
        vc.spotState = SpotState.demo
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    //MARK: - spot add & edit
    
    func onSpotEditing(_ spot: Spot) {
        spot.save()
        if let index = spots.firstIndex(where: { $0.id == spot.id }) {
            spots[index] = spot
        }
        self.collectionView.reloadData()
    }
    
    func onSpotAdding(_ spot: Spot) {
        var maxCount = 0
        for spot in spots {
            maxCount = max(spot.order, maxCount)
        }
        
        spot.order = maxCount + 1
        spot.save()
        self.spots.append(spot)
        self.collectionView.reloadData()
    }
    
    //MARK: - spot cell menu
    
    func onMenuTap(forView view: UIView, andSpot spot: Spot) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            self.onSpotEditAction(spot)
        }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            self.onSpotDeleteAction(spot)
        }))
        
        if UIDevice.current.isiPad {
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width - 20, y: view.frame.height / 2, width: 1, height: 1)
            
        } else {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("cancel")
            }))
        }
        
        self.present(alert, animated: true, completion: {
            //
        })
    }
    
    func onSpotEditAction(_ spot: Spot) {
        let vc = SpotEditViewController()
        vc.mode = .edit
        vc.spot = spot
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onSpotDeleteAction(_ spot: Spot) {
        spot.delete()
        if let index = spots.firstIndex(where: { $0.id == spot.id }) {
            spots.remove(at: index)
        }
        self.collectionView.reloadData()
    }
}
