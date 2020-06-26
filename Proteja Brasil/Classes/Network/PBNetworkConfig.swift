//
//  PBNetworkConfig.swift
//  Proteja Brasil
//
//  Created by Dielson Sales on 26/06/18.
//  Copyright © 2018 IlhaSoft. All rights reserved.
//

import UIKit

enum PBNetworkConfigType {
    case test
    case production
}

class PBNetworkConfig {
    static var type: PBNetworkConfigType {
        #if DEBUG
            return PBNetworkConfigType.test
        #else
            return PBNetworkConfigType.production
        #endif
    }
}
