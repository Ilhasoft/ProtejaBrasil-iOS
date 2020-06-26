//
//  PBThemeSelectorViewController.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 02/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBThemeSelectorViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lbHeader: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var themes: [PBThemeModel]!
    private var idsSelected: Set<Int>!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(themes: [PBThemeModel], idsSelected: Set<Int>) {
        self.init(nibName: "PBThemeSelectorViewController", bundle: nil)
        self.themes = themes
        self.idsSelected = Set<Int>(idsSelected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHeaderView()
        self.setupTableView()
        self.tableView.reloadData()
    }
    
    //MARK: Setup
    
    private func setupHeaderView() {
        self.viewHeader.layer.cornerRadius = 3
        self.lbHeader.text = L10n.actionViolationTypes
    }
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        self.tableView.estimatedRowHeight = 41
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(PBThemeSelectorTableViewCell.nib, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: My functions
    
    func themesIdSelected() -> Set<Int> {
        return self.idsSelected
    }
    
}

//MARK: - UITableViewDataSource

extension PBThemeSelectorViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBThemeSelectorTableViewCell
        let theme = self.themes[indexPath.row]
        let selected = self.idsSelected.contains(theme.id)
        let isLast = (indexPath.row == self.themes.count-1)
        cell.delegate = self
        cell.updateFromTheme(theme: theme, width: self.view.bounds.width, selected: selected, isLast: isLast)
        return cell
    }
}

extension PBThemeSelectorViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PBThemeSelectorTableViewCell
        cell.cellSelected()
    }
}

//MARK: - PBThemeSelectorTableViewCellDelegate

extension PBThemeSelectorViewController: PBThemeSelectorTableViewCellDelegate {
    
    func themeSelected(theme: PBThemeModel) {
        self.idsSelected.insert(theme.id)
    }
    
    func themeDeselected(theme: PBThemeModel) {
        self.idsSelected.remove(theme.id)
    }
    
}
