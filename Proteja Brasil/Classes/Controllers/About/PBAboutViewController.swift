//
//  PBAboutViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 22/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import SafariServices

class PBAboutViewController: UIViewController {

    @IBOutlet weak var lbAppName: UILabel!
    @IBOutlet weak var lbText: UILabel!
    
    convenience init() {
        self.init(nibName: "PBAboutViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.actionAbout
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "About")
    }
    
    // MARK: Setup
    
    private func setupText() {
        let text = L10n.textAboutApp
        self.lbText.preferredMaxLayoutWidth = self.screenSize.width-30
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .baselineOffset: NSNumber(value: 0)
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.lbText.attributedText = attributedString
    }
    
    // MARK: My functions

    @IBAction func goToSite() {
        let url = URL(string: "http://www.protejabrasil.com.br/")!
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}
