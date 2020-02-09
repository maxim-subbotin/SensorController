//
//  SpotIndicatorView.swift
//  WifiScanner
//
//  1/14/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotIndicatorView: UIView {
    private var lineWidth = CGFloat(3)
    private var radius1 = CGFloat(0.25)
    private var radius2 = CGFloat(0.5)
    private var _lineColor: UIColor = .white
    public var lineColor: UIColor {
        get {
            return _lineColor
        }
        set {
            _lineColor = newValue
            self.setNeedsDisplay()
        }
    }
    public var animateColor: UIColor = .white
    public var isAnimation = false
    private var animatePhase = 0
    private var animateStep = 0.25
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let r = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        let color1 = isAnimation && animatePhase == 0 ? self.animateColor : self.lineColor
        let color2 = isAnimation && animatePhase == 1 ? self.animateColor : self.lineColor
        let color3 = isAnimation && animatePhase == 2 ? self.animateColor : self.lineColor
        
        let path1 = UIBezierPath(arcCenter: center, radius: lineWidth / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        color1.setFill()
        color1.setStroke()
        path1.fill()
        path1.stroke()
        
        let path2 = UIBezierPath(arcCenter: center, radius: r * radius1, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path2.lineWidth = lineWidth
        color2.setStroke()
        path2.stroke()
        
        let path3 = UIBezierPath(arcCenter: center, radius: r * radius2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path3.lineWidth = lineWidth
        color3.setStroke()
        path3.stroke()
    }
    
    func animate() {
        animatePhase = 0
        
        timer?.invalidate()
        
        isAnimation = true
        timer = Timer.scheduledTimer(withTimeInterval: animateStep, repeats: true, block: {_ in
            self.animatePhase += 1
            if self.animatePhase > 2 {
                self.animatePhase = 0
            }
            
            self.setNeedsDisplay()
        })
        
        /*Timer(timeInterval: animateStep, repeats: true, block: {timer in
            self.animatePhase += 1
            if self.animatePhase > 2 {
                self.animatePhase = 0
            }
            
            self.setNeedsDisplay()
        })*/
    }
    
    func stopAnimate() {
        animatePhase = 0
        isAnimation = false
        timer?.invalidate()
        timer = nil
        
        self.setNeedsDisplay()
    }
}
