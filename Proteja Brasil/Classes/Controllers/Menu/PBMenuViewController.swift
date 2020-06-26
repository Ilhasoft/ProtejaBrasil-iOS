//
//  PBMenuViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 15/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

class PBMenuViewController: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btMap: UIButton!
    @IBOutlet weak var btThemes: UIButton!
    @IBOutlet weak var btReport: UIButton!
    @IBOutlet weak var btFeedback: UIButton!
    @IBOutlet weak var btAbout: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var viewSelection: UIView!
    
    convenience init() {
        self.init(nibName: "PBMenuViewController", bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let visibleViewController = self.getVisibleViewController()
        visibleViewController.view.isUserInteractionEnabled = false
        self.trackViewControllerWithName(name: "Menu")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let rootViewController = self.getVisibleViewController()
        rootViewController.view.isUserInteractionEnabled = true
        rootViewController.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLogoImage()
        self.setupButtons()
        self.viewSelection = UIView()
        self.viewSelection.frame = CGRect(x: 0, y: 148, width: 2, height: 52)
        self.viewSelection.backgroundColor = UIColor(red: 16/266, green: 198/255, blue: 220/255, alpha: 1)
        self.view.addSubview(self.viewSelection)
    }
    
    private func setupLogoImage() {
        let imageName = NSLocalizedString("img_logo_menu", tableName: "Assets", bundle: Bundle.main, value: "", comment: "")
        self.imgLogo.image = UIImage(named: imageName)
    }
    
    private func setupButtons() {
        let mapTitleText = L10n.actionMap
        self.btMap.setTitle(mapTitleText, for: .normal)
        let themesTitleText = L10n.actionViolationTypes
        self.btThemes.setTitle(themesTitleText, for: .normal)
        let disk100TitleText = L10n.menuReport
        self.btReport.setTitle(disk100TitleText, for: .normal)
        let feedbackTitleText = L10n.actionOpinion
        self.btFeedback.setTitle(feedbackTitleText, for: .normal)
        let aboutTitleText = L10n.actionAbout
        self.btAbout.setTitle(aboutTitleText, for: .normal)
    }
    
    private func getVisibleViewController() -> UIViewController {
        let navigationController = self.revealViewController().frontViewController as! UINavigationController
        let visibleViewController = navigationController.visibleViewController!
        return visibleViewController
    }
    
    func setFrontViewController(viewController: UIViewController, withPanGesture hasPanGesture: Bool = true) {
        guard let swRevealViewController = self.revealViewController() else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        if hasPanGesture {
            navigationController.view.addGestureRecognizer(swRevealViewController.panGestureRecognizer())
        }
        navigationController.view.addGestureRecognizer(swRevealViewController.tapGestureRecognizer())
        swRevealViewController.pushFrontViewController(navigationController, animated: true)
    }
    
    func addLeftButtonMenuInViewController(viewController:UIViewController){
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "imgMenu"), style: .plain, target: self, action: #selector(toggleMenu))
    }

    func updateViewSelectionBasedOn(button: UIButton) {
        self.viewSelection.frame.origin.y = button.frame.origin.y
    }
    
    @IBAction func showMapViewController(sender: UIButton) {
        self.updateViewSelectionBasedOn(button: sender)
        
        if let _ = self.getVisibleViewController() as? PBMapViewController {
            self.toggleMenu()
            return
        }
        let mapViewController = PBMapViewController()
        addLeftButtonMenuInViewController(viewController: mapViewController)
        self.setFrontViewController(viewController: mapViewController)
    }
    
    @IBAction func showComplaintsViewController(sender: UIButton) {
        self.updateViewSelectionBasedOn(button: sender)
        
        if let _ = self.getVisibleViewController() as? PBMyProtocolsViewController {
            self.toggleMenu()
            return
        }
        let protocolsViewController = PBMyProtocolsViewController()
        addLeftButtonMenuInViewController(viewController: protocolsViewController)
        self.setFrontViewController(viewController: protocolsViewController)
    }
    
    @IBAction func showThemeListViewController(sender: UIButton) {
        self.updateViewSelectionBasedOn(button: sender)
        
        if let _ = self.getVisibleViewController() as? PBThemeListViewController {
            self.toggleMenu()
            return
        }
        let themeListViewController = PBThemeListViewController()
        self.addLeftButtonMenuInViewController(viewController: themeListViewController)
        self.setFrontViewController(viewController: themeListViewController)
    }
    
    @IBAction func report(sender: UIButton) {
        let button = self.view.viewWithTag(50) as! UIButton
        self.updateViewSelectionBasedOn(button: button)
        var mapViewController: PBMapViewController
        if let mapVC = self.getVisibleViewController() as? PBMapViewController {
            mapViewController = mapVC
        } else {
            mapViewController = PBMapViewController()
            addLeftButtonMenuInViewController(viewController: mapViewController)
            self.setFrontViewController(viewController: mapViewController)
        }
        mapViewController.shouldShowFloatButton = true
        self.toggleMenu()
    }
    
    @IBAction func showOpineViewController(sender: UIButton) {
        self.updateViewSelectionBasedOn(button: sender)
        
        if let _ = self.getVisibleViewController() as? PBOpineViewController {
            self.toggleMenu()
            return
        }
        let opineViewController = PBOpineViewController()
        addLeftButtonMenuInViewController(viewController: opineViewController)
        self.setFrontViewController(viewController: opineViewController)
    }
    
    @IBAction func showAboutViewController(sender: UIButton) {
        self.updateViewSelectionBasedOn(button: sender)
        
        if let _ = self.getVisibleViewController() as? PBAboutViewController {
            self.toggleMenu()
            return
        }
        let aboutViewController = PBAboutViewController()
        addLeftButtonMenuInViewController(viewController: aboutViewController)
        self.setFrontViewController(viewController: aboutViewController)
    }
    
    @objc func toggleMenu() {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
}
