//
//  PBThemeListTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 29/12/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import QuartzCore
import SDWebImage

class PBThemeListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    
    static let nib = UINib(nibName: "PBThemeListTableViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRoundedView()
    }
    
    // MARK: Setup
    
    private func setupRoundedView() {
        self.viewRounded.roundCorners(radius: 47/2)
    }
    
    // MARK: My functions
    
    func updateFromTheme(theme: PBThemeModel) {
        let preferredMaxLayoutWidth = screenSize.width - 103
        self.lbTitle.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        self.lbSubtitle.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        if let icon = theme.icon, let url = URL(string: icon) {
            self.imgIcon.sd_setImage(with: url)
        }
        if let color = theme.color {
            self.viewRounded.backgroundColor = UIColor(rgba: color)
        }
        self.lbTitle.text = theme.title
        self.lbSubtitle.text = theme.desc
    }
    
}
