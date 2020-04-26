//
//  SpotAddingHelperViewController.swift
//  WifiScanner
//
//  Created by Snappii on 4/26/20.
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit

class SpotAddingHelperViewController: UIViewController {
    private var card1 = RegulatorTitleCardView()
    private var card2 = RegulatorTypeConnectionCardView()
    private var card3 = RegulatorNetworkCardView()
    private var card4 = RegulatorConnectionCard()
    private var container = HelperCardContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        card1.secondButtonAction = {() in
            self.container.goToNext()
        }
        container.addCard(card1)
        card2.firstButtonAction = {() in
            self.container.goToPrev()
        }
        card2.secondButtonAction = {() in
            self.container.goToNext()
        }
        container.addCard(card2)
        card3.firstButtonAction = {() in
            self.container.goToPrev()
        }
        card3.secondButtonAction = {() in
            self.container.goToNext()
            self.card4.startRotation()
        }
        container.addCard(card3)
        card4.secondButtonAction = {() in
            self.container.goToPrev()
        }
        container.addCard(card4)
        
        self.view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        let tC = container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        let lC = container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let wC = container.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC = container.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
    }
}

class HelperCardContainerView: UIView {
    private var cards = [HelperCardView]()
    private var currentPosition = 0
    
    func addCard(_ cardView: HelperCardView) {
        self.addSubview(cardView)
        let i = cards.count
        if cards.count == 0 {
            cardView.translatesAutoresizingMaskIntoConstraints = false
            let tC = cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            let lC = cardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
            lC.identifier = "left_\(i)"
            let wC = cardView.widthAnchor.constraint(equalTo: self.widthAnchor)
            let hC = cardView.heightAnchor.constraint(equalTo: self.heightAnchor)
            NSLayoutConstraint.activate([tC, lC, wC, hC])
        } else {
            cardView.translatesAutoresizingMaskIntoConstraints = false
            let tC = cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            let lC = cardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width)
            lC.identifier = "left_\(i)"
            let wC = cardView.widthAnchor.constraint(equalTo: self.widthAnchor)
            let hC = cardView.heightAnchor.constraint(equalTo: self.heightAnchor)
            NSLayoutConstraint.activate([tC, lC, wC, hC])
        }
        cards.append(cardView)
    }
    
    func goToNext() {
        if currentPosition == cards.count - 1 {
            return
        }
        //let currentCard = cards[currentPosition]
        //let nextCard = cards[currentPosition + 1]
        if let lC1 = self.constraints.first(where: { $0.identifier == "left_\(currentPosition)" }),
            let lC2 = self.constraints.first(where: { $0.identifier == "left_\(currentPosition + 1)" }) {
            lC1.constant = -UIScreen.main.bounds.width
            lC2.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
        }
        currentPosition += 1
    }
    
    func goToPrev() {
        if currentPosition == 0 {
            return
        }
        //let currentCard = cards[currentPosition]
        //let nextCard = cards[currentPosition + 1]
        if let lC1 = self.constraints.first(where: { $0.identifier == "left_\(currentPosition)" }),
            let lC2 = self.constraints.first(where: { $0.identifier == "left_\(currentPosition - 1)" }) {
            lC1.constant = UIScreen.main.bounds.width
            lC2.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
        }
        currentPosition -= 1
    }
}

class HelperCardView: UIView {
    internal var btnPrev = UIButton()
    internal var btnNext = UIButton()
    public var firstButtonTitle: String? {
        get {
            return btnPrev.title(for: .normal)
        }
        set {
            btnPrev.setTitle(newValue, for: .normal)
        }
    }
    public var secondButtonTitle: String? {
        get {
            return btnNext.title(for: .normal)
        }
        set {
            btnNext.setTitle(newValue, for: .normal)
        }
    }
    public var firstButtonAction:(() -> Void)?
    public var secondButtonAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyUI() {
        self.addSubview(btnPrev)
        self.addSubview(btnNext)
        
        btnPrev.layer.borderColor = UIColor(hexString: "#DADADA").cgColor
        btnPrev.layer.borderWidth = 1
        btnPrev.layer.cornerRadius = 2
        btnPrev.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
        btnPrev.titleLabel?.font = UIFont.customFont(bySize: 18)
        btnPrev.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        
        btnNext.layer.borderColor = UIColor(hexString: "#DADADA").cgColor
        btnNext.layer.borderWidth = 1
        btnNext.layer.cornerRadius = 2
        btnNext.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
        btnNext.titleLabel?.font = UIFont.customFont(bySize: 18)
        btnNext.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    @objc func prevAction() {
        if self.firstButtonAction != nil {
            self.firstButtonAction!()
        }
    }
    
    @objc func nextAction() {
        if self.secondButtonAction != nil {
            self.secondButtonAction!()
        }
    }
}

class OneButtonHelperCardView: HelperCardView {
    override func applyUI() {
        super.applyUI()
        
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        let tC = btnNext.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -36)
        let lC = btnNext.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = btnNext.widthAnchor.constraint(equalToConstant: 96)
        let hC = btnNext.heightAnchor.constraint(equalToConstant: 36)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
    }
}

class TwoButtonHelperCardView: HelperCardView {
    override func applyUI() {
        super.applyUI()
        
        btnPrev.translatesAutoresizingMaskIntoConstraints = false
        let tC = btnPrev.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -36)
        let lC = btnPrev.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -10)
        let wC = btnPrev.widthAnchor.constraint(equalToConstant: 96)
        let hC = btnPrev.heightAnchor.constraint(equalToConstant: 36)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = btnNext.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -36)
        let lC1 = btnNext.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 10)
        let wC1 = btnNext.widthAnchor.constraint(equalToConstant: 96)
        let hC1 = btnNext.heightAnchor.constraint(equalToConstant: 36)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
    }
}

class RegulatorTitleCardView: OneButtonHelperCardView {
    private var lblTitle = UILabel()
    private var txtTitle = UnderlinedTextField()
    
    override func applyUI() {
        super.applyUI()
        
        self.secondButtonTitle = "NEXT"
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = "Please enter an area name\nwhere the regulator is installed"
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtTitle)
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtTitle.placeholder = "Regulator title"
        txtTitle.textColor = UIColor(hexString: "#767676")
        txtTitle.font = UIFont.customFont(bySize: 26)
    }
}

class UnderlinedTextField: UITextField {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height - 1))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 1))
        UIColor(hexString: "#767676").setStroke()
        path.stroke()
    }
}

class RegulatorTypeConnectionCardView: TwoButtonHelperCardView, CheckboxViewDelegate {
    private var lblTitle = UILabel()
    private var cbxDirectConnection = CheckboxView(frame: .zero)
    private var lblDirectConnection = UILabel()
    private var cbxInternectConnection = CheckboxView(frame: .zero)
    private var lblInternetConnection = UILabel()
    
    override func applyUI() {
        super.applyUI()
        self.firstButtonTitle = "BACK"
        self.secondButtonTitle = "NEXT"
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = "Choose a connection type"
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(cbxDirectConnection)
        cbxDirectConnection.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = cbxDirectConnection.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 45)
        let lC1 = cbxDirectConnection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        let wC1 = cbxDirectConnection.widthAnchor.constraint(equalToConstant: 30)
        let hC1 = cbxDirectConnection.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        cbxDirectConnection.delegate = self
        
        self.addSubview(lblDirectConnection)
        lblDirectConnection.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = lblDirectConnection.topAnchor.constraint(equalTo: cbxDirectConnection.topAnchor, constant: 0)
        let lC2 = lblDirectConnection.leftAnchor.constraint(equalTo: cbxDirectConnection.rightAnchor, constant: 15)
        let wC2 = lblDirectConnection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        let hC2 = lblDirectConnection.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        lblDirectConnection.text = "Direct connection"
        lblDirectConnection.font = UIFont.customFont(bySize: 24)
        lblDirectConnection.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(cbxInternectConnection)
        cbxInternectConnection.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = cbxInternectConnection.topAnchor.constraint(equalTo: cbxDirectConnection.bottomAnchor, constant: 30)
        let lC3 = cbxInternectConnection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        let wC3 = cbxInternectConnection.widthAnchor.constraint(equalToConstant: 30)
        let hC3 = cbxInternectConnection.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        cbxInternectConnection.delegate = self
        
        self.addSubview(lblInternetConnection)
        lblInternetConnection.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = lblInternetConnection.topAnchor.constraint(equalTo: cbxInternectConnection.topAnchor, constant: 0)
        let lC4 = lblInternetConnection.leftAnchor.constraint(equalTo: cbxInternectConnection.rightAnchor, constant: 15)
        let wC4 = lblInternetConnection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        let hC4 = lblInternetConnection.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        lblInternetConnection.text = "Internet connection"
        lblInternetConnection.font = UIFont.customFont(bySize: 24)
        lblInternetConnection.textColor = UIColor(hexString: "#767676")
    }
    
    func onCheckboxChange(_ checkbox: CheckboxView, value: Bool) {
        if checkbox == cbxDirectConnection {
            cbxInternectConnection.value = !value
        }
        if checkbox == cbxInternectConnection {
            cbxDirectConnection.value = !value
        }
    }
    
    func showNextScreen() {
        if cbxDirectConnection.value {
            
        }
        if cbxInternectConnection.value {
            
        }
    }
}

protocol CheckboxViewDelegate: class {
    func onCheckboxChange(_ checkbox: CheckboxView, value: Bool)
}

class CheckboxView: UIImageView {
    private var yesImage = UIImage(named: "check_box_yes_icon")
    private var noImage = UIImage(named: "check_box_no_icon")
    private var _value = false
    public var value: Bool {
        get {
            return _value
        }
        set {
            _value = newValue
            self.image = _value ? yesImage : noImage
        }
    }
    public weak var delegate: CheckboxViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = noImage
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func onTap() {
        self.value = !self.value
        self.delegate?.onCheckboxChange(self, value: self.value)
    }
}

class RegulatorNetworkCardView: TwoButtonHelperCardView {
    private var lblTitle = UILabel()
    private var txtTitle = UnderlinedTextField()
    private var txtPassword = UnderlinedTextField()
    
    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = "BACK"
        self.secondButtonTitle = "NEXT"
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = "Enter regulator network ID\nand his password"
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtTitle)
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtTitle.placeholder = "Regulator network ID"
        txtTitle.textColor = UIColor(hexString: "#767676")
        txtTitle.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(txtPassword)
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = txtPassword.topAnchor.constraint(equalTo: txtTitle.bottomAnchor, constant: 60)
        let lC2 = txtPassword.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = txtPassword.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC2 = txtPassword.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        txtPassword.isSecureTextEntry = true
        txtPassword.placeholder = "Regulator password"
        txtPassword.textColor = UIColor(hexString: "#767676")
        txtPassword.font = UIFont.customFont(bySize: 26)
    }
}

class RegulatorConnectionCard: OneButtonHelperCardView {
    private var lblTitle = UILabel()
    private var spinnerView = UIImageView()
    
    override func applyUI() {
        super.applyUI()
        
        self.secondButtonTitle = "CANCEL"
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = "Connection..."
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(spinnerView)
        spinnerView.contentMode = .scaleAspectFit
        spinnerView.image = UIImage(named: "connection_spinner_icon")
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = spinnerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30)
        let lC1 = spinnerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = spinnerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)
        let hC1 = spinnerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        spinnerView.alpha = 0.3
    }
    
    func startRotation() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 2.0 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatDuration = 600
        rotation.repeatCount = Float.greatestFiniteMagnitude
        spinnerView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
