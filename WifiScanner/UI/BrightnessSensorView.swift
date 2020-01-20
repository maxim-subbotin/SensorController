//
//  BrightnessSensorView.swift
//  WifiScanner
//
//  1/20/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class BrightnessCellView: UIView {
    public var number: Int = 0
}

class BrightnessSensorView: UIView {
    private var cells = [BrightnessCellView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyUI() {
        let offset = CGFloat(10)
        let height = CGFloat(15)
        
        for i in 1...5 {
            let btn = BrightnessCellView()
            btn.number = i
            cells.append(btn)
            
            self.addSubview(btn)
        }
    }
}
