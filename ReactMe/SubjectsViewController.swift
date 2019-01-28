//
//  SubjectsViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/25/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

enum Subject: Int {
    case publish, behavior, replay, variable
}

class SubjectsViewController: UITableViewController {
    
    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! SubjectViewController
        let indexPath = tableView.indexPathForSelectedRow!
        viewController.subject = Subject(rawValue: indexPath.row)!
    }
    
    // MARK: - Actions
    
    @IBAction func sectionsButtonPressed(_ sender: UIBarButtonItem) {
        navigationController!.dismiss(animated: true)
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToSubject", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

