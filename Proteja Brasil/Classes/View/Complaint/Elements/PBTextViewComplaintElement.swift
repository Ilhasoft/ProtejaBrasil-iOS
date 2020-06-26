//
//  PBTextViewComplaintElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 28/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import TPKeyboardAvoiding

class PBTextViewComplaintElement: UIView {
    
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var textView: RSKGrowingTextView!
    
    var placeholder: String? {
        willSet {
            self.textView.placeholder = newValue as NSString?
        }
    }
    
    var apiKey: String?
    var isRequired: Bool!
    
    class func loadView() -> PBTextViewComplaintElement {
        return UINib(nibName: "PBTextViewComplaintElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBTextViewComplaintElement
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTextView()
        self.setupRoundedView()
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textView.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.textView.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    // MARK: Setup
    
    private func setupTextView() {
        self.textView.delegate = self
        self.textView.growingTextViewDelegate = self
    }
    
    private func setupRoundedView() {
        self.viewRounded.roundCorners(radius: 18, color: kGreyColor)
    }
    
}

// MARK: - PBComplaintElementProtocol

extension PBTextViewComplaintElement: PBComplaintElementProtocol {
    
    func getData() -> (key: String, value: Any)? {
        if let apiKey = self.apiKey {
            return (key: apiKey, value: self.textView.text!)
        }
        return nil
    }
    
    func isValid() -> Bool {
        if self.textView.text! == "" && self.isRequired == true {
            self.viewRounded.borderColor(color: kRedColor)
            return false
        }
        self.viewRounded.borderColor(color: kBlueColor)
        return true
    }
    
}

// MARK: - RSKGrowingTextViewDelegate

extension PBTextViewComplaintElement: RSKGrowingTextViewDelegate {

    func growingTextView(_ textView: RSKGrowingTextView, didChangeHeightFrom growingTextViewHeightBegin: CGFloat, to growingTextViewHeightEnd: CGFloat) {
        if let scrollView = self.superview?.superview?.superview as? TPKeyboardAvoidingScrollView {
            scrollView.scrollToActiveTextField()
        }
    }
}

// MARK: - UITextViewDelegate

extension PBTextViewComplaintElement: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.viewRounded.borderColor(color: kBlueColor)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text! == "" {
            self.viewRounded.borderColor(color: kGreyColor)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "\n" {
            textView.text = ""
        }
    }
}
