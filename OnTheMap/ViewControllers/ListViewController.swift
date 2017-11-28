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
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .reload, object: nil)
        dataProvider.delegate = self
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        reload()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    @objc func reload() {
        performUIUpdatesOnMain {
            self.dataProvider.locations = self.appDelegate.locations
            self.tableView.reloadData()
        }
    }
    
    // MARK: - LocationSelectionDelegate
    
    func didSelectLocation(location: Location) {
        guard let mediaURL = location.mediaURL else {
            showInfo(withMessage: "Invalid link.")
            return
        }
        openWithSafari(mediaURL)
    }

}
