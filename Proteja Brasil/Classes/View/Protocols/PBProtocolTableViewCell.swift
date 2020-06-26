//
//  PBProtocolTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 02/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBProtocolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    static let nib = UINib(nibName: "PBProtocolTableViewCell", bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContent.layer.shadowColor = UIColor.black.cgColor
        self.viewContent.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewContent.layer.shadowOpacity = 0.15
        self.viewContent.layer.shadowRadius = 2.0
    }
    
    func updateFromProtocol() {
        let preferredWidth = screenSize.width - 73
        self.lbTitle.preferredMaxLayoutWidth = preferredWidth
        self.lbTitle.text = "Denúncia Violência psicológica"
        self.lbStatus.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.lbStatus.text = "Incompleto"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        self.lbDate.text = dateFormatter.string(from: Date())
    }
    
}
