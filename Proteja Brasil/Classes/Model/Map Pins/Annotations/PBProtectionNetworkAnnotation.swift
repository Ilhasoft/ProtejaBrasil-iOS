//
//  PBProtectionNetworkAnnotation.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit

class PBProtectionNetworkAnnotation: MKPointAnnotation {
    
    var protectionNetwork: PBProtectionNetworkModel! {
        didSet {
            self.coordinate = self.protectionNetwork.coordinate
        }
    }
    
}
