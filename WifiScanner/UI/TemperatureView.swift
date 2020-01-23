//
//  TemperatureView.swift
//  WifiScanner
//
//  1/23/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class TemperatureScaleView: CalibratorScaleView {
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.close()
        UIColor.white.setStroke()
        path.stroke()
        
        //draw main lines: 5...45
        var step = rect.width / CGFloat(40)
        var x = CGFloat(0)
        for i in 0...40 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height / 2))
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            
            let lbl = UILabel()
            lbl.text = "\(i + 5)°"
            lbl.frame = CGRect(x: x - 20, y: rect.height / 2, width: 40, height: 25)
            lbl.textAlignment = .center
            lbl.textColor = .white
            self.addSubview(lbl)
            
            x += step
        }
        
        //draw detail lines: 0.5
        x = step / 2
        for i in 0...40 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height * 0.4))
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            
            x += step
        }
        
        //draw detail lines: 0.1
        /*step = rect.width / CGFloat(100)
        x = CGFloat(0)
        for i in 0...100 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height * 0.2))
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            
            x += step
        }*/
    }
}

class TemperatureView: CalibratorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func applyUI() {
        self.calibratorView = TemperatureScaleView(frame: CGRect(x: 0, y: 0, width: 2000, height: 30))
        super.applyUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        calibratorView.frame = CGRect(x: rect.width / 2, y: 0, width: 2000, height: scaleHeight)
        calibratorScrollView.contentSize = CGSize(width: 2000 + rect.width, height: scaleHeight)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let val = (x / calibratorView.frame.width) * 40 + 5
        _value = round(val * 2) * 0.5
        lblValue.text = "\(String(format: "%.1f", _value))°"
        
        //delegate?.onCalibrationScaleChange(_value)
    }
}

class TemperatureViewController: CalibratorViewController {
    override func viewDidLoad() {
        self.calibratorView = TemperatureView()
        super.viewDidLoad()
    }
}
