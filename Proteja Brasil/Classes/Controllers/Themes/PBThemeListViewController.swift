//
//  PBThemeListViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 29/12/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class PBThemeListViewController: UITableViewController {
    
    private var themes = [PBThemeModel]()
    
    convenience init() {
        self.init(nibName: "PBThemeListViewController", bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.setupRefreshControl()
        self.loadThemes(withHud: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarColor(color: kBlueColor, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "Theme list")
    }
    
    // MARK: My functions
    
    private func loadThemes(withHud hasHud: Bool) {
        var hud: MBProgressHUD?
        if hasHud {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            self.refreshControl?.beginRefreshing()
        }
        PBAPI.theme.getThemes { themes, error in
            hud?.hide(animated: true)
            self.refreshControl?.endRefreshing()
            if error != nil {
                let messageText = L10n.errorFromServer
                showErrorAlert(message: messageText)
                return
            }
            if let themes = themes {
                self.themes.removeAll()
                self.themes.append(contentsOf: themes)
                self.tableView.reloadData()
                return
            }
            let messageText = L10n.errorUnexpected
            showErrorAlert(message: messageText)
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.loadThemes(withHud: false)
    }
    
    // MARK: Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = L10n.actionViolationTypes
    }
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 82
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(PBThemeListTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }
    
    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBThemeListTableViewCell
        let theme = self.themes[indexPath.row]
        cell.updateFromTheme(theme: theme)

        return cell
    }
    
    // MARK: Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.row]
        let violationTypeListViewController = PBViolationTypeListViewController(theme: theme)
        self.navigationController?.pushViewController(violationTypeListViewController, animated: true)
    }
}
