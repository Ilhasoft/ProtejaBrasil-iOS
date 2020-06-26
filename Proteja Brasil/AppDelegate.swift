//
//  AppDelegate.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 15/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import SWRevealViewController
import SFEmptyBackButton
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.customizeNavigationBar()
        self.setupAnalytics()
        setRootViewController()
        return true
    }
    
    func customizeNavigationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.barStyle = UIBarStyle.blackTranslucent
        appearance.tintColor = kWhiteColor
        appearance.barTintColor = kBlueColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: kWhiteColor]
        
        SFEmptyBackButton.removeTitleFromAllViewControllers()
    }
    
    private func setupAnalytics() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
    }

    private func getRootViewController() -> UIViewController {
        let root: UIViewController

        let onboardingViewController = PBOnboardingViewController(view: self)

        let menuViewController = PBMenuViewController()
        let mapViewController = PBMapViewController()

        PBLocationManager.sharedInstance().requestUserLocation()
        PBLocationManager.sharedInstance().delegate = mapViewController

        let navigationController = UINavigationController(rootViewController: mapViewController)

        guard let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController) else { return navigationController }

        swRevealViewController.rearViewRevealWidth = 230
        swRevealViewController.toggleAnimationDuration = 0.5

        if let tapGesture = swRevealViewController.tapGestureRecognizer() {
            navigationController.view.addGestureRecognizer(tapGesture)
        }

        if let panGesture = swRevealViewController.panGestureRecognizer() {
            navigationController.view.addGestureRecognizer(panGesture)
        }
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set(false, forKey:"isFirstTime")
            root = onboardingViewController
        } else {
            root = swRevealViewController
        }

        return root
    }

    func setRootViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
    }
}

