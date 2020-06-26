//
//  PBPhoneUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 24/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

func makeCall(phoneNumber:String) {
    if let url = URL(string: "tel://\(phoneNumber)") {
        UIApplication.shared.openURL(url)
    }
}
