//
//  PBMyProtocolsViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 02/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBMyProtocolsViewController: UITableViewController {
    
    convenience init() {
        self.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    //MARK: Setup
    
    private func setupView() {
        self.view.backgroundColor = UIColor(rgba: "#E6E6E6")
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Minhas denúncias"
    }
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        self.tableView.register(PBAddProtocolTableViewCell.nib, forCellReuseIdentifier: "AddCell")
        self.tableView.register(PBProtocolTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! PBAddProtocolTableViewCell
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBProtocolTableViewCell
        cell.updateFromProtocol()
        return cell
    }
}
