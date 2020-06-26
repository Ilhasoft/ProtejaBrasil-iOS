//
//  PBComplaintTypeTableViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class PBViolationTypeListViewController: UIViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var theme: PBThemeModel!
    var violationTypeList = [PBViolationTypeModel]()
    
    convenience init(theme: PBThemeModel) {
        self.init(nibName: "PBViolationTypeListViewController", bundle: nil)
        self.theme = theme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarColor(color: UIColor.clear, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.trackViewControllerWithName(name: "Violation types list")
    }
    
    // MARK: Setup
    
    func setupNavigationBar() {
        self.navigationItem.title = self.theme.title
        if let icon = self.theme.icon, let url = URL(string: icon) {
            self.imgIcon.sd_setImage(with: url)
        }
        if let color = self.theme.color {
            self.viewTop.backgroundColor = UIColor(rgba: color)
        }
        self.lbSubtitle.text = self.theme.desc
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        self.tableView.register(PBViolationTypeTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: My functions
    
    private func loadData() {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        PBAPI.violationType.getViolationTypeByTheme(theme: self.theme) { (violationTypes, error) -> Void in
            progressHUD.hide(animated: true)
            guard let violationTypes = violationTypes else {
                let messageText = L10n.errorFromServer
                showErrorAlert(message: messageText)
                print(error)
                return
            }
            self.violationTypeList.append(contentsOf: violationTypes)
            self.tableView.reloadData()
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension PBViolationTypeListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.violationTypeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBViolationTypeTableViewCell
        let violationType = self.violationTypeList[indexPath.row]
        cell.setupCellWithData(violationType: violationType)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PBViolationTypeListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let violationType = self.violationTypeList[indexPath.row]
        var detailViewController: UIViewController!
        let isInternetCrime = violationType.categories.filter { $0.category == "InternetCrime" }.count == 1
        if isInternetCrime {
            detailViewController = PBInternetCrimeDetailViewController(violationType: violationType)
        } else {
            detailViewController = PBViolationTypeDetailViewController(violationType: violationType)
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
