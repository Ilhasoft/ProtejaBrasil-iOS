//
//  PBThanksForFeedbackViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 26/02/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBThanksForFeedbackViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var btRateOnAppStore: UIButton!
    @IBOutlet weak var btBackToHome: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init() {
        self.init(nibName: "PBThanksForFeedbackViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupMessage()
        self.setupRateButton()
        self.setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Setup
    
    private func setupImageView() {
        let imageName = NSLocalizedString("img_thanks_feedback", tableName: "Assets", bundle: Bundle.main, value: "", comment: "")
        self.imageView.image = UIImage(named: imageName)
    }
    
    private func setupMessage() {
        self.lbMessage.text = NSLocalizedString("prompt_success_message_feedback", comment: "")
    }
    
    private func setupRateButton() {
        self.btRateOnAppStore.roundCorners(radius: 20)
        let titleText = L10n.promptEvaluateAppStore
        self.btRateOnAppStore.setTitle(titleText, for: .normal)
    }
    
    private func setupBackButton() {
        let titleText = L10n.labelBackStart
        self.btBackToHome.setTitle(titleText, for: .normal)
    }
    
    // MARK: My functions
    
    @IBAction func rateOnAppStore() {
        if let url = URL(string: "https://itunes.apple.com/br/app/proteja-brasil/id661714677?mt=8") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func goHome() {
        let menuViewController = self.revealViewController().rearViewController as! PBMenuViewController
        let btMap = menuViewController.view.viewWithTag(50) as! UIButton
        menuViewController.showMapViewController(sender: btMap)
    }
    
}
