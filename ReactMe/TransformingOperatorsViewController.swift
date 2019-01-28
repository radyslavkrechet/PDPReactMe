//
//  TransformingOperatorsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class TransformingOperatorsViewController: UITableViewController {

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: indexPath.row == 0 ? "ToMapOperator" : "ToFlatMapOperator", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
