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
    @IBOutlet weak var buttonPostReload: UIBarButtonItem!
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentsLocation()
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any) {
        loadStudentsLocation()
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        enableControllers(false)
        Client.shared().studentLocation { (studentLocation, error) in
            if let error = error {
                self.showInfo(withTitle: "Error fetching student location", withMessage: error.localizedDescription)
            }
            if let locations = studentLocation?.locations, !locations.isEmpty {
                let location = locations.first!
                let msg = "User \"\(location.locationLabel)\" has already posted a Student Location. Whould you like to Overwrite it?"
                self.showConfirmationAlert(withMessage: msg, actionTitle: "Overwrite", action: {
                    self.showPostingView(studentLocationID: location.objectId)
                })
            } else {
                self.showPostingView()
            }
            self.enableControllers(true)
        }
    }

    // MARK: - Helpers
    
    private func loadStudentsLocation() {
        _ = Client.shared().taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: [:], apiType: .parse) { (data, error) in
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                return
            }
            if let studentsLocation = Client.shared().parseStudentsLocation(data: data) {
                let locations =  studentsLocation.locations
                print("Locations: \(locations.count)")
                self.performUIUpdatesOnMain {
                    self.appDelegate.locations = locations
                }
                NotificationCenter.default.post(name: .reload, object: nil)
            } else {
                self.showInfo(withTitle: "Error", withMessage: "Could not parse the data.")
            }
        }
    }
    
    private func enableControllers(_ enable: Bool) {
        performUIUpdatesOnMain {
            self.buttonPostLocation.isEnabled = enable
            self.buttonPostReload.isEnabled = enable
            self.buttonLogout.isEnabled = enable
        }
    }
    
    private func showPostingView(studentLocationID: String? = nil) {
        let postingView = storyboard?.instantiateViewController(withIdentifier: "PostingView") as! PostingView
        postingView.studentLocationID = studentLocationID
        navigationController?.pushViewController(postingView, animated: true)
    }

}
