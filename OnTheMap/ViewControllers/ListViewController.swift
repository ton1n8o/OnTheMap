//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, LocationSelectionDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataProvider!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.delegate = self
        dataProvider.locations = appDelegate.locations
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.reloadData()
    }
    
    // MARK: - LocationSelectionDelegate
    
    func didSelectLocation(location: Location) {
        guard let mediaURL = location.mediaURL else {
            showInfo(withMessage: "Invalid link.")
            return
        }
        guard let url = URL(string: mediaURL) else {
            showInfo(withMessage: "Invalid link.")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}
