//
//  PBInternetCrimeDetailViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 03/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import SafariServices

class PBInternetCrimeDetailViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btHelp: UIButton!
    @IBOutlet weak var btComplaint: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbText: UILabel!

    private var violationType: PBViolationTypeModel!

    convenience init(violationType: PBViolationTypeModel) {
        self.init(nibName: "PBInternetCrimeDetailViewController", bundle: nil)
        self.violationType = violationType
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.view.layoutSubviews()
        self.setupScrollView()
        self.setupButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "Internet crime detail")
    }
    
    //MARK: Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = self.violationType.name
        self.lbDescription.preferredMaxLayoutWidth = screenSize.width-34
        self.lbDescription.text = self.violationType.desc
        self.viewTop.backgroundColor = UIColor(rgba: self.violationType.theme.color)
    }
    
    private func setupScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: self.viewTop.frame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    private func setupTextLabel() {
        self.lbText.text = L10n.textAboutSafernet
    }
    
    private func setupButtons() {
        let titleHelp = L10n.labelInternetHelp
        self.btHelp.setTitle(titleHelp, for: .normal)
        self.btHelp.roundCorners(radius: 15)
        let titleComplaint = L10n.buttonReportInApp
        self.btComplaint.setTitle(titleComplaint, for: .normal)
        self.btComplaint.roundCorners(radius: 15)
    }
    
    // MARK: My functions
    
    @IBAction func help() {
        if let url = URL(string: "http://new.safernet.org.br/helpline") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func denounce() {
        let stepViewController = createComplaintViewController(forType: .internetCrime)
        let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
        navigationController.complaintType = .internetCrime
        self.present(navigationController, animated: true, completion: nil)
        sendAnalyticAction(action: .start, ofType: .internetCrime)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension PBInternetCrimeDetailViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
