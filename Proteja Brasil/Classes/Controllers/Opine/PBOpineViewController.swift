//
//  PBOpineViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MBProgressHUD
import RSKGrowingTextView
import Google

enum PBFeedbackType: String {
    case doubt      = "Dúvida"
    case suggestion = "Sugestão"
    case criticism  = "Crítica"
    case compliment = "Elogio"
    
    var value: String {
        switch self {
        case .doubt:
            return "doubt"
        case .suggestion:
            return "suggestion"
        case .criticism:
            return "criticism"
        case .compliment:
            return "compliment"
        }
    }
}

class PBOpineViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtMessage: RSKGrowingTextView!
    @IBOutlet weak var btDoubt: PBFeedbackRadioButton!
    @IBOutlet weak var btSugestion: PBFeedbackRadioButton!
    @IBOutlet weak var btCriticism: PBFeedbackRadioButton!
    @IBOutlet weak var btCompliment: PBFeedbackRadioButton!
    @IBOutlet var allSubjectButtons: [PBFeedbackRadioButton]!
    
    private var feedbackType: PBFeedbackType!
    
    convenience init() {
        self.init(nibName: "PBOpineViewController", bundle: nil)
        self.feedbackType = PBFeedbackType.doubt
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.actionOpinion
        setupUI()
        self.setupRadioButtons()
        self.setupTranslations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "Feedback")
    }
    
    //MARK: Setup
    
    func setupUI() {
        self.btDoubt.isSelected = true
        self.viewName.roundCorners(radius: 18, color: kBlueColor)
        self.viewEmail.roundCorners(radius: 18, color: kBlueColor)
        self.viewMessage.roundCorners(radius: 18, color: kBlueColor)
        self.btSend.layer.cornerRadius = 20
        self.scrollView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    }
    
    private func setupTranslations() {
        let doubtText = L10n.labelDoubt
        let sugestionText = L10n.labelSuggestion
        let criticismText = L10n.labelCriticism
        let complimentText = L10n.labelCompliment
        let sendText = L10n.textSend
        self.lbTitle.text = L10n.titleOpinion
        self.btDoubt.setTitle(doubtText, for: .normal)
        self.btSugestion.setTitle(sugestionText, for: .normal)
        self.btCriticism.setTitle(criticismText, for: .normal)
        self.btCompliment.setTitle(complimentText, for: .normal)
        self.txtName.placeholder = L10n.hintOpinionName
        self.txtEmail.placeholder = L10n.hintOpinionEmail
        self.txtMessage.placeholder = L10n.hintOpinionMessage as NSString
        self.btSend.setTitle(sendText, for: .normal)
    }
    
    private func setupRadioButtons() {
        self.btDoubt.type = .doubt
        self.btSugestion.type = .suggestion
        self.btCriticism.type = .criticism
        self.btCompliment.type = .compliment
    }
    
    //MARK: Button Events
    
    @IBAction func btSubjectSelected(sender: PBFeedbackRadioButton) {
        sender.isSelected = true
        self.feedbackType = sender.type
        for button in self.allSubjectButtons {
            if button != sender {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func btSendTapped(sender: AnyObject) {
        self.view.endEditing(true)
        if self.txtMessage.text!.isEmpty || self.txtEmail.text!.isEmpty || self.txtName.text!.isEmpty {
            let messageText = L10n.alertFillAllFields
            UIAlertView(title: nil, message: messageText, delegate: self, cancelButtonTitle: L10n.ok).show()
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let name = self.txtName.text!
        let email = self.txtEmail.text!
        let message = self.txtMessage.text!
        PBAPI.feedback.insert(type: self.feedbackType, name: name, email: email, message: message) { feedback, error in
            if error != nil {
                let messageText = L10n.errorUnexpected
                showErrorAlert(message: messageText)
                hud.hide(animated: true)
                return
            }
            let thanksViewController = PBThanksForFeedbackViewController()
            self.navigationController?.pushViewController(thanksViewController, animated: true)
            hud.hide(animated: true)
            
            self.sendFeedbackEvent()
        }
    }
    
    private func sendFeedbackEvent() {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder = GAIDictionaryBuilder.createEvent(
            withCategory: "Feedback",
            action: "Send feedback",
            label: "Send feedback",
            value: 1
        )
        if let builder = builder {
            tracker?.send(builder.build() as [NSObject: AnyObject])
        }
    }
    
}
