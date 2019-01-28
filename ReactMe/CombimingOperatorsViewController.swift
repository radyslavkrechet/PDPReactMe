//
//  ComnimimgOperatorsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/28/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

enum CombimingOperator: Int {
    case concat, merge, combineLatest, zip, amb, switchLatest
}

class CombimingOperatorsViewController: UITableViewController {

    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! CombimingOperatorViewController
        let indexPath = tableView.indexPathForSelectedRow!
        viewController.combimingOperator = CombimingOperator(rawValue: indexPath.row)!
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToCombiningOperator", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
