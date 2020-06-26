//
//  PBViewControllerUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 16/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import Google

let screenSize = UIScreen.main.bounds.size

extension UIViewController {
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    func presentPhoneViewController(type: PBDiskType) {
        let phoneController = PBPhoneViewController(diskType: type)

        let formSheetController = MZFormSheetPresentationViewController(contentViewController: phoneController)
        formSheetController.presentationController?.contentViewSize = CGSize(width: 240, height: 180)
        formSheetController.presentationController?.shouldCenterHorizontally = true
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = false
        formSheetController.contentViewControllerTransitionStyle = .fade
        formSheetController.contentViewCornerRadius = 20
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func setNavigationBarColor(color: UIColor, animated: Bool) {
        let changeClosure = { (navigationBar: UINavigationBar) -> () in
            var imageBackground: UIImage? = nil
            var imageShadow: UIImage? = nil
            if color == UIColor.clear {
                imageBackground = UIImage()
                imageShadow = imageBackground
            }
            navigationBar.setBackgroundImage(imageBackground, for: UIBarMetrics.default)
            navigationBar.shadowImage = imageShadow
            navigationBar.barTintColor = color
            navigationBar.backgroundColor = color
        }
        if let navigationBar = self.navigationController?.navigationBar {
            if animated {
                self.transitionCoordinator?.animate(alongsideTransition: { (_) in
                    changeClosure(navigationBar)
                }, completion: nil)
            }
            else {
                changeClosure(navigationBar)
            }
        }
    }
    
    func trackViewControllerWithName(name: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.set(kGAIScreenName, value: name)
        if let builder = builder {
            tracker?.send(builder.build() as [NSObject: AnyObject])
        }
    }
}
