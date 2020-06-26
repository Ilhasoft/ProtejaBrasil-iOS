//
//  PBViolationTypeUniqueComplaintElementCell.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import SDWebImage
import QuartzCore

class PBViolationTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lbViolationName: UILabel!
    
    static let nib = UINib(nibName: "PBViolationTypeTableViewCell", bundle: nil)
    var violationType:PBViolationTypeModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK: Class Methods
    
    func setupCellWithData(violationType:PBViolationTypeModel) {
        let maxWitdh = screenSize.width - 45
        self.lbViolationName.preferredMaxLayoutWidth = maxWitdh
        self.violationType = violationType
        self.lbViolationName.text = violationType.name
    }
    
}
