//
//  PBAddProtocolTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 02/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBAddProtocolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btAddProtocol: UIButton!
    
    static let nib = UINib(nibName: "PBAddProtocolTableViewCell", bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.btAddProtocol.roundCorners(radius: 15)
    }
    
}
