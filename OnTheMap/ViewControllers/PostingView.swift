//
//  PostingView.swift
//  OnTheMap
//
//  Created by Antonio on 11/25/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit
import CoreLocation

class PostingView: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldLink: UITextField!
    @IBOutlet weak var buttonFindLocation: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    var studentLocationID: String? // based on this property, let's decide whether we're going to perform a POST or a PUT operation.
    lazy var geocoder = CLGeocoder()
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFindLocation.roundCorners()
        setUpNavBar()
    }
    
    // MARK: - Actions
    
    @IBAction func findLocation(_ sender: Any) {
        textFieldLocation.text = "Uberlandia MG"
        textFieldLink.text = "http://www.terra.com.br"
        
        let location = textFieldLocation.text!
        let link = textFieldLink.text!
        
        if location.isEmpty || link.isEmpty {
            showInfo(withMessage: "All fields are required.")
            return
        }
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showInfo(withMessage: "Please provide a valid link.")
            return
        }
        geocode(location: location)
    }
    
    // MARK: - Helpers
    
    private func geocode(location: String) {
        enableControllers(false)
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(location) { (placemarkers, error) in
            
            self.enableControllers(true)
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: "Unable to Forward Geocode Address (\(error))")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    print("\(coordinate.latitude), \(coordinate.longitude)")
                    self.syncStudentLocation(location.coordinate)
                } else {
                    self.showInfo(withMessage: "No Matching Location Found")
                }
            }
        }
    }
    
    private func syncStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        
        let nameComponents = Client.shared().userName.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.last ?? ""
        
        let studentLocation = StudentLocation(
            locationID: studentLocationID,
            uniqueKey: Client.shared().userKey,
            firstName: firstName,
            lastName: lastName,
            mapString: textFieldLocation.text!,
            mediaURL: textFieldLink.text!,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        if studentLocationID == nil {
            // POST
            Client.shared().postStudentLocation(location: studentLocation, completionHandler: { (success, error) in
                self.handleSyncLocationResponse(error: error)
            })
        } else {
            // PUT
            Client.shared().updateStudentLocation(location: studentLocation, completionHandler: { (success, error) in
                self.handleSyncLocationResponse(error: error)
            })
        }
    }
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            self.showInfo(withTitle: "Success", withMessage: "Student Location updated!")
        }
        self.enableControllers(true)
    }
    
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: textFieldLocation, textFieldLink, buttonFindLocation, enable: enable)
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationItem.title = "Add Location"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "CANCEL"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

}
