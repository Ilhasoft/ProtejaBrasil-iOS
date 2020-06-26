//
//  PBThemeSelectorTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 02/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

protocol PBThemeSelectorTableViewCellDelegate {
    func themeSelected(theme: PBThemeModel)
    func themeDeselected(theme: PBThemeModel)
}

class PBThemeSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var viewLine: UIView!
    
    private var theme: PBThemeModel!
    var delegate: PBThemeSelectorTableViewCellDelegate?
    
    static let nib = UINib(nibName: "PBThemeSelectorTableViewCell", bundle: nil)
    
    private func setThemeSelected(selected: Bool) {
        self.btSelect.isSelected = selected
        if self.btSelect.isSelected {
            self.delegate?.themeSelected(theme: self.theme)
        } else {
            self.delegate?.themeDeselected(theme: self.theme)
        }
    }
    
    func cellSelected() {
        self.setThemeSelected(selected: !self.btSelect.isSelected)
    }
    
    func updateFromTheme(theme: PBThemeModel, width: CGFloat, selected: Bool, isLast: Bool) {
        let preferredWidth = width - 56
        self.lbTitle.preferredMaxLayoutWidth = preferredWidth
        self.lbTitle.text = theme.title
        self.theme = theme
        self.setThemeSelected(selected: selected)
        if isLast {
            self.viewLine.isHidden = true
        }
    }
    
}
