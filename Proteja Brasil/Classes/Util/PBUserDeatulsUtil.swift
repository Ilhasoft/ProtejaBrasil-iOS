//
//  PBUserDeatulsUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation

let USER_DEFAULTS = UserDefaults.standard

func setDefaultState(initials: String?) {
    USER_DEFAULTS.setValue(initials, forKey: "user.state.initials")
}

func getDefaultStateInitials() -> String? {
    return USER_DEFAULTS.string(forKey: "user.state.initials")
}
