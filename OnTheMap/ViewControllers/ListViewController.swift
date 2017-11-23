//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataProvider!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.locations = appDelegate.locations
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.reloadData()
    }

}
