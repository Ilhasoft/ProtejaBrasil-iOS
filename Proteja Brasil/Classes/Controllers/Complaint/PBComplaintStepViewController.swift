//
//  PBComplaintStepViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import YLProgressBar
import MBProgressHUD
import MZFormSheetPresentationController
import CoreLocation

class PBComplaintStepViewController: UIViewController {
    
    @IBOutlet weak var lbObligatory: UILabel!
    @IBOutlet weak var btNext: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintObligatoryFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintObligatoryFieldTop: NSLayoutConstraint!
    
    var steps: [PBComplaintStep]!
    var step: Int!
    var complaintType: PBComplaintType!
    private var currentStep: PBComplaintStep!
    
    var placemarkNoAccessibility: CLPlacemark?
    
    convenience init() {
        self.init(nibName: "PBComplaintStepViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentStep = self.steps[step]
        
        self.setupNavigationBar()
        self.setupStackView()
        self.setupNextButton()
        self.setupInfoButton()
        self.setupObligatoryFieldsLabel()
    }
    
    // MARK: Setup
    
    private func setupNavigationBar() {
        let imageClose = UIImage(named: "ic_fechar")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageClose, style: .plain, target: self, action: #selector(giveUpComplaint))
        
        if !self.hasOneStep() {
            let progress = YLProgressBar(frame: CGRect(x: 0, y: 0, width: self.screenSize.width-100, height: 10))
            progress.type = YLProgressBarType.rounded
            progress.progressTintColors = [kYellowColor]
            progress.hideStripes = true
            progress.hideGloss = true
            progress.trackTintColor = UIColor(red: 13/255, green: 172/255, blue: 191/255, alpha: 1)
            progress.progress = CGFloat(self.step)/CGFloat(self.steps.count)
            self.navigationItem.titleView = progress
        } else {
            self.navigationItem.title = self.currentStep.title
        }
    }
    
    private func setupStackView() {
        let stackView = self.currentStep.stackView!
        self.viewContent.addSubview(stackView)
        self.viewContent.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[stackView]-(20)-|",
                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["stackView": stackView])
        )
        var top = 84
        if self.currentStep.infoAction != nil {
            top += 25
        }
        self.viewContent.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(top))-[stackView]-(>=0)-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["stackView": stackView])
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(retractOptions))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    private func setupNextButton() {
        self.btNext.layer.cornerRadius = 20
        
        if self.isLastStep() {
            let reportText = L10n.textReport
            self.btNext.setTitle(reportText, for: .normal)
            self.btNext.backgroundColor = kRedColorButton
        } else {
            let nextText = L10n.textNext
            self.btNext.setTitle(nextText, for: .normal)
        }
    }
    
    private func setupInfoButton() {
        if let action = self.currentStep.infoAction {
            let btInfo = UIButton(frame: CGRect(x: screenSize.width-52, y: 74, width: 32, height: 32))
            btInfo.setImage(UIImage(named: "ic_help")!, for: .normal)
            btInfo.addTarget(self, action: action, for: .touchUpInside)
            self.viewContent.addSubview(btInfo)
        }
    }
    
    private func setupObligatoryFieldsLabel() {
        if !self.currentStep.hasObligatoryFields {
            self.constraintObligatoryFieldHeight.constant = 0
            self.constraintObligatoryFieldTop.constant = 0
        } else {
            self.lbObligatory.text = L10n.labelRequiredField
        }
    }
    
    // MARK: My functions
    
    private func isLastStep() -> Bool {
        return self.step == self.steps.count-1
    }
    
    private func hasOneStep() -> Bool {
        return self.steps.count == 1
    }
    
    private func canGoToNextStep() -> Bool {
        var can = true
        for element in self.currentStep.elements {
            if !element.isValid() {
                can = false
            }
        }
        return can
    }
    
    @IBAction func nextStep() {
        if !self.canGoToNextStep() {
            let alertTitleText = L10n.errorRequiredFields
            let alertController = UIAlertController(title: alertTitleText, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        if self.isLastStep() {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            var bodyData = [String: Any]()
            for step in self.steps {
                for stepData in step.getDataOfAllElements() {
                    bodyData[stepData.0] = stepData.1
                }
            }
            
            if self.complaintType == PBComplaintType.internetCrime {
                PBAPI.report.postInternetCrime(data: bodyData) { key, statusCode in
                    hud.hide(animated: true)
                    guard let key = key else {
                        let title = L10n.error
                        var message = L10n.errorUnexpected
                        if let statusCode = statusCode, statusCode == 422 {
                            message = L10n.errorInvalidUrl
                        }
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    let finishedViewController = PBComplaintFinishedViewController(complaintType: .internetCrime, result: key)
                    self.navigationController?.setViewControllers([finishedViewController], animated: true)
                    sendAnalyticAction(action: .finish, ofType: self.complaintType)
                }
            } else if self.complaintType == .violation {
                PBAPI.report.postViolation(data: bodyData) { result, error in
                    hud.hide(animated: true)
                    if let result = result {
                        let finishedViewController = PBComplaintFinishedViewController(complaintType: .violation, result: result)
                        self.navigationController?.setViewControllers([finishedViewController], animated: true)
                        sendAnalyticAction(action: .finish, ofType: self.complaintType)
                        return
                    } else if let error = error {
                        print("An error occurred while report the violation! \(error.localizedDescription)")
                    } else {
                        print("An unexpected error occurred!")
                    }
                    let alertTitleText = L10n.messageReportError
                    let alertController = UIAlertController(title: nil, message: alertTitleText, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            } else if self.complaintType == .noAccessibility {
                PBAPI.report.postNoAccessibility(data: bodyData) { _protocol, error in
                    hud.hide(animated: true)
                    guard let _protocol = _protocol else {
                        let alertTitleText = L10n.messageReportError
                        let alertController = UIAlertController(title: nil, message: alertTitleText, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    let finishedViewController = PBComplaintFinishedViewController(complaintType: .noAccessibility, result: _protocol)
                    self.navigationController?.setViewControllers([finishedViewController], animated: true)
                    sendAnalyticAction(action: .finish, ofType: self.complaintType)
                    return
                }
            }
        } else {
            let nextStepViewController = PBComplaintStepViewController()
            nextStepViewController.steps = self.steps
            nextStepViewController.step = self.step+1
            nextStepViewController.complaintType = self.complaintType
            self.navigationController?.pushViewController(nextStepViewController, animated: true)
        }
    }
    
    @objc func giveUpComplaint() {
        let alertTitleText = L10n.messageCancelReport
        let alertController = UIAlertController(title: nil, message: alertTitleText, preferredStyle: .alert)
        let giveUpText = L10n.optionGiveUp
        let giveUpAction = UIAlertAction(title: giveUpText, style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
            sendAnalyticAction(action: .giveUp, ofType: self.complaintType)
        }
        let continueText = L10n.optionContinue
        let continueAction = UIAlertAction(title: continueText, style: .default, handler: nil)
        alertController.addAction(giveUpAction)
        alertController.addAction(continueAction)
        alertController.preferredAction = continueAction
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func infoAboutSex() {
        let alertTitleText = L10n.titleGenderHelp
        let alertMessageText = L10n.messageGenderHelp
        let alertController = UIAlertController(title: "\(alertTitleText)\n", message: alertMessageText, preferredStyle: .alert)
        let actionText = L10n.labelHelpButton
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func retractOptions() {
        for element in self.currentStep.stackView.arrangedSubviews {
            if let themeSelector = element as? PBThemeSelectorElement {
                themeSelector.retractOptions()
            }
            if let optionSelector = element as? PBOptionSelectorComplaintElement {
                optionSelector.retractOptions()
            }
            if let textField = element as? PBTextFieldComplaintElement {
                _ = textField.resignFirstResponder()
            }
            if let textView = element as? PBTextViewComplaintElement {
                _ = textView.resignFirstResponder()
            }
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension PBComplaintStepViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let stackView = self.currentStep.stackView
        if touch.view == self.view || touch.view == stackView ||
            touch.view == self.scrollView || touch.view == self.viewContent {
            return true
        }
        return false
    }
}
