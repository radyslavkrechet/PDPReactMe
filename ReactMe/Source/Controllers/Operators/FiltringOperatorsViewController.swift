//
//  FiltringOperatorsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

enum FiltringOperator: Int {
    case ignoreElements, elementAt, filter, skip, skipWhile, skipUntil, take, takeWhile, takeUntil
}

class FiltringOperatorsViewController: UITableViewController {

    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! FiltringOperatorViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let value = indexPath.section + indexPath.row + indexPath.section * 2
        viewController.filtringOperator = FiltringOperator(rawValue: value)!
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        performSegue(withIdentifier: "ToFiltringOperator", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
