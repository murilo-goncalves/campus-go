//
//  ResultsTableViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 05/10/21.
//

import UIKit

protocol ResultsTableViewDelegate: AnyObject {
    
    func setup(resultsTableViewController: ResultsTableViewController?)
    
}

class ResultsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ResultsTableViewDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegate?.setup(resultsTableViewController: self)
        
    }
    
}

extension ResultsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
}
