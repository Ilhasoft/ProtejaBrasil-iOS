//
//  PBViolationTypeDetailViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit
import QuartzCore
import Contacts
import ContactsUI
import MBProgressHUD

class PBViolationTypeDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var lbViolationTypeDescription: UILabel!
    @IBOutlet weak var lbWarning: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewNearesNetwork: UIView!
    @IBOutlet weak var btDenounce: UIButton!
    
    private var violationType: PBViolationTypeModel!
    private var protectionDetailView: PBProtectionDetailView!
    let protectionNetworkAPI = PBProtectionNetworkAPI()
    
    convenience init(violationType:PBViolationTypeModel) {
        self.init(nibName: "PBViolationTypeDetailViewController", bundle: nil)
        self.violationType = violationType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.protectionDetailView = PBProtectionDetailView.loadView()
        self.protectionDetailView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidAuthorizedWhenInUse),
            name: Notification.Name("userDidAuthorizedWhenInUse"),
            object: nil
        )
        
        self.setupUIWithViolationType()
        self.loadNearestProtectionNetwork()
        self.setupDenounceButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "Violation type detail")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var frame = self.viewBottom.frame
        frame.origin.x = 0
        frame.origin.y = 0
        self.protectionDetailView.frame = frame
        self.viewBottom.addSubview(self.protectionDetailView)
        self.protectionDetailView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UINavigationController().navigationBar.backgroundImage(for: UIBarMetrics.default), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.tintColor = kWhiteColor
        self.navigationController?.navigationBar.barTintColor = kBlueColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: Setup
    
    private func setupDenounceButton() {
        self.btDenounce.layer.shadowColor = UIColor.black.cgColor
        self.btDenounce.layer.shadowOpacity = 0.3
        self.btDenounce.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.btDenounce.layer.shadowRadius = 2.5
    }

    //MARK: Class Methods
    
    @objc func userDidAuthorizedWhenInUse() {
//        loadNearestProtectionNetwork()
    }
    
    func loadNearestProtectionNetwork() {                
        guard let coordinate2D = PBLocationManager.sharedInstance().getCLLocationCoordinate2D() else {
            self.showWarningMessage(message: L10n.textNoNearestNet)
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        protectionNetworkAPI.getNearestProtectionNetwork(lat: coordinate2D.latitude, long: coordinate2D.longitude,
            protectionNetworkTypeId: self.violationType.id) { protectionNetworkModel, error in
                hud.hide(animated: true)
                guard let protectionNetwork = protectionNetworkModel else {
                    self.showWarningMessage(message: L10n.textNoProtectionNetwork)
                    return
                }
                self.viewNearesNetwork.isHidden = false
                self.protectionDetailView.isHidden = false
                self.protectionDetailView.setupViewWithData(protectionNetwork: protectionNetwork)
                self.addProtectionNetworkPin(protectionNetwork: protectionNetwork)
        }
    }
    
    private func addProtectionNetworkPin(protectionNetwork: PBProtectionNetworkModel) {
        let protectionAnnotation = PBProtectionNetworkAnnotation()
        protectionAnnotation.protectionNetwork = protectionNetwork
        self.mapView.addAnnotation(protectionAnnotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func showWarningMessage(message: String) {
        self.lbWarning.isHidden = false
        self.lbWarning.text = message
        self.protectionDetailView.isHidden = true
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupUIWithViolationType() {
        self.title = violationType.name
        self.lbViolationTypeDescription.text = violationType.desc
        self.viewTop.backgroundColor = UIColor(rgba: violationType.theme.color)
        self.viewNearesNetwork.roundCorners(radius: 10)
        self.viewNearesNetwork.isHidden = true
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView? = nil

        if let annotation = annotation as? PBProtectionNetworkAnnotation {
            annotationView = PBProtectionNetworkPinAnnotationView(annotation: annotation)
        }

        return annotationView
    }
    
    @IBAction func denounceViolation() {
        let stepViewController = createComplaintViewController(forType: .violation)
        let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
        navigationController.complaintType = .violation
        self.present(navigationController, animated: true, completion: nil)
        sendAnalyticAction(action: .start, ofType: .violation)
    }
}

extension PBViolationTypeDetailViewController: PBProtectionDetailViewDelegate {
    
    func showContactFromProtectionNetwork(protectionNetwork: PBProtectionNetworkModel) {
        let contactRecord = protectionNetwork.contactRecord
        let contactViewController = CNContactViewController(forNewContact: contactRecord)
        contactViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: contactViewController)
        navigationController.navigationBar.tintColor = kBlueColor
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.revealViewController().present(navigationController, animated: true, completion: nil)
    }
}

extension PBViolationTypeDetailViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
