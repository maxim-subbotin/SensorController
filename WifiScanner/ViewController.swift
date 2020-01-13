//
//  ViewController.swift
//  WifiScanner
//
// 9/17/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*let hotspotConfig = NEHotspotConfiguration(ssid: "ASUS")
        NEHotspotConfigurationManager.shared.apply(hotspotConfig, completionHandler: {[unowned self] (error) in
            print("OPKKKK")
        })*/
        
        /*let storedSSIDs = NEHotspotConfigurationManager.shared.getConfiguredSSIDs(completionHandler: {(ssidArray) in
            for ssid in ssidArray {
                print("ssid")
            }
        })*/
        
        /*let hostUrl: String = "192.168.0.1"
        let pingInterval:TimeInterval = 3
        let timeoutInterval:TimeInterval = 4
        let configuration = PingConfiguration(pInterval:pingInterval, withTimeout:  timeoutInterval)

        print(configuration)
        
        SwiftPing.ping(host: hostUrl, configuration: configuration, queue: DispatchQueue.main) { (ping, error) in
            print("\(ping)")
            print("\(error)")
        }
        
        SwiftPing.pingOnce(host: hostUrl, configuration: configuration, queue: DispatchQueue.global()) { (response: PingResponse) in
            print("\(response.duration)")
            print("\(response.ipAddress)")
            print("\(response.error)")
        }

        let host = BDHost.hostname(forAddress: hostUrl)
        let addr = BDHost.ipAddresses
        let mac = BDHost.ethernetAddresses*/
        
        /*let options: [String: NSObject] = [kNEHotspotHelperOptionDisplayName : "Join this WIFI" as NSObject]
        let queue: DispatchQueue = DispatchQueue(label: "com.barsuk", attributes: DispatchQueue.Attributes.concurrent)
        
        NSLog("Started wifi scanning.")
        
        NEHotspotHelper.register(options: options, queue: queue) { (cmd: NEHotspotHelperCommand) in
            NSLog("Received command: \(cmd.commandType.rawValue)")
        }*/
        
        
        /*let interfaces = NEHotspotHelper.supportedNetworkInterfaces()
        if interfaces != nil {
            for hotspotNetwork in interfaces! {
                if hotspotNetwork is NEHotspotNetwork {
                    let network = hotspotNetwork as! NEHotspotNetwork
                    print("\(network.ssid) - \(network.bssid)")
                }
            }
        }*/
    }


}

