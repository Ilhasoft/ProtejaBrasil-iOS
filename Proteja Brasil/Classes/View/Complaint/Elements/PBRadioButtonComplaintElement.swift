//
//  PBRadioButtonComplaintElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 05/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBRadioButtonComplaintElement: UIView {
    
    @IBOutlet weak var button: UIButton!
    
    var apiKey: String?
    var isRequired: Bool!
    var value: AnyObject!
    var didSelectedClosure: (() -> Void)?
    var disabledMessage: String?
    var title: String! {
        didSet {
            self.button.setTitle(self.title, for: .normal)
        }
    }
    var selected: Bool! {
        willSet {
            self.button.isSelected = newValue
        }
    }
    
    class func loadView() -> PBRadioButtonComplaintElement {
        return UINib(nibName: "PBRadioButtonComplaintElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBRadioButtonComplaintElement
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.titleLabel?.lineBreakMode = .byWordWrapping
        self.button.titleLabel?.numberOfLines = 0
    }
    
    @IBAction func btSelected() {
        if let message = self.disabledMessage {
            UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: L10n.ok)
                .show()
        } else {
            self.button.isSelected = true
            self.didSelectedClosure?()
        }
    }
    
    func disableButton(message: String? = nil) {
        self.alpha = 0.5
        self.disabledMessage = message
    }
    
}

// MARK: - PBComplaintElementProtocol

extension PBRadioButtonComplaintElement: PBComplaintElementProtocol {
    
    func getData() -> (key: String, value: Any)? {
        if self.button.isSelected {
            if let apiKey = self.apiKey {
                return (key: apiKey, value: self.value)
            }
        }
        return nil
    }
    
    func isValid() -> Bool {
        return true
    }
    
}
