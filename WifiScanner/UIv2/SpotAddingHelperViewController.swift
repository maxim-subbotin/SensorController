//
//  SpotAddingHelperViewController.swift
//  WifiScanner
//
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import SystemConfiguration
import AVFoundation

class SpotAddingHelperViewController: UIViewController, RegulatorConnectionCardDelegate, RegulatorOnlineAuthCardDelegate {
    private var card1 = RegulatorTitleCardView()
    private var card2 = RegulatorTypeConnectionCardView()
    private var card3 = RegulatorNetworkCardView()
    private var card4 = RegulatorConnectionCard()
    private var card5 = RegulatorConnectionErrorCard()
    private var card6 = RegulatorOnlineAuthCard()
    private var card7 = RegulatorForgetPasswordCard()
    private var card8 = RegulatorSignupCard()
    private var container = HelperCardContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        card1.secondButtonAction = {() in
            self.container.goToNext()
        }
        container.addCard(card1)
        
        card2.firstButtonAction = {() in
            self.container.goToPosition(1)
        }
        card2.secondButtonAction = {() in
            if self.card2.isDirectConnection {
                self.container.goToNext()
            } else {
                self.container.goToPosition(5)
            }
        }
        container.addCard(card2)
        
        card3.firstButtonAction = {() in
            self.container.goToPrev()
        }
        card3.secondButtonAction = {() in
            if let ssid = self.card3.ssid, let password = self.card3.password {
                self.card4.ssid = ssid
                self.card4.password = password
                
                self.container.goToNext()
                self.card4.startRotation()
                
                self.card4.tryToConnect()
            } else {
                print("Need to fill ssid and password")
            }
        }
        container.addCard(card3)
        
        card4.delegate = self
        card4.viewController = self
        card4.secondButtonAction = {() in
            self.container.goToPrev()
        }
        container.addCard(card4)
        
        card5.firstButtonAction = {() in
            self.container.goToPosition(2)
        }
        card5.secondButtonAction = {() in
            self.container.goToPosition(3)
            self.card4.startRotation()
            self.card4.tryToConnect()
        }
        container.addCard(card5)
        
        card6.delegate = self
        card6.firstButtonAction = {() in
            self.container.goToPrev()
        }
        card6.secondButtonAction = {() in
            //self.container.goToNext()
        }
        container.addCard(card6)
        
        card7.firstButtonAction = {() in
            self.container.goToPrev()
        }
        card7.secondButtonAction = {() in
            //
        }
        container.addCard(card7)
        
        card8.firstButtonAction = {() in
            self.container.goToPosition(5)
        }
        card8.secondButtonAction = {() in
            //
        }
        container.addCard(card8)
        
        self.view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        let tC = container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        let lC = container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let wC = container.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let hC = container.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
    }
    
    func onConnectionError() {
        container.goToPosition(4)
    }
    
    func onConnectionSuccess() {
        
    }
    
    func onSingUpAction() {
        self.container.goToPosition(7)
    }
    
    func onForgetPassword() {
        self.container.goToPosition(6)
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
    
    func goToPosition(_ pos: Int) {
        if pos < 0 || pos >= cards.count {
            return
        }
        if let lC1 = self.constraints.first(where: { $0.identifier == "left_\(currentPosition)" }),
            let lC2 = self.constraints.first(where: { $0.identifier == "left_\(pos)" }) {
            lC1.constant = UIScreen.main.bounds.width
            lC2.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
        }
        currentPosition = pos
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
        
        self.backgroundColor = .white
        
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
        
        self.secondButtonTitle = Localization.main.next.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.regulatorTitleDescription
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtTitle)
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtTitle.placeholder = Localization.main.regulatorTitle
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
    public var isDirectConnection: Bool {
        return cbxDirectConnection.value
    }
    
    override func applyUI() {
        super.applyUI()
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.next.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.connectionType
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
        lblDirectConnection.text = Localization.main.directConnection
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
        lblInternetConnection.text = Localization.main.internetConnection
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

class RegulatorNetworkCardView: TwoButtonHelperCardView, AVCaptureMetadataOutputObjectsDelegate {
    private var lblTitle = UILabel()
    private var segment = UISegmentedControl(items: ["Scan code", "Manual"])
    private var txtTitle = UnderlinedTextField()
    private var txtPassword = UnderlinedTextField()
    public var ssid: String? {
        return txtTitle.text
    }
    public var password: String? {
        return txtPassword.text
    }
    
    // Camera
    private var cameraView = UIView()
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    private var isStopped = false
    
    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.next.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.enterRegulator
        lblTitle.font = UIFont.customFont(bySize: 24)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = segment.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 30)
        let lC3 = segment.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC3 = segment.widthAnchor.constraint(equalToConstant: 300)
        let hC3 = segment.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        segment.tintColor = UIColor(hexString: "#767676")
        let attr = [NSAttributedString.Key.font: UIFont.customFont(bySize: 20), NSAttributedString.Key.foregroundColor: UIColor(hexString: "#767676")]
        segment.setTitleTextAttributes(attr, for: .normal)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(onSegmentAction), for: .valueChanged)
        
        // Manual creadentials
        
        self.addSubview(txtTitle)
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtTitle.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 60)
        let lC1 = txtTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtTitle.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtTitle.placeholder = Localization.main.regulatorNetworkId
        txtTitle.textColor = UIColor(hexString: "#767676")
        txtTitle.font = UIFont.customFont(bySize: 26)
        txtTitle.isHidden = true
        
        self.addSubview(txtPassword)
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = txtPassword.topAnchor.constraint(equalTo: txtTitle.bottomAnchor, constant: 60)
        let lC2 = txtPassword.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = txtPassword.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC2 = txtPassword.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        txtPassword.isSecureTextEntry = true
        txtPassword.placeholder = Localization.main.regulatorPassword
        txtPassword.textColor = UIColor(hexString: "#767676")
        txtPassword.font = UIFont.customFont(bySize: 26)
        txtPassword.isHidden = true
        
        // Scaner
        
        self.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = cameraView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 30)
        let lC4 = cameraView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC4 = cameraView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        let hC4 = cameraView.heightAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        
        cameraView.layer.cornerRadius = 5
        captureSession = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.startReading()
        })
    }
    
    func startReading() -> Bool {
        let captureDevice = AVCaptureDevice.default(for: .video)!
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // Do the rest of your work...
        } catch let error as NSError {
            // Handle any errors
            print(error)
            return false
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        /* Check for metadata */
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
        print(captureMetadataOutput.availableMetadataObjectTypes)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureSession?.startRunning()
        
        return true
    }
    
    func stopReading() {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    @objc func onSegmentAction() {
        if segment.selectedSegmentIndex == 1 {
            txtTitle.isHidden = false
            txtPassword.isHidden = false
            cameraView.isHidden = true
            stopReading()
        }
        if segment.selectedSegmentIndex == 0 {
            txtTitle.isHidden = true
            txtPassword.isHidden = true
            cameraView.isHidden = false
            startReading()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if !parseJson(stringValue) {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    if rootVC is UINavigationController {
                        if let vc = (rootVC as! UINavigationController).viewControllers.last {
                            let alert = UIAlertController(title: "Error", message: "Incorrect QR code format", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                self.startReading()
                            }))
                            vc.presentedViewController?.present(alert, animated: true, completion: nil)
                            stopReading()
                        }
                    }
                }
            } else {
                stopReading()
                self.btnNext.sendActions(for: .touchUpInside)
            }
        }
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            print(metaData.description)
            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                print(unwraped.stringValue)
            }
        }
    }
    
    func parseJson(_ jsonString: String) -> Bool {
        if let data = jsonString.data(using: .utf8) {
            do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if dict["ssid"] != nil && dict["ssid"] is String && dict["password"] != nil && dict["password"] is String {
                        let ssid = dict["ssid"] as! String
                        let password = dict["password"] as! String
                        if ssid.count > 0 && password.count > 0 {
                            txtTitle.text = ssid
                            txtPassword.text = password
                            return true
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return false
    }
}

protocol RegulatorConnectionCardDelegate: class {
    func onConnectionError()
    func onConnectionSuccess()
}

class RegulatorConnectionCard: OneButtonHelperCardView {
    private var lblTitle = UILabel()
    private var spinnerView = UIImageView()
    public var ssid: String?
    public var password: String?
    public weak var viewController: UIViewController?
    public weak var delegate: RegulatorConnectionCardDelegate?
    
    override func applyUI() {
        super.applyUI()
        
        self.secondButtonTitle = Localization.main.cancel.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.connection
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
    
    func tryToConnect() {
        if ssid == nil || password == nil {
            return
        }
        
        // try to connect to wi-fi
        if #available(iOS 11.0, *) {
            let hotspotConfig = NEHotspotConfiguration(ssid: self.ssid!, passphrase: self.password!, isWEP: false)
            NEHotspotConfigurationManager.shared.apply(hotspotConfig, completionHandler: { (error) in
                if error != nil {
                    /*let msg = error!.localizedDescription
                    let alert = UIAlertController(title: "Connection error", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.viewController?.present(alert, animated: true, completion: nil)*/
                    
                    self.delegate?.onConnectionError()
                    
                    return
                }
                
                if Tools.currentSsid == self.ssid {
                    if let ip = Tools.getIPAddress() {
                        print("Connected to network \(self.ssid) successfully. IP: \(ip)")
                        self.delegate?.onConnectionSuccess()
                    }
                } else {
                    print("Unable to connect: \(self.ssid)")
                    self.delegate?.onConnectionError()
                }

            })
        } else {
            print("Need to update ios version")
        }
    }
}

class RegulatorConnectionErrorCard: TwoButtonHelperCardView {
    private var lblTitle = UILabel()
    private var lblDescription = UILabel()
    
    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.tryAgain.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.impossibleConnect
        lblTitle.font = UIFont.customFont(bySize: 33)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(lblDescription)
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 50)
        let lC1 = lblDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = lblDescription.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = lblDescription.heightAnchor.constraint(equalToConstant: 255)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        lblDescription.textAlignment = .center
        lblDescription.numberOfLines = 0
        lblDescription.text = Localization.main.impossibleConnectDescription
        lblDescription.font = UIFont.customFont(bySize: 24)
        lblDescription.textColor = UIColor(hexString: "#767676")
    }
}

protocol RegulatorOnlineAuthCardDelegate: class {
    func onSingUpAction()
    func onForgetPassword()
}

class RegulatorOnlineAuthCard: TwoButtonHelperCardView {
    private var lblTitle = UILabel()
    private var txtEmail = UnderlinedTextField()
    private var txtPassword = UnderlinedTextField()
    private var btnRegistration = UIButton()
    private var btnForgetPassword = UIButton()
    public weak var delegate: RegulatorOnlineAuthCardDelegate?
    
    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.next.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.authorization
        lblTitle.font = UIFont.customFont(bySize: 33)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtEmail)
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtEmail.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtEmail.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtEmail.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtEmail.placeholder = Localization.main.emailAddress
        txtEmail.textColor = UIColor(hexString: "#767676")
        txtEmail.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(txtPassword)
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 30)
        let lC2 = txtPassword.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = txtPassword.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC2 = txtPassword.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        txtPassword.placeholder = Localization.main.password
        txtPassword.textColor = UIColor(hexString: "#767676")
        txtPassword.font = UIFont.customFont(bySize: 26)
        txtPassword.isSecureTextEntry = true
        
        let attrs = [NSAttributedString.Key.font : UIFont.customFont(bySize: 20),
                     NSAttributedString.Key.foregroundColor : UIColor(hexString: "#767676"),
                     NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        self.addSubview(btnRegistration)
        btnRegistration.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = btnRegistration.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 30)
        let lC3 = btnRegistration.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        let wC3 = btnRegistration.widthAnchor.constraint(equalToConstant: 120)
        let hC3 = btnRegistration.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        btnRegistration.setAttributedTitle(NSMutableAttributedString(string:Localization.main.signUp, attributes:attrs), for: .normal)
        btnRegistration.contentHorizontalAlignment = .left
        btnRegistration.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
        btnRegistration.titleLabel?.font = UIFont.customFont(bySize: 18)
        btnRegistration.addTarget(self, action: #selector(onSingUp), for: .touchUpInside)
        
        self.addSubview(btnForgetPassword)
        btnForgetPassword.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = btnForgetPassword.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 30)
        let lC4 = btnForgetPassword.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        let wC4 = btnForgetPassword.widthAnchor.constraint(equalToConstant: 120)
        let hC4 = btnForgetPassword.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        btnForgetPassword.setAttributedTitle(NSMutableAttributedString(string:Localization.main.forgetPassword, attributes:attrs), for: .normal)
        btnForgetPassword.contentHorizontalAlignment = .right
        btnForgetPassword.setTitleColor( UIColor(hexString: "#767676"), for: .normal)
        btnForgetPassword.titleLabel?.font = UIFont.customFont(bySize: 18)
        btnForgetPassword.addTarget(self, action: #selector(onForgetPassword), for: .touchUpInside)
    }
    
    @objc func onSingUp() {
        self.delegate?.onSingUpAction()
    }
    
    @objc func onForgetPassword() {
        self.delegate?.onForgetPassword()
    }
}

class RegulatorForgetPasswordCard: TwoButtonHelperCardView {
    private var lblTitle = UILabel()
    private var txtEmail = UnderlinedTextField()
    private var lblDescription = UILabel()
    
    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.restore.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.accessRecovery
        lblTitle.font = UIFont.customFont(bySize: 33)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtEmail)
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtEmail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtEmail.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtEmail.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtEmail.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtEmail.placeholder = Localization.main.emailAddress
        txtEmail.textColor = UIColor(hexString: "#767676")
        txtEmail.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(lblDescription)
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = lblDescription.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 50)
        let lC2 = lblDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = lblDescription.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC2 = lblDescription.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        lblDescription.textAlignment = .center
        lblDescription.numberOfLines = 0
        lblDescription.text = Localization.main.accessRecoveryDescription
        lblDescription.font = UIFont.customFont(bySize: 20)
        lblDescription.textColor = UIColor(hexString: "#767676")
    }
}

class RegulatorSignupCard: TwoButtonHelperCardView {
    private var lblTitle = UILabel()
    private var txtName = UnderlinedTextField()
    private var txtCompany = UnderlinedTextField()
    private var txtEmail = UnderlinedTextField()
    private var txtPassword = UnderlinedTextField()
    private var txtPassword2 = UnderlinedTextField()
    private var cbxAgree = CheckboxView(frame: .zero)
    private var lblAgreement = UILabel()

    override func applyUI() {
        super.applyUI()
        
        self.firstButtonTitle = Localization.main.back.uppercased()
        self.secondButtonTitle = Localization.main.OK.uppercased()
        
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        let tC = lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        let lC = lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC = lblTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC = lblTitle.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([tC, lC, wC, hC])
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        lblTitle.text = Localization.main.signUp
        lblTitle.font = UIFont.customFont(bySize: 33)
        lblTitle.textColor = UIColor(hexString: "#767676")
        
        self.addSubview(txtName)
        txtName.translatesAutoresizingMaskIntoConstraints = false
        let tC1 = txtName.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 60)
        let lC1 = txtName.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC1 = txtName.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC1 = txtName.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC1, lC1, wC1, hC1])
        txtName.placeholder = Localization.main.name
        txtName.textColor = UIColor(hexString: "#767676")
        txtName.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(txtCompany)
        txtCompany.translatesAutoresizingMaskIntoConstraints = false
        let tC2 = txtCompany.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: 30)
        let lC2 = txtCompany.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC2 = txtCompany.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC2 = txtCompany.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC2, lC2, wC2, hC2])
        txtCompany.placeholder = Localization.main.company
        txtCompany.textColor = UIColor(hexString: "#767676")
        txtCompany.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(txtEmail)
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        let tC3 = txtEmail.topAnchor.constraint(equalTo: txtCompany.bottomAnchor, constant: 30)
        let lC3 = txtEmail.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC3 = txtEmail.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC3 = txtEmail.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC3, lC3, wC3, hC3])
        txtEmail.placeholder = Localization.main.emailAddress
        txtEmail.textColor = UIColor(hexString: "#767676")
        txtEmail.font = UIFont.customFont(bySize: 26)
        
        self.addSubview(txtPassword)
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        let tC4 = txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 30)
        let lC4 = txtPassword.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC4 = txtPassword.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC4 = txtPassword.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC4, lC4, wC4, hC4])
        txtPassword.placeholder = Localization.main.password
        txtPassword.textColor = UIColor(hexString: "#767676")
        txtPassword.font = UIFont.customFont(bySize: 26)
        txtPassword.isSecureTextEntry = true
        
        self.addSubview(txtPassword2)
        txtPassword2.translatesAutoresizingMaskIntoConstraints = false
        let tC5 = txtPassword2.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 30)
        let lC5 = txtPassword2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let wC5 = txtPassword2.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
        let hC5 = txtPassword2.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([tC5, lC5, wC5, hC5])
        txtPassword2.placeholder = Localization.main.passwordAgain
        txtPassword2.textColor = UIColor(hexString: "#767676")
        txtPassword2.font = UIFont.customFont(bySize: 26)
        txtPassword2.isSecureTextEntry = true
        
        self.addSubview(cbxAgree)
        cbxAgree.translatesAutoresizingMaskIntoConstraints = false
        let tC6 = cbxAgree.topAnchor.constraint(equalTo: txtPassword2.bottomAnchor, constant: 30)
        let lC6 = cbxAgree.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        let wC6 = cbxAgree.widthAnchor.constraint(equalToConstant: 30)
        let hC6 = cbxAgree.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([tC6, lC6, wC6, hC6])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let w = self.frame.width - 30 - 30 - 15
            let t = Localization.main.signUpDescription
            let h = t.height(withConstrainedWidth: w, font: UIFont.customFont(bySize: 20))
            
            self.addSubview(self.lblAgreement)
            self.lblAgreement.translatesAutoresizingMaskIntoConstraints = false
            let tC7 = self.lblAgreement.topAnchor.constraint(equalTo: self.cbxAgree.topAnchor, constant: 0)
            let lC7 = self.lblAgreement.leftAnchor.constraint(equalTo: self.cbxAgree.rightAnchor, constant: 15)
            let wC7 = self.lblAgreement.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
            let hC7 = self.lblAgreement.heightAnchor.constraint(equalToConstant: h)
            NSLayoutConstraint.activate([tC7, lC7, wC7, hC7])
            self.lblAgreement.numberOfLines = 0
            self.lblAgreement.text = t
            self.lblAgreement.textColor = UIColor(hexString: "#767676")
            self.lblAgreement.font = UIFont.customFont(bySize: 20)
        })
    }
}
