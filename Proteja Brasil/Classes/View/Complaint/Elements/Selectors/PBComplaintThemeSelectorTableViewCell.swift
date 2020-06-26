//
//  PBComplaintThemeSelectorTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 14/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import SDWebImage

class PBComplaintThemeSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "PBComplaintThemeSelectorTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupImageView()
    }
    
    // MARK: Setup
    
    private func setupImageView() {
        self.viewRounded.roundCorners(radius: 14)
    }
    
    // MARK: My functions
    
    func updateFromTheme(theme: PBThemeModel) {
        self.viewRounded.backgroundColor = UIColor(rgba: theme.color)
        if let icon = theme.icon, let url = URL(string: icon) {
            self.imgIcon.sd_setImage(with: url)
        }
        self.lbTitle.preferredMaxLayoutWidth = self.frame.size.width-60
        self.lbTitle.text = theme.title
    }
    
}
