//
//  SectionsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/25/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class SectionsViewController: UITableViewController {

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
