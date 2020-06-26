//
//  PBLabel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

class PBLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.bounds.width
        super.layoutSubviews()
    }
    
}
