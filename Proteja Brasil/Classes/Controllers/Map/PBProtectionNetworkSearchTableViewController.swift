//
//  PBProtectionNetworkSearchTableViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 25/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit

protocol PBProtectionNetworkSearchTableViewControllerDelegate {
    func showProtectionNetwork(protectionNetwork: PBProtectionNetworkModel)
}

class PBProtectionNetworkSearchTableViewController: UITableViewController {
    
    var arrSearchResults: [PBProtectionNetworkModel]!
    var delegate: PBProtectionNetworkSearchTableViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSearchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        let protectionNetwork = self.arrSearchResults[indexPath.row]
        cell?.textLabel?.text = protectionNetwork.name
        cell?.textLabel?.numberOfLines = 0

        return cell!
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let protectionNetwork = self.arrSearchResults[indexPath.row]
        self.delegate?.showProtectionNetwork(protectionNetwork: protectionNetwork)
        self.dismiss(animated: true, completion: nil)
    }
}
