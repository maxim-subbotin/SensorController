//
//  CalibratorView.swift
//  WifiScanner
//
//  1/21/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class CalibratorScaleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.close()
        UIColor.white.setStroke()
        path.stroke()
        
        //draw main lines: -5...5
        var step = rect.width / CGFloat(10)
        var x = CGFloat(0)
        for i in 0...10 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height / 2))
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            
            x += step
        }
        
        //draw detail lines: 0.1
        step = rect.width / CGFloat(100)
        x = CGFloat(0)
        for i in 0...100 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height / 4))
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            
            x += step
        }
    }
}

class CalibrationPointView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.close()
        ColorScheme.current.calibratorPointColor.setFill()
        ColorScheme.current.calibratorPointColor.setStroke()
        path.fill()
        path.stroke()
    }
}

class CalibratorView: UIView {
    private var pointerView = CalibrationPointView()
    private var calibratorScrollView = UIScrollView()
    private var calibratorView = CalibratorScaleView(frame: CGRect(x: 0, y: 0, width: 1000, height: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        self.addSubview(pointerView)
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = pointerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let tC = pointerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = pointerView.widthAnchor.constraint(equalToConstant: 20)
        let hC = pointerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.333)
        NSLayoutConstraint.activate([cxC, tC, wC, hC])
        
        self.addSubview(calibratorScrollView)
        calibratorScrollView.translatesAutoresizingMaskIntoConstraints = false
        let cxC1 = calibratorScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let tC1 = calibratorScrollView.topAnchor.constraint(equalTo: pointerView.bottomAnchor, constant: 0)
        let wC1 = calibratorScrollView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC1 = calibratorScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([cxC1, tC1, wC1, hC1])
        
        calibratorScrollView.addSubview(calibratorView)
        calibratorScrollView.bounces = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        calibratorView.frame = CGRect(x: rect.width / 2, y: 0, width: 1000, height: rect.height * 0.66666)
        calibratorScrollView.contentSize = CGSize(width: 1000 + rect.width, height: rect.height * 0.66666)
    }
}

class CalibratorViewController: UIViewController {
    private var calibratorView = CalibratorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
    }
    
    func applyUI() {
        self.view.backgroundColor = ColorScheme.current.selectorMenuBackgroundColor
        
        self.view.addSubview(calibratorView)
        calibratorView.translatesAutoresizingMaskIntoConstraints = false
        let lC = calibratorView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let tC = calibratorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let wC = calibratorView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        let hC = calibratorView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        NSLayoutConstraint.activate([lC, tC, wC, hC])
    }
}

class SpotCalibrationParameterViewCell: SpotParameterViewCell, UIPopoverPresentationControllerDelegate {
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = CalibratorViewController()
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 120)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: nil)
    }
}
