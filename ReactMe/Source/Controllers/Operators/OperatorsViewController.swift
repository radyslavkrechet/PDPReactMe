//
//  OperatorsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class OperatorsViewController: UITableViewController {
    enum OperatorsCategory: Int {
        case filtring, transforming, combining
    }

    // MARK: - Actions
    
    @IBAction func sectionsButtonPressed(_ sender: UIBarButtonItem) {
        navigationController!.dismiss(animated: true)
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var identifier = ""
        let category = OperatorsCategory(rawValue: indexPath.row)!
        switch category {
        case .filtring:
            identifier = "ToFiltringOperators"
        case .transforming:
            identifier = "ToTransformingOperators"
        case .combining:
            identifier = "ToCombiningOperators"
        }
        
        performSegue(withIdentifier: identifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
