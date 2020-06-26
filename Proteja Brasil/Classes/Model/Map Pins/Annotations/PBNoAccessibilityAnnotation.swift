//
//  PBNoAccessibilityAnnotation.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit

class PBNoAccessibilityAnnotation: MKPointAnnotation {
    
    override init() {
        super.init()
        
        self.title = "Arraste o marcador para o local desejado"
    }
    
}
