//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class BaseViewController: UITabBarController {

    @IBOutlet weak var buttonPostLocation: UIBarButtonItem!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any) {
        
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        buttonPostLocation.isEnabled = false
        Client.shared().studentLocation { (studentLocation, error) in
            if let error = error {
                self.showInfo(withTitle: "Error fetching student location", withMessage: error.localizedDescription)
            }
            if let locations = studentLocation?.locations, !locations.isEmpty {
                let msg = "User \"\(locations.first!.locationLabel)\" has already posted a Student Location. Whould you like to Overwrite it?"
                self.showConfirmationAlert(withMessage: msg, actionTitle: "Overwrite", action: {
                    self.showPostingView()
                })
            } else {
                self.showPostingView()
            }
            self.performUIUpdatesOnMain {
                self.buttonPostLocation.isEnabled = true
            }
        }
    }

    // MARK: - Helpers
    
    private func showPostingView() {
        let postingView = storyboard?.instantiateViewController(withIdentifier: "PostingView") as! PostingView
        navigationController?.pushViewController(postingView, animated: true)
    }

}
