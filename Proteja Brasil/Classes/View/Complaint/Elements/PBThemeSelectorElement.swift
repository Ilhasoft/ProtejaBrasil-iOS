//
//  PBThemeSelectorElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 05/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class PBThemeSelectorElement: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    private var themes = [PBThemeModel]()
    private var selectedIndex: Int = 0
    private var isOpen = false
    var apiKey: String?
    var isRequired: Bool! {
        return true
    }
    var didSelectedClosure: ((PBThemeModel) -> Void)?
    
    class func loadView() -> PBThemeSelectorElement {
        return UINib(nibName: "PBThemeSelectorElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBThemeSelectorElement
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableView()
        self.loadThemes()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        self.tableView.roundCorners(radius: 18, color: kBlueColor)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 36
        self.tableView.register(PBComplaintThemeSelectorTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: My functions
    
    private func loadThemes() {
        let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        hud.color = UIColor.clear
        hud.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        PBAPI.theme.getThemes { themes, error in
            hud.hide(animated: true)
            guard let themes = themes else {
                self.apiKey = nil
                let title = L10n.error
                let message = L10n.errorFromServer
                let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: L10n.ok)
                alert.show()
                return
            }
            if themes.count > 0 {
                self.themes.append(contentsOf: themes)
                self.tableView.reloadData()
                self.didSelectedClosure?(themes[0])
            }
        }
    }
    
    @IBAction func btArrowTouched() {
        if self.themes.count > 0 {
            UIView.animate(withDuration: 0.2) {
                let indexPath = IndexPath(row: self.selectedIndex, section: 0)
                self.layoutTableView(indexPath: indexPath)
            }
        }
    }
    
    private func layoutTableView(indexPath: IndexPath) {
        if self.isOpen {
            let cellRect = tableView.rectForRow(at: indexPath)
            self.constraintHeight.constant = cellRect.size.height
            self.tableView.contentOffset = cellRect.origin
            self.tableView.borderColor(color: kBlueColor)
            if self.selectedIndex != indexPath.row {
                self.selectedIndex = indexPath.row
                let theme = self.themes[indexPath.row]
                self.didSelectedClosure?(theme)
            }
            self.isOpen = false
        } else {
            self.constraintHeight.constant = tableView.contentSize.height
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            self.isOpen = true
        }
        self.window?.layoutIfNeeded()
    }
    
    // MARK: Public functions
    
    func retractOptions() {
        if self.isOpen {
            self.btArrowTouched()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension PBThemeSelectorElement: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBComplaintThemeSelectorTableViewCell
        let theme = self.themes[indexPath.row]
        cell.updateFromTheme(theme: theme)
        return cell
    }    
}

// MARK: - UITableViewDelegate

extension PBThemeSelectorElement: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            self.layoutTableView(indexPath: indexPath)
        }
    }
}

// MARK: - PBComplaintElementProtocol

extension PBThemeSelectorElement: PBComplaintElementProtocol {
    
    func getData() -> (key: String, value: Any)? {
        if let apiKey = self.apiKey {
            let theme = self.themes[self.selectedIndex]
            return (key: apiKey, value: theme.sondhaId)
        }
        return nil
    }
    
    func isValid() -> Bool {
        if self.isOpen {
            self.tableView.borderColor(color: kRedColor)
            return false
        }
        if self.apiKey == nil {
            self.tableView.borderColor(color: kRedColor)
            return false
        }
        self.tableView.borderColor(color: kBlueColor)
        return true
    }
    
}
