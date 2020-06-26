//
//  PBViewUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 18/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat, color: UIColor? = nil) {
        self.layer.cornerRadius = radius
        
        if let color = color {
            self.layer.borderWidth = 1
            self.borderColor(color: color)
        }
    }
    
    func borderColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
}
