//
//  PBTitleComplaintElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 05/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBTitleComplaintElement: UIView {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    private(set) var text: String!
    
    class func loadView() -> PBTitleComplaintElement {
        return UINib(nibName: "PBTitleComplaintElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBTitleComplaintElement
    }
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = false
        super.awakeFromNib()
    }
    
    func setText(text: String, obligatory: Bool = false) {
        let attributedString = NSMutableAttributedString(string: text)
        let blueAttributes: [NSAttributedString.Key : Any] = [
            .font: self.lbTitle.font,
            .foregroundColor: kBlueColor
        ]
        let textRange = NSRange(location: 0, length: text.count)
        attributedString.setAttributes(blueAttributes, range: textRange)
        if obligatory {
            let redAttributes: [NSAttributedString.Key : Any] = [
                .font: self.lbTitle.font,
                .foregroundColor: kRedColor
            ]
            let range = NSRange(location: text.count-1, length: 1)
            attributedString.setAttributes(redAttributes, range: range)
        }
        self.lbTitle.attributedText = attributedString
    }
    
}
