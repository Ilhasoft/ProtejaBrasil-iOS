//
//  PBComplaintNavigationController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 03/03/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBComplaintNavigationController: UINavigationController {

    var complaintType: PBComplaintType!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: self.complaintType.trackName() + " report")
    }
    
}
