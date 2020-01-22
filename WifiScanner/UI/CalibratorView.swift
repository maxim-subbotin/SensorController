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

            let lbl = UILabel()
            lbl.text = "\(i - 5)°"
            lbl.frame = CGRect(x: x - 20, y: rect.height / 2, width: 40, height: 25)
            lbl.textAlignment = .center
            lbl.textColor = .white
            self.addSubview(lbl)
            
            x += step
        }
        
        //draw detail lines: 0.5
        x = step / 2
        for i in 0...10 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height * 0.36))
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
            path.addLine(to: CGPoint(x: x, y: rect.height * 0.2))
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

class CalibratorView: UIView, UIScrollViewDelegate {
    private var pointerView = CalibrationPointView()
    private var calibratorScrollView = UIScrollView()
    private var calibratorView = CalibratorScaleView(frame: CGRect(x: 0, y: 0, width: 1000, height: 30))
    private var lblValue = UILabel()
    private var scaleHeight = CGFloat(70)
    private var _value: CGFloat = -10
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            lblValue.text = "\(String(format: "%.1f", _value))°"
            let offset = (_value + 5) * 0.1 * calibratorView.frame.width
            calibratorScrollView.contentOffset = CGPoint(x: offset, y: 0)
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
        self.addSubview(pointerView)
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = pointerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let tC = pointerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let wC = pointerView.widthAnchor.constraint(equalToConstant: 20)
        let hC = pointerView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([cxC, tC, wC, hC])
        
        self.addSubview(calibratorScrollView)
        calibratorScrollView.delegate = self
        calibratorScrollView.translatesAutoresizingMaskIntoConstraints = false
        let cxC1 = calibratorScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let tC1 = calibratorScrollView.topAnchor.constraint(equalTo: pointerView.bottomAnchor, constant: 0)
        let wC1 = calibratorScrollView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC1 = calibratorScrollView.heightAnchor.constraint(equalToConstant: scaleHeight)
        NSLayoutConstraint.activate([cxC1, tC1, wC1, hC1])
        if value != -10 {
            let offset = (_value + 5) * 0.1 * calibratorView.frame.width
            calibratorScrollView.contentOffset = CGPoint(x: offset, y: 0)
        }
        
        calibratorScrollView.addSubview(calibratorView)
        calibratorScrollView.bounces = false
        
        self.addSubview(lblValue)
        lblValue.textAlignment = .center
        lblValue.text = ""
        lblValue.textColor = .white
        lblValue.font = UIFont.boldSystemFont(ofSize: 60)
        lblValue.translatesAutoresizingMaskIntoConstraints = false
        let cxC2 = lblValue.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let tC2 = lblValue.topAnchor.constraint(equalTo: calibratorScrollView.bottomAnchor, constant: 0)
        let wC2 = lblValue.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC2 = lblValue.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([cxC2, tC2, wC2, hC2])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        calibratorView.frame = CGRect(x: rect.width / 2, y: 0, width: 1000, height: scaleHeight)
        calibratorScrollView.contentSize = CGSize(width: 1000 + rect.width, height: scaleHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let val = (x / calibratorView.frame.width) * 10 - 5
        _value = round(val * 10) * 0.1
        lblValue.text = "\(String(format: "%.1f", _value))°"
    }
}

class CalibratorViewController: UIViewController {
    private var calibratorView = CalibratorView()
    private var _value: CGFloat = 0
    public var value: CGFloat {
        get {
            return _value
        }
        set {
            _value = newValue
            calibratorView.value = _value
        }
    }
    
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
    private var _calibration: CGFloat = 0
    public var calibration: CGFloat {
        get {
            return _calibration
        }
        set {
            _calibration = newValue
        }
    }
    
    override func onTap(_ gesture: UITapGestureRecognizer) {
        super.onTap(gesture)
        
        let vc = CalibratorViewController()
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 300, height: 220)
        popover?.delegate = self
        popover?.sourceView = self.paramView
        popover?.sourceRect = CGRect(x: self.paramView.frame.width - 30, y: self.paramView.frame.height / 2, width: 1, height: 1)
        
        self.viewController?.present(vc, animated: true, completion: {
            vc.value = self._calibration
        })
    }
}
