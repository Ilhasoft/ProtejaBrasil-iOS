//
//  PBComplaintFinishedViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 19/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import SafariServices

class PBComplaintFinishedViewController: UIViewController {
    
    @IBOutlet weak var constraintViewCenterHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbFInished: UILabel!
    @IBOutlet weak var lbDisk100: UILabel!
    @IBOutlet weak var lbProtocol: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var btbackToHome: UIButton!
    @IBOutlet weak var btOnlineHelp: UIButton!
    
    private var complaintType: PBComplaintType!
    private var result: String?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(complaintType: PBComplaintType, result: String? = nil) {
        self.init(nibName: "PBComplaintFinishedViewController", bundle: nil)
        self.complaintType = complaintType
        self.result = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupFinishedLabel()
        self.setupDisk100Button()
        self.setupProtocol()
        self.setupBackButton()
        if self.complaintType == .internetCrime {
            self.setupForInternetCrime()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupMessage()
    }
    
    // MARK: Setup
    
    private func setupImageView() {
        let imageName = NSLocalizedString("img_report_registred", tableName: "Assets", bundle: Bundle.main, value: "", comment: "")
        self.imageView.image = UIImage(named: imageName)
    }
    
    private func setupFinishedLabel() {
        self.lbFInished.text = L10n.messageReportProtocol
    }
    
    private func setupDisk100Button() {
        self.lbDisk100.roundCorners(radius: 7)
        self.lbDisk100.text = NSLocalizedString("disk_100", comment: "")
        if self.complaintType == .internetCrime {
            self.lbDisk100.text = "Safernet"
        }
    }
    
    private func setupProtocol() {
        self.lbProtocol.text = self.result
    }
    
    private func setupMessage() {
        if self.complaintType == .violation || self.complaintType == .noAccessibility {
            self.lbMessage.text = L10n.protocolInfo
        } else {
            self.lbMessage.text = L10n.protocolInfoInternet
        }
    }
    
    private func setupBackButton() {
        let titleText = L10n.labelBackStart
        self.btbackToHome.setTitle(titleText, for: .normal)
    }
    
    private func setupOnlineHelpButton() {
        let titleText = L10n.labelOnlineHelp
        self.btOnlineHelp.setTitle(titleText, for: .normal)
        self.btOnlineHelp.layer.cornerRadius = 20
    }
    
    private func setupForInternetCrime() {
        self.setupOnlineHelpButton()
        self.constraintViewCenterHeight.constant += 40
        self.btOnlineHelp.isHidden = false
    }
    
    // MARK: My functions
    
    @IBAction func backToHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onlineHelp() {
        if let url = URL(string: "http://new.safernet.org.br/helpline") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
