//
//  PBOptionSelectorComplaintElement.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 09/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit

class PBOptionSelectorComplaintElement: UIView {
    
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var apiKey: String?
    var isRequired: Bool! = false
    var options: [PBKeyValue]! {
        didSet {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            self.selectedIndex = 0
            self.tableView.reloadData()
        }
    }
    var didSelectedOptionClosure: ((PBKeyValue) -> Void)?
    
    private var isOpen = false
    private var selectedIndex: Int = 0
    
    class func loadView() -> PBOptionSelectorComplaintElement {
        return UINib(nibName: "PBOptionSelectorComplaintElement", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PBOptionSelectorComplaintElement
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRoundedView()
        self.setupTableView()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.setNeedsLayout()
    }
    
    private func setupRoundedView() {
        self.viewRounded.roundCorners(radius: 18, color: kBlueColor)
    }
    
    // MARK: My functions
    
    private func updateCell(cell: UITableViewCell, forKey key: String) {
        cell.selectionStyle = .none
        cell.textLabel?.preferredMaxLayoutWidth = screenSize.width-80
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = kGreyColor
        cell.textLabel?.text = key
    }
    
    @IBAction func btArrowTouched() {
        UIView.animate(withDuration: 0.2) {
            self.layoutTableView(updateIndex: true, indexPath: IndexPath(row: self.selectedIndex, section: 0))
        }
    }
    
    private func layoutTableView(updateIndex update: Bool, indexPath: IndexPath) {
        if self.isOpen {
            let cellRect = tableView.rectForRow(at: indexPath)
            self.constraintHeight.constant = cellRect.size.height
            self.tableView.contentOffset = cellRect.origin
            if update {
                self.isOpen = false
                if self.selectedIndex != indexPath.row {
                    self.selectedIndex = indexPath.row
                    let keyValue = self.options[indexPath.row]
                    self.didSelectedOptionClosure?(keyValue)
                }
            }
        } else {
            self.constraintHeight.constant = tableView.contentSize.height
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            if update {
                self.isOpen = true
            }
        }
        self.viewRounded.borderColor(color: kBlueColor)
        self.superview?.superview?.superview?.superview?.layoutIfNeeded()
    }
    
    // MARK: Public functions
    
    func selectRow(row: Int) {
        self.selectedIndex = row
        let indexPath = IndexPath(row: row, section: 0)
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        let keyValue = self.options[row]
        self.didSelectedOptionClosure?(keyValue)
    }
    
    func selectOptionForKey(key: String) {
        let index = self.options.index { $0.key == key }
        if let index = index {
            self.selectRow(row: index)
        }
    }
    
    func selectOptionForValue(value: Any) {
        let index = self.options.index {
            if let optionValue = $0.value as? String, let value = value as? String {
                return optionValue == value
            }
            return false
        }
        if let index = index {
            self.selectRow(row: index)
        }
    }
    
    func retractOptions() {
        if self.isOpen {
            self.btArrowTouched()
        }
    }
    
    func showActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
}

// MARK: - PBComplaintElementProtocol

extension PBOptionSelectorComplaintElement: PBComplaintElementProtocol {
    
    func getData() -> (key: String, value: Any)? {
        if !self.isOpen {
            if let apiKey = self.apiKey, let value = self.options[self.selectedIndex].value {
                return (key: apiKey, value: value)
            }
        }
        return nil
    }
    
    func isValid() -> Bool {
        if self.isHidden {
            return true
        }
        if self.isOpen {
            self.viewRounded.borderColor(color: kRedColor)
            return false
        }
        if self.isRequired == true {
            if let _ = self.options[self.selectedIndex].value {
                self.viewRounded.borderColor(color: kBlueColor)
                return true
            } else {
                self.viewRounded.borderColor(color: kRedColor)
                return false
            }
        }
        self.viewRounded.borderColor(color: kBlueColor)
        return true
    }
    
}

// MAKR: - UITableViewDataSource

extension PBOptionSelectorComplaintElement: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let key = self.options[indexPath.row].key
        self.updateCell(cell: cell!, forKey: key)
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension PBOptionSelectorComplaintElement: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutTableView(updateIndex: false, indexPath: indexPath)
        }) { _ in
            self.layoutTableView(updateIndex: true, indexPath: indexPath)
        }
    }
}
