//
//  PBTextFieldComplaintElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 09/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBTextFieldComplaintElement: UIView {
    
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var apiKey: String?
    var isRequired: Bool! = false
    var placeholder: String? {
        willSet {
            self.textField.placeholder = newValue
        }
    }
    var returnKeyType: UIReturnKeyType! {
        willSet {
            self.textField.returnKeyType = newValue
        }
    }
    var returnClosure: (() -> Void)!
    var keyboardType: UIKeyboardType! {
        willSet {
            self.textField.keyboardType = newValue
        }
    }
    
    class func loadView() -> PBTextFieldComplaintElement {
        return UINib(nibName: "PBTextFieldComplaintElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBTextFieldComplaintElement
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRoundedView()
        self.setupTextField()
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.textField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    // MARK: Setup
    
    private func setupRoundedView() {
        self.viewRounded.roundCorners(radius: 18, color: kGreyColor)
    }
    
    private func setupTextField() {
        self.textField.delegate = self
        self.returnKeyType = .done
        self.returnClosure = {
            self.textField.resignFirstResponder()
        }
        self.keyboardType = .default
    }
    
}

// MARK: - UITextFieldDelegate

extension PBTextFieldComplaintElement: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewRounded.borderColor(color: kBlueColor)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.textField.text! == "" {
            self.viewRounded.borderColor(color: kGreyColor)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnClosure()
        return true
    }
}

// MARK: - PBComplaintElementProtocol

extension PBTextFieldComplaintElement: PBComplaintElementProtocol {
    
    func getData() -> (key: String, value: Any)? {
        if let apiKey = self.apiKey {
            return (key: apiKey, value: self.textField.text!)
        }
        return nil
    }
    
    func isValid() -> Bool {
        if self.textField.text! == "" && self.isRequired == true {
            self.viewRounded.borderColor(color: kRedColor)
            return false
        }
        self.viewRounded.borderColor(color: kBlueColor)
        return true
    }
    
}
