//
//  PBAlertUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 29/12/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

func showErrorAlert(message: String, delegate: AnyObject? = nil) {
    let titleText = L10n.error
    let alert = UIAlertView(title: titleText, message: message, delegate: delegate, cancelButtonTitle: L10n.ok)
    alert.show()
}
