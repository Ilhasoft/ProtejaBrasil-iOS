//
//  PBDisk100ViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 01/12/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import Google

class PBPhoneViewController: UIViewController {
    
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var btCall: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var imgDisk: UIImageView!
    private var diskType: PBDiskType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(diskType: PBDiskType) {
        self.diskType = diskType
        super.init(nibName: "PBPhoneViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch diskType {
            case .disk100:
                self.setupMessageLabel(type: .disk100)
            case .disk180:
                self.setupMessageLabel(type: .disk180)
        }
        self.setupPhoneIcon(type: diskType)
        self.setupCallButton()
        self.setupCancelButton()
    }

    // MARK: Setup

    private func setupPhoneIcon(type: PBDiskType) {
        if type == .disk100 {
            self.imgDisk.image = UIImage(named: "imgDisque")
            self.imgDisk.contentMode = .center
        } else {
            self.imgDisk.image = UIImage(named: "imgDisque180")
            self.imgDisk.contentMode = .scaleAspectFit
        }
    }
    
    private func setupMessageLabel(type: PBDiskType) {
        if type == .disk100 {
            self.lbMessage.text = L10n.alertDisk100
        } else {
            self.lbMessage.text = L10n.alertDisk180
        }
    }
    
    private func setupCallButton() {
        let titleText = L10n.labelCall
        btCall.setTitle(titleText, for: .normal)
    }
    
    private func setupCancelButton() {
        let titleText = L10n.optionCancel
        btCancel.setTitle(titleText, for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func call() {
        var phone: String
        if diskType == .disk100 {
            phone = "100"
        } else {
            phone = "180"
        }
        makeCall(phoneNumber: phone)
        self.sendPhoneEvent(phoneNumber: phone)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Util
    
    private func sendPhoneEvent(phoneNumber: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        if let builder = GAIDictionaryBuilder.createEvent(withCategory: "Disque \(phoneNumber) report", action: "Call",
                                                          label: "Call to Disque \(phoneNumber)", value: 1) {
            tracker?.send(builder.build() as [NSObject: AnyObject])
        }

    }
    
}
