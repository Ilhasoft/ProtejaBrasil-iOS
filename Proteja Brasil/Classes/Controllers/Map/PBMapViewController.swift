//
//  PBMapViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 16/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import MZFormSheetPresentationController
import Contacts
import ContactsUI
import LGPlusButtonsView
import SafariServices
import CoreLocation
import PureLayout

private enum PBTextFieldFunction: Int {
    case SearchProtectionNetworks
    case SearchAddress
}

class PBMapViewController: UIViewController {
    
    @IBOutlet weak var tableDropDown: UITableView!
    @IBOutlet weak var btDropDown: UIButton!
    @IBOutlet weak var constraintTableDropDownHeight: NSLayoutConstraint!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lbProtectAndReport: UILabel!
    
    var txtSearch:UITextField!
    var indexPath: IndexPath?
    var shouldShowFloatButton = false
    
    private var arrStatesInitials: [String]!
    private var dicStates: [String: String]!
    private var strDefaultStateInitials: String? {
        get {
            return getDefaultStateInitials()
        }
        set(value) {
            setDefaultState(initials: value)
        }
    }
    private var tableDropDownIsOpen: Bool!
    private var viewProtectionDetail: PBProtectionDetailView!
    private var arrAnotationsToShow = [PBProtectionNetworkAnnotation]()
    private var arrThemes: [PBThemeModel]?
    private var arrProtectionNetworks = [PBProtectionNetworkModel]()
    private var themeIdsSelected = Set<Int>()
    private var floatButton: LGPlusButtonsView!
    private var tapGestureDismissKeyboard: UITapGestureRecognizer!
    private var tablePlacemarks: UITableView!
    private var arrPlacemarksSearched = [CLPlacemark]()
    private var btFloatNoAccessibility: LGPlusButtonsView!
    private var canSelectOnFloatButton = false
    private var gestureTablePlacemarksTapped: UITapGestureRecognizer!
    private var gestureMapLongPress: UILongPressGestureRecognizer!
    private var gestureMapTap: UITapGestureRecognizer!
    private var constraintViewProtectionBottom: NSLayoutConstraint!
    private var constraintViewProtectionBottomHide: NSLayoutConstraint!
    
    private var placemarkNoAccessibility: CLPlacemark?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    convenience init() {
        self.init(nibName: "PBMapViewController", bundle: nil)
        
        self.arrStatesInitials = [
            "AC",
            "AL",
            "AP",
            "AM",
            "BA",
            "CE",
            "DF",
            "ES",
            "GO",
            "MA",
            "MT",
            "MS",
            "MG",
            "PA",
            "PB",
            "PR",
            "PE",
            "PI",
            "RJ",
            "RN",
            "RS",
            "RO",
            "RR",
            "SC",
            "SP",
            "SE",
            "TO"
        ]
        
        self.dicStates = [String: String]()
        //self.arrStatesNames["__"] = "Seu local"
        self.dicStates["AC"] = "Acre"
        self.dicStates["AL"] = "Alagoas"
        self.dicStates["AP"] = "Amapá"
        self.dicStates["AM"] = "Amazonas"
        self.dicStates["BA"] = "Bahia"
        self.dicStates["CE"] = "Ceará"
        self.dicStates["DF"] = "Distrito Federal"
        self.dicStates["ES"] = "Espírito Santo"
        self.dicStates["GO"] = "Goiás"
        self.dicStates["MA"] = "Maranhão"
        self.dicStates["MT"] = "Mato Grosso"
        self.dicStates["MS"] = "Mato Grosso do Sul"
        self.dicStates["MG"] = "Minas Gerais"
        self.dicStates["PA"] = "Pará"
        self.dicStates["PB"] = "Paraíba"
        self.dicStates["PR"] = "Paraná"
        self.dicStates["PE"] = "Pernambuco"
        self.dicStates["PI"] = "Piauí"
        self.dicStates["RJ"] = "Rio de Janeiro"
        self.dicStates["RN"] = "Rio Grande do Norte"
        self.dicStates["RS"] = "Rio Grande do Sul"
        self.dicStates["RO"] = "Rondônia"
        self.dicStates["RR"] = "Roraima"
        self.dicStates["SC"] = "Santa Catarina"
        self.dicStates["SP"] = "São Paulo"
        self.dicStates["SE"] = "Sergipe"
        self.dicStates["TO"] = "Tocantins"
        
        self.tableDropDownIsOpen = false

        self.tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableDropDown.rowHeight = 46
        self.tableDropDown.register(PBDropDownTableViewCell.nib, forCellReuseIdentifier: "DropDownCell")
        self.tableDropDown.isScrollEnabled = false
        
        self.map.showsUserLocation = true
        
        self.loadProtectionNetworks(state: strDefaultStateInitials)
        self.loadThemes()
        self.setupNavigationBar()
        self.setupFloatButton()
        self.updateMapAnnotations()
        self.setupPlacemarksTableView()
        self.setupKeyboardNotifications()
        self.setupToastLabel()
        self.setupMapView()
        self.setupProtectionNetworkView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let stateInitials = self.strDefaultStateInitials {
            let stateIndex = self.arrStatesInitials!.index(of: stateInitials)!
            let indexPath = IndexPath(row: stateIndex, section: 0)
            self.updateOffsetOfTableStates(indexPath: indexPath)
            self.indexPath = indexPath
        }
        
        if self.btFloatNoAccessibility == nil {
            self.setupFloatButtonForNoAccessibility()
        }
        
        if self.shouldShowFloatButton {
            self.showFloatButtons()
            self.shouldShowFloatButton = false
        }
        
        if self.lbProtectAndReport.alpha != 0 {
            Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(hideProtectAndReportLabel),
                userInfo: nil,
                repeats: false
            )
        }
        
        self.trackViewControllerWithName(name: "Map")
    }

    // MARK: Setup
    
    private func setupNavigationBar() {
        let imageMenu = UIImage(named: "imgMenu")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageMenu, style: .plain, target: self, action: #selector(showMenu))
        
        self.setupSearchTextField()
        
        let imageFilter = UIImage(named: "imgFiltro")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageFilter, style: .plain, target: self, action: #selector(showFilterOptions))
    }
    
    private func setupFloatButton() {
        self.floatButton = LGPlusButtonsView(numberOfButtons: 6, firstButtonIsPlusButton: true, showAfterInit: true, delegate: self)
        self.floatButton.coverColor = UIColor(white: 0, alpha: 0.7)
        self.floatButton.position = .bottomRight
        self.floatButton.plusButtonAnimationType = .crossDissolve
        self.floatButton.setDescriptionsTexts([
            "",
            L10n.labelReport,
            L10n.labelInternetCrim,
            L10n.labelAccessibility,
            L10n.labelReportCall,
            L10n.labelReportCall180
        ])
        self.floatButton.setButtonsBackgroundImages([
            NSNull(),
            UIImage(named: "imgButtonVermelho")!,
            UIImage(named: "imgButtonLaranja")!,
            UIImage(named: "imgButtonAzul")!,
            UIImage(named: "imgButtonVerde")!,
            UIImage(named: "imgButtonRoxo")!
            ], for: .normal)
        self.floatButton.setButtonsImages([
            UIImage(named: "imgFloat")!,
            UIImage(named: "imgViolacao")!,
            UIImage(named: "imgViolacaoInternet")!,
            UIImage(named: "imgAcessivel")!,
            UIImage(named: "imgButtonDisque")!,
            UIImage(named: "imgButtonDisque180")!,
            ], for: .normal, for: .all)
        self.floatButton.setDescriptionsTextColor(UIColor.white)
        self.floatButton.setButtonsLayerShadowOffset(CGSize(width: -2, height: 2))
        self.floatButton.setButtonsLayerShadowColor(UIColor.black)
        self.floatButton.setButtonsLayerShadowOpacity(0.5)
        self.floatButton.setButtonsLayerShadowRadius(2)
        for i in 1...5 {
            let uint = UInt(i)
            self.floatButton.setButtonAt(uint, size: CGSize(width: 58, height: 58), for: .all)
            self.floatButton.setButtonAt(uint, insets: UIEdgeInsets(top: 0, left: 0, bottom: 26, right: 13), for: .all)
        }
        self.floatButton.setButtonAt(3, imageOffset: CGPoint(x: 1.5, y: -0.5), for: .all)
        self.floatButton.tag = 0
        self.navigationController?.view.addSubview(floatButton)
    }
    
    private func setupSearchTextField() {
        self.txtSearch = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 26))
        txtSearch.textAlignment = .center
        txtSearch.clearButtonMode = .always
        txtSearch.backgroundColor = kWhiteColor
        txtSearch.tintColor = kBlueColor
        txtSearch.roundCorners(radius: 13)
        txtSearch.font = UIFont(name: "HelveticaNeue", size: 14)
        txtSearch.placeholder = L10n.hintSearchNetworks
        txtSearch.returnKeyType = .search
        txtSearch.delegate = self
        txtSearch.tag = PBTextFieldFunction.SearchProtectionNetworks.rawValue
        self.navigationItem.titleView = txtSearch
    }
    
    private func setupForNormalAccess() {
        self.map.isUserInteractionEnabled = true
        self.tableDropDown.isUserInteractionEnabled = true
        self.btDropDown.isUserInteractionEnabled = true
        self.floatButton.show(animated: true, completionHandler: nil)
        self.btFloatNoAccessibility.hide(animated: true) {
            self.btFloatNoAccessibility.removeFromSuperview()
        }
        self.setupSearchTextField()
        UIView.animate(withDuration: 0.2, animations: {
            self.tablePlacemarks.alpha = 0
        }) { _ in
            self.arrPlacemarksSearched.removeAll()
            self.tablePlacemarks.reloadData()
        }
        self.placemarkNoAccessibility = nil
    }
    
    private func setupForNoAccessibility() {
        self.map.isUserInteractionEnabled = false
        self.tableDropDown.isUserInteractionEnabled = false
        self.btDropDown.isUserInteractionEnabled = false
        self.floatButton.hide(animated: true, completionHandler: nil)
        self.txtSearch.tag = PBTextFieldFunction.SearchAddress.rawValue
        self.txtSearch.placeholder = L10n.hintSearchPlaces
        self.txtSearch.becomeFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.tablePlacemarks.alpha = 1
            self.lbProtectAndReport.alpha = 0
        })
    }
    
    private func setupPlacemarksTableView() {
        var frame = CGRect(origin: CGPoint.zero, size: self.screenSize)
        frame.origin.y = 64
        frame.size.height -= 64
        self.tablePlacemarks = UITableView(frame: frame, style: .plain)
        self.tablePlacemarks.alpha = 0
        self.tablePlacemarks.delegate = self
        self.tablePlacemarks.dataSource = self
        self.tablePlacemarks.tag = 1
        self.tablePlacemarks.separatorStyle = .none
        self.tablePlacemarks.rowHeight = UITableView.automaticDimension
        self.tablePlacemarks.estimatedRowHeight = 65
        self.tablePlacemarks.register(PBSearchLocationTableViewCell.nib, forCellReuseIdentifier: "PlacemarkCell")
        self.navigationController?.view.addSubview(self.tablePlacemarks)

        self.gestureTablePlacemarksTapped = UITapGestureRecognizer(target: self, action: #selector(tablePlacemarksTapped))
        self.gestureTablePlacemarksTapped.delegate = self
        self.tablePlacemarks.addGestureRecognizer(self.gestureTablePlacemarksTapped)
    }
    
    private func setupKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupFloatButtonForNoAccessibility() {
        self.btFloatNoAccessibility = LGPlusButtonsView(numberOfButtons: 3,
            firstButtonIsPlusButton: true, showAfterInit: true, delegate: self)
        self.btFloatNoAccessibility.position = .bottomRight
        self.btFloatNoAccessibility.coverColor = UIColor(white: 0, alpha: 0.5)
        self.btFloatNoAccessibility.buttonsAppearingAnimationType = .crossDissolveAndSlideVertical
        self.btFloatNoAccessibility.setButtonsImages([
            UIImage(named: "imgPinAcessibilidade")!,
            UIImage(named: "imgButtonDenuncia")!,
            UIImage(named: "imgButtonX")!
            ], for: .normal, for: .all)
        self.btFloatNoAccessibility.setDescriptionsTexts([
            "",
            L10n.textReport,
            L10n.optionCancel
            ])
        for i in 1...2 {
            let uint = UInt(i)
            self.btFloatNoAccessibility.setButtonAt(uint, offset: CGPoint(x: -8, y: 0), for: .all)
            self.btFloatNoAccessibility.setDescriptionAt(uint, offset: CGPoint(x: -(self.map.center.x-40), y: 0), for: .all)
        }
        self.btFloatNoAccessibility.setDescriptionsTextColor(kWhiteColor)
        self.btFloatNoAccessibility.setContentEdgeInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), for: .all)
        self.btFloatNoAccessibility.offset = CGPoint(x: -(self.map.center.x-30.5-4), y: -self.map.center.y+96+4)
        self.btFloatNoAccessibility.tag = 1
    }
    
    private func setupToastLabel() {
        self.lbProtectAndReport.roundCorners(radius: 10)
        self.lbProtectAndReport.text = L10n.textProtectReport
    }
    
    private func setupMapView() {
        self.gestureMapLongPress = UILongPressGestureRecognizer(target: self, action: #selector(mapTapped(gesture:)))
        self.gestureMapLongPress.minimumPressDuration = 0
        self.gestureMapLongPress.delegate = self
        self.map.addGestureRecognizer(self.gestureMapLongPress)
        self.gestureMapTap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(gesture:)))
        self.map.addGestureRecognizer(self.gestureMapTap)
    }
    
    private func setupProtectionNetworkView() {
        self.viewProtectionDetail = PBProtectionDetailView.loadView()
        self.viewProtectionDetail.delegate = self
        self.view.addSubview(self.viewProtectionDetail)
        
        self.viewProtectionDetail.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        self.viewProtectionDetail.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        self.viewProtectionDetail.autoSetDimension(.height, toSize: 167)
        
        NSLayoutConstraint.autoSetPriority(UILayoutPriority(rawValue: 1)) {
            self.constraintViewProtectionBottom = self.viewProtectionDetail.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        }
        NSLayoutConstraint.autoSetPriority(UILayoutPriority(rawValue: 999)) {
            self.constraintViewProtectionBottomHide = self.viewProtectionDetail.autoPinEdge(toSuperviewEdge: .bottom, withInset: -167)
        }
    }
    
    // MARK: Keyboard functions
    
    @objc func dismissKeyboard() {
        self.txtSearch.resignFirstResponder()
        self.txtSearch.text = ""
        self.setupForNormalAccess()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardRect.size.height
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        self.tablePlacemarks.contentInset = edgeInsets
        self.tablePlacemarks.scrollIndicatorInsets = edgeInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tablePlacemarks.contentInset = edgeInsets
        self.tablePlacemarks.scrollIndicatorInsets = edgeInsets
    }
    
    // MARK: My functions
    
    @objc private func hideProtectAndReportLabel() {
        UIView.animate(withDuration: 0.5) {
            self.lbProtectAndReport.alpha = 0
        }
    }
    
    @objc private func mapTapped(gesture: UIGestureRecognizer) {
        if self.tableDropDownIsOpen! {
            self.showStates()
        }
        self.dismissKeyboard()
    }
    
    private func showNearestProtectionNetworks() {
        if let userCoordinate = PBLocationManager.sharedInstance().getCLLocationCoordinate2D() {
            let nearest = self.arrProtectionNetworks.filter { protectionNetwork in
                if let distance = protectionNetwork.distanceBetweenUserLocation() {
                    if distance < 5000 {
                        return true
                    }
                }
                return false
            }
            if nearest.count > 0 {
                var annotations = [MKPointAnnotation]()
                nearest.forEach { protectionNetwork in
                    let annotation = PBProtectionNetworkAnnotation()
                    annotation.protectionNetwork = protectionNetwork
                    annotations.append(annotation)
                }
                let userAnnotation = MKPointAnnotation()
                userAnnotation.coordinate = userCoordinate
                annotations.append(userAnnotation)
                self.map.showAnnotations(annotations, animated: true)
                self.map.view(for: userAnnotation)?.isHidden = true
            }
        }
    }
    
    private func updateMapAnnotations() {
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotations(self.arrAnotationsToShow)
        self.map.showAnnotations(self.arrAnotationsToShow, animated: true)
    }
    
    private func loadProtectionNetworks(state: String?, themeId: Int? = nil) {
        if let state = state {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            PBAPI.protectionNetwok.getProtectionNetworks(state: state, themeId: themeId) { protectionNetworks, error in
                self.showProtectionNetworks(protectionNetworks: protectionNetworks, error: error)
                if error == nil {
                    self.showNearestProtectionNetworks()
                }
                hud.hide(animated: true)
            }
        }
    }
    
    private func showProtectionNetworks(protectionNetworks: [PBProtectionNetworkModel]?, error: Error? = nil, isFirstLoad: Bool = true) {
        if let error = error {
            print("An error occurred while retrieving the protection networks! \(error)")
        } else if let protectionNetworks = protectionNetworks {
            self.arrAnotationsToShow.removeAll()
            if isFirstLoad {
                self.arrProtectionNetworks = protectionNetworks
            }
            
            for protectionNetwork in protectionNetworks {
                let annotation = PBProtectionNetworkAnnotation()
                annotation.protectionNetwork = protectionNetwork
                self.arrAnotationsToShow.append(annotation)
            }
            
            self.updateMapAnnotations()
        } else {
            print("An unexpected error occurred while retrieving the protection networks!")
        }
    }
    
    private func loadThemes() {
        PBAPI.theme.getThemes { themes, error in
            if let error = error {
                print("An error occurred while retrieving the themes! \(error)")
            } else if let themes = themes {
                self.arrThemes = themes
                for theme in themes {
                    self.themeIdsSelected.insert(theme.id)
                }
            } else {
                print("An unexpected error occurred while retrieving the themes!")
            }
        }
    }
    
    @objc func showMenu() {
        self.revealViewController()?.revealToggle(animated: true)
    }

    @IBAction func showStates() {
        let load = self.tableDropDownIsOpen! ? false : true
        if let indexPath = self.indexPath {
            animateTableView(indexPath: indexPath, loadProtectionNetworks: load)
        } else {
            animateTableView(indexPath: IndexPath(row: 0, section: 1), loadProtectionNetworks: load)
        }
    }
    
    @objc func showFilterOptions() {
        if let themes = self.arrThemes {
            let themeSelectorViewController = PBThemeSelectorViewController(themes: themes, idsSelected: self.themeIdsSelected)
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: themeSelectorViewController)
            formSheetController.presentationController?.shouldCenterHorizontally = false
            formSheetController.presentationController?.shouldCenterVertically = false
            formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
            formSheetController.presentationController?.backgroundColor = UIColor.clear
            formSheetController.contentViewCornerRadius = 3
            formSheetController.contentViewControllerTransitionStyle = .fade
            formSheetController.shadowRadius = 3
            formSheetController.view.layer.shadowOpacity = 0.4
            formSheetController.willPresentContentViewControllerHandler = { vc in
                let viewController = vc as! PBThemeSelectorViewController
                let height = viewController.tableView.contentSize.height + 60
                formSheetController.presentationController?.contentViewSize = CGSize(width: 280, height: height)
            }
            formSheetController.presentationController?.frameConfigurationHandler = { view, rect, _ in
                let origin = CGPoint(x: self.screenSize.width - rect.size.width - 5, y: 50)
                let newRect = CGRect(origin: origin, size: rect.size)
                return newRect
            }
            formSheetController.willDismissContentViewControllerHandler = { vc in
                let viewController = vc as! PBThemeSelectorViewController
                let ids = viewController.themesIdSelected()
                let union = self.themeIdsSelected.union(ids)
                let intersection = self.themeIdsSelected.intersection(ids)
                if union.subtracting(intersection).count > 0 {
                    self.themeIdsSelected = ids
                    let protectionsToShow = self.arrProtectionNetworks.filter { protection in
                        let hasTheme = protection.themes.filter { theme in
                            return self.themeIdsSelected.contains(theme.id)
                            }.count > 0
                        return hasTheme
                    }
                    self.showProtectionNetworks(protectionNetworks: protectionsToShow, isFirstLoad: false)
                }
            }
            self.present(formSheetController, animated: true, completion: nil)
        }
    }
    
    func animateTableView(indexPath: IndexPath, loadProtectionNetworks: Bool = false) {
        if self.tableDropDownIsOpen! {
            self.constraintTableDropDownHeight.constant = 46
            self.tableDropDown.isScrollEnabled = false
            
            self.strDefaultStateInitials = self.arrStatesInitials[indexPath.row]
            
            if loadProtectionNetworks {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                PBAPI.protectionNetwok.getProtectionNetworks(state: self.strDefaultStateInitials) { protectionNetworks, error in
                    self.showProtectionNetworks(protectionNetworks: protectionNetworks, error: error)
                    hud.hide(animated: true)
                }
            }
        } else {
            self.constraintTableDropDownHeight.constant = 276
            self.tableDropDown.isScrollEnabled = true
            if self.map.selectedAnnotations.count > 0 {
                self.map.deselectAnnotation(self.map.selectedAnnotations[0], animated: true)
            }
        }
        
        self.tableDropDownIsOpen = !self.tableDropDownIsOpen
        self.updateOffsetOfTableStates(indexPath: indexPath)
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            if self.tableDropDownIsOpen! {
                self.btDropDown.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 * Double.pi / 180.0))
            } else {
                self.btDropDown.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    private func updateOffsetOfTableStates(indexPath: IndexPath) {
        let newOffset = self.tableDropDown.rectForRow(at: indexPath).origin
        self.tableDropDown.setContentOffset(newOffset, animated: true)
    }
    
    @objc private func tablePlacemarksTapped() {
        if self.arrPlacemarksSearched.count == 0 {
            self.setupForNormalAccess()
            sendAnalyticAction(action: .giveUp, ofType: .noAccessibility)
        }
    }
    
    private func showFloatButtons() {
        self.floatButton.showButtons(animated: true, completionHandler: nil)
        for annotation in self.map.selectedAnnotations {
            self.map.deselectAnnotation(annotation, animated: false)
        }
    }
    
    @IBAction func showUserLocation() {
        let userLocation = self.map.userLocation
        self.map.setCenter(userLocation.coordinate, animated: true)
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension PBMapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.gestureTablePlacemarksTapped {
            if self.arrPlacemarksSearched.count != 0 {
                return false
            }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.gestureMapLongPress || gestureRecognizer == self.gestureMapTap {
            return true
        }
        return false
    }
}

// MARK: - UITableViewDataSource

extension PBMapViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableDropDown {
            return self.dicStates.count
        }
        return self.arrPlacemarksSearched.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableDropDown {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
            let stateInitials = self.arrStatesInitials[indexPath.row]
            cell.textLabel?.text = self.dicStates[stateInitials]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlacemarkCell", for: indexPath) as! PBSearchLocationTableViewCell
            let placemark = self.arrPlacemarksSearched[indexPath.row]
            cell.updateCellFromPlacemark(placemark: placemark)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension PBMapViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableDropDown {
            var load = false
            if let ip = self.indexPath {
                load = (ip.row == indexPath.row) ? false : true
            }
            self.indexPath = indexPath
            animateTableView(indexPath: indexPath, loadProtectionNetworks: load)
            if load {
                if let themes = self.arrThemes {
                    self.themeIdsSelected.removeAll()
                    for theme in themes {
                        self.themeIdsSelected.insert(theme.id)
                    }
                }
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let placemark = self.arrPlacemarksSearched[indexPath.row]
            let coordinate = placemark.location!.coordinate
            self.map.setCenter(coordinate, animated: false)
            let meters = 325.0
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: meters, longitudinalMeters: meters)
            let mapRegion = self.map.regionThatFits(viewRegion)
            self.map.setRegion(mapRegion, animated: false)
            
            self.navigationController?.view.addSubview(self.btFloatNoAccessibility)
            self.btFloatNoAccessibility.show(animated: true, completionHandler: nil)
            self.btFloatNoAccessibility.isUserInteractionEnabled = true
            
            self.txtSearch.resignFirstResponder()
            
            UIView.animate(withDuration: 0.2) {
                self.tablePlacemarks.alpha = 0
            }
            
            self.placemarkNoAccessibility = placemark
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableDropDown {
            self.dismissKeyboard()
        }
    }
}

// MARK: - MKMapViewDelegate

extension PBMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationView = view as? PBProtectionNetworkPinAnnotationView, let annotation = annotationView.annotation {
            self.floatButton.hide(animated: true, completionHandler: nil)
            self.viewProtectionDetail.setupViewWithData(protectionNetwork: annotationView.protectionNetwork)
            UIView.animate(withDuration: 0.25) {
                let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                let translateTransform = CGAffineTransform(translationX: 0, y: -8)
                view.transform = scaleTransform.concatenating(translateTransform)

                self.constraintViewProtectionBottom.priority = UILayoutPriority(rawValue: 999)
                self.constraintViewProtectionBottomHide.priority = UILayoutPriority(rawValue: 1)
                self.view.layoutIfNeeded()
            }

            var point = self.map.convert(annotation.coordinate, toPointTo: self.map)
            point.y += self.map.frame.size.height/4
            let coordinate = self.map.convert(point, toCoordinateFrom: self.map)
            self.map.setCenter(coordinate, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.floatButton.show(animated: true, completionHandler: nil)
        UIView.animate(withDuration: 0.25) {
            let scaleTransform = CGAffineTransform(scaleX: 1, y: 1)
            let translateTransform = CGAffineTransform(translationX: 0, y: 0)
            view.transform = scaleTransform.concatenating(translateTransform)

            self.constraintViewProtectionBottom.priority = UILayoutPriority(rawValue: 1)
            self.constraintViewProtectionBottomHide.priority = UILayoutPriority(rawValue: 999)
            self.view.layoutIfNeeded()
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? PBProtectionNetworkAnnotation {
            annotationView = PBProtectionNetworkPinAnnotationView(annotation: annotation)
        } else if annotation.isKind(of: MKPointAnnotation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "View")
            annotationView?.isHidden = true
        }
        return annotationView
    }
}

// MARK: - UITextFieldDelegate

extension PBMapViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addGestureRecognizer(self.tapGestureDismissKeyboard)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(self.tapGestureDismissKeyboard)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        self.setupForNormalAccess()
        if textField.tag == PBTextFieldFunction.SearchAddress.rawValue {
            sendAnalyticAction(action: .giveUp, ofType: .noAccessibility)
        }
        self.showProtectionNetworks(protectionNetworks: self.arrProtectionNetworks)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == PBTextFieldFunction.SearchAddress.rawValue {
            let filter: (CLPlacemark) -> Bool = { placemark in
                if placemark.thoroughfare == nil || placemark.location == nil {
                    return false
                }
                return true
            }
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            PBLocationManager.sharedInstance().placemarksFromString(string: text, filter: filter) { placemarks in
                if let placemarks = placemarks {
                    self.arrPlacemarksSearched = placemarks
                    self.tablePlacemarks.reloadData()
                }
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let text = textField.text!
        if text == "" {
            self.setupForNormalAccess()
            if textField.tag == PBTextFieldFunction.SearchAddress.rawValue {
                sendAnalyticAction(action: .giveUp, ofType: .noAccessibility)
            }
            return true
        }
        
        if textField.tag == PBTextFieldFunction.SearchAddress.rawValue {
            textField.resignFirstResponder()
            return true
        }
        
        let name = textField.text!
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        
        let userCoordinate = PBLocationManager.sharedInstance().getCLLocationCoordinate2D()
        PBAPI.protectionNetwok.getProtectionNetworks(name: name, userCoordinate: userCoordinate) { protectionNetworks, error in
            hud.hide(animated: true)
            guard let protectionNetworks = protectionNetworks else {
                print("An error occurred while retrieving the nearest protection networks by name! \(String(describing: error))")
                let alertTitle = L10n.errorMessageNetworksNotFound

                let alertController = UIAlertController(title: nil, message: alertTitle, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)

                return
            }
            guard protectionNetworks.count != 0 else {
                print("An error occurred while retrieving the nearest protection networks by name! \(String(describing: error))")
                let alertTitle = L10n.errorMessageNetworksNotFound
                let alertController = UIAlertController(title: nil, message: alertTitle, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let resultsViewController = PBProtectionNetworkSearchTableViewController(style: .plain)
            resultsViewController.arrSearchResults = protectionNetworks
            resultsViewController.delegate = self
            
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: resultsViewController)
            formSheetController.presentationController?.contentViewSize = CGSize(width: self.screenSize.width-20, height: self.screenSize.height - 100)
            formSheetController.presentationController?.shouldCenterHorizontally = true
            formSheetController.presentationController?.shouldCenterVertically = true
            formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
            self.present(formSheetController, animated: true, completion: nil)
            self.txtSearch.resignFirstResponder()
        }
        
        return true
    }
    
}

// MARK: - PBProtectionNetworkSearchTableViewControllerDelegate

extension PBMapViewController: PBProtectionNetworkSearchTableViewControllerDelegate {
    
    func showProtectionNetwork(protectionNetwork: PBProtectionNetworkModel) {
        let annotation = PBProtectionNetworkAnnotation()
        annotation.protectionNetwork = protectionNetwork
        self.map.showAnnotations([annotation], animated: true)
        self.map.selectAnnotation(annotation, animated: false)
    }
}

// MARK: - PBProtectionDetailViewDelegate

extension PBMapViewController: PBProtectionDetailViewDelegate {
    
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

extension PBMapViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PBLocationManagerDelegate

extension PBMapViewController: PBLocationManagerDelegate {
    
    func administrativeAreaRetrieved(administrativeArea: String?) {
        if self.strDefaultStateInitials == nil {
            if let administrativeArea = administrativeArea, let stateInitialsIndex = self.arrStatesInitials!.index(of: administrativeArea) {
                self.loadProtectionNetworks(state: administrativeArea)
                
                setDefaultState(initials: administrativeArea)
                let indexPath = IndexPath(row: stateInitialsIndex, section: 0)
                self.updateOffsetOfTableStates(indexPath: indexPath)
                self.indexPath = indexPath
            }
        }
    }
    
}

// MARK: - LGPlusButtonsViewDelegate

extension PBMapViewController: LGPlusButtonsViewDelegate {

    func plusButtonsView(_ plusButtonsView: LGPlusButtonsView!, buttonPressedWithTitle title: String!, description: String!, index: UInt) {
        let index = Int(index)
        if index != 0 {
            plusButtonsView.hideButtons(animated: true, completionHandler: nil)
        }
        
        if plusButtonsView.tag == 0 {
            if !self.canSelectOnFloatButton {
                return
            }
            
            let violationIndex = 1
            let internetCrimeIndex = 2
            let accessibilityIndex = 3
            let disk100Index = 4
            let disk180Index = 5

            if index == violationIndex {
                let stepViewController = createComplaintViewController(forType: .violation)
                let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
                navigationController.complaintType = .violation
                self.present(navigationController, animated: true, completion: nil)
                sendAnalyticAction(action: .start, ofType: .violation)
            } else if index == disk100Index {   
                self.presentPhoneViewController(type: .disk100)
            } else if index == disk180Index {
                self.presentPhoneViewController(type: .disk180)
            } else if index == internetCrimeIndex {
                let stepViewController = createComplaintViewController(forType: .internetCrime)
                let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
                navigationController.complaintType = .internetCrime
                self.present(navigationController, animated: true, completion: nil)
                sendAnalyticAction(action: .start, ofType: .internetCrime)
            } else if index == accessibilityIndex {
                let stepViewController = createComplaintViewController(forType: .noAccessibility)
                let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
                navigationController.complaintType = .noAccessibility
                self.present(navigationController, animated: true, completion: nil)
                sendAnalyticAction(action: .start, ofType: .noAccessibility)
            }
        } else if plusButtonsView.tag == 1 {
            let denounceIndex = 1
            let cancelIndex = 2
            
            if index == denounceIndex {
                let stepViewController = createComplaintViewController(forType: .noAccessibility)
                stepViewController.placemarkNoAccessibility = self.placemarkNoAccessibility
                let navigationController = PBComplaintNavigationController(rootViewController: stepViewController)
                navigationController.complaintType = .noAccessibility
                self.present(navigationController, animated: true) {
                    self.setupForNormalAccess()
                    self.showNearestProtectionNetworks()
                }
            } else if index == cancelIndex {
                let messageText = L10n.messageCancelReport
                let alertController = UIAlertController(title: nil, message: messageText, preferredStyle: .alert)
                let giveUpText = L10n.optionGiveUp
                let giveUpAction = UIAlertAction(title: giveUpText, style: .destructive) { _ in
                    self.setupForNormalAccess()
                    self.showNearestProtectionNetworks()
                    plusButtonsView.hide(animated: true) {}
                    plusButtonsView.removeFromSuperview()
                    plusButtonsView.isUserInteractionEnabled = false
                    sendAnalyticAction(action: .giveUp, ofType: .noAccessibility)
                }
                let continueText = L10n.optionContinue
                let continueAction = UIAlertAction(title: continueText, style: .default, handler: nil)
                alertController.addAction(giveUpAction)
                alertController.addAction(continueAction)
                alertController.preferredAction = continueAction
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func plusButtonsViewWillShowButtons(_ plusButtonsView: LGPlusButtonsView!) {
        if plusButtonsView.tag == 0 {
            plusButtonsView.setButtonAt(0, image: UIImage(named: "imgFloat2")!, for: .normal, for: .all)
        }
    }

    func plusButtonsViewWillHideButtons(_ plusButtonsView: LGPlusButtonsView!) {
        if plusButtonsView.tag == 0 {
            plusButtonsView.setButtonAt(0, image: UIImage(named: "imgFloat")!, for: .normal, for: .all)
        }
    }

    func plusButtonsViewDidShowButtons(_ plusButtonsView: LGPlusButtonsView!) {
        if plusButtonsView.tag == 0 {
            self.canSelectOnFloatButton = true
        }
    }

    func plusButtonsViewDidHideButtons(_ plusButtonsView: LGPlusButtonsView!) {
        if plusButtonsView.tag == 0 {
            self.canSelectOnFloatButton = false
        }
    }
}
