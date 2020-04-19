//
//  SpotCardView.swift
//  WifiScanner
//
//  1/13/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

protocol SpotCardViewDelegate: class {
    func onMenuTap()
}

class SpotCardView: UIView {
    private var indicatorView = SpotIndicatorView()
    private var lblTitle = UILabel()
    private var lblDetail = UILabel()
    private var viewDots = UIImageView()
    private var _spot: Spot?
    public var spot: Spot? {
        get {
            return _spot
        }
        set {
            _spot = newValue
            lblTitle.text = _spot?.name
            lblDetail.text = _spot?.ssid
        }
    }
    private var _isCurrentNetwork = false
    public var isCurrentNetwork: Bool {
        get {
            return _isCurrentNetwork
        }
        set {
            _isCurrentNetwork = newValue
            self.indicatorView.lineColor = newValue ? ColorScheme.current.spotCellIndicatorEnableColor : ColorScheme.current.spotCellIndicatorDisableColor
        }
    }
    public weak var delegate: SpotCardViewDelegate?
    
    private var indicatorOffset = CGFloat(10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    init() {
        super.init(frame: .zero)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyUI()
    }
    
    func applyUI() {
        self.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        let lC = indicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: indicatorOffset)
        let cyC = indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let hC = indicatorView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -2 * indicatorOffset)
        let wC = indicatorView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -2 * indicatorOffset)
        NSLayoutConstraint.activate([lC, cyC, hC, wC])
        indicatorView.lineColor = ColorScheme.current.spotCellIndicatorDisableColor
        indicatorView.animateColor = ColorScheme.current.spotCellIndicatorAnimationColor
        
        self.addSubview(lblTitle)
        lblTitle.textAlignment = .left
        lblTitle.textColor = ColorScheme.current.spotCellTitleColor
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let lC1 = lblTitle.leftAnchor.constraint(equalTo: self.indicatorView.rightAnchor, constant: indicatorOffset)
        let tC1 = lblTitle.topAnchor.constraint(equalTo: self.topAnchor)
        let hC1 = lblTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        let rC1 = lblTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -indicatorOffset)
        NSLayoutConstraint.activate([lC1, tC1, hC1, rC1])
        
        self.addSubview(lblDetail)
        lblDetail.textAlignment = .left
        lblDetail.textColor = ColorScheme.current.spotCellDetailColor
        lblDetail.font = UIFont.systemFont(ofSize: 16)
        lblDetail.translatesAutoresizingMaskIntoConstraints = false
        let lC2 = lblDetail.leftAnchor.constraint(equalTo: self.indicatorView.rightAnchor, constant: indicatorOffset)
        let tC2 = lblDetail.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor)
        let hC2 = lblDetail.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        let rC2 = lblDetail.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -indicatorOffset)
        NSLayoutConstraint.activate([lC2, tC2, hC2, rC2])
        
        self.addSubview(viewDots)
        viewDots.isUserInteractionEnabled = true
        viewDots.image = UIImage(named: "three_dots")?.withRenderingMode(.alwaysTemplate)
        viewDots.tintColor = ColorScheme.current.spotCellMenuButtonColor
        viewDots.contentMode = .scaleAspectFit
        viewDots.translatesAutoresizingMaskIntoConstraints = false
        let lC3 = viewDots.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5)
        let tC3 = viewDots.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let hC3 = viewDots.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        let rC3 = viewDots.widthAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([lC3, tC3, hC3, rC3])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onMenuTap))
        viewDots.addGestureRecognizer(tapGesture)
        
        self.addSubview(lblDetail)
    }
    
    func startAnimation() {
        self.indicatorView.animate()
    }
    
    func stopAnimation() {
        self.indicatorView.stopAnimate()
    }
    
    @objc func onMenuTap() {
        self.delegate?.onMenuTap()
    }
}

protocol SpotCollectionViewCellDelegate: class {
    func onMenuTap(forView view: UIView, andSpot spot: Spot)
}

class SpotCollectionViewCell: UICollectionViewCell, SpotCardViewDelegate {
    private var spotView = RegulatorCellView() //SpotCardView()
    private var _spot: Spot?
    public var spot: Spot? {
        get {
            return _spot
        }
        set {
            _spot = newValue
            spotView.spot = _spot
        }
    }
    public var isCurrentNetwork: Bool {
        get {
            return false // spotView.isCurrentNetwork
        }
        set {
            //spotView.isCurrentNetwork = newValue
        }
    }
    public weak var delegate: SpotCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyUI()
    }
    
    func applyUI() {
        self.addSubview(spotView)
        spotView.translatesAutoresizingMaskIntoConstraints = false
        let cxC = spotView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let cyC = spotView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let wC = spotView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let hC = spotView.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([cxC, cyC, wC, hC])
        spotView.backgroundColor = ColorScheme.current.spotCellBackgroundColor
        spotView.layer.cornerRadius = 5
        spotView.clipsToBounds = true
        spotView.isUserInteractionEnabled = true
        //spotView.delegate = self
    }
    
    func startAnimation() {
        //spotView.startAnimation()
    }
    
    func stopAnimation() {
        //spotView.stopAnimation()
    }
    
    func onMenuTap() {
        if spot != nil {
            self.delegate?.onMenuTap(forView: self.spotView, andSpot: spot!)
        }
    }
}

class SpotsCollectionView: UICollectionView {
    private static var collectionLayout: UICollectionViewLayout {
        let l = UICollectionViewFlowLayout()
        let w = UIDevice.current.isiPad ?
                    (UIScreen.main.bounds.width - 30) / 2 :
                    (UIScreen.main.bounds.width - 20)
        l.itemSize = CGSize(width: w, height: 60)
        //l.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return l
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: SpotsCollectionView.collectionLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

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
