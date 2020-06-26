//
//  PBOnboardingViewController.swift
//  Proteja Brasil
//
//  Created by Raul dos Santos Oliveira on 13/12/18.
//  Copyright © 2018 IlhaSoft. All rights reserved.
//

import UIKit

class PBOnboardingViewController: UIViewController {

    private var appView: AppDelegate

    @IBOutlet weak var btNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    init(view: AppDelegate) {
        self.appView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func btNextTapped() {
        appView.setRootViewController()
        self.dismiss(animated: false)
    }
}
