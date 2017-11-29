//
//  MapPinLocationView.swift
//  OnTheMap
//
//  Created by Antonio on 11/29/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinLocationView: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonLogin: UIButton!
    
    // MARK: - Variables
    
    var studentLocation: StudentLocation?
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLogin.roundCorners()
        
        if let studentLocation = studentLocation {
            
        }
        
    }

    // MARK: - Actions
    
    @IBAction func finish(_ sender: Any) {
        
        if let studentLocation = studentLocation {
            if studentLocation.locationID == nil {
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
        
    }
    
    // MARK: - Helpers
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            self.showInfo(withTitle: "Success", withMessage: "Student Location updated!", action: {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .reload, object: nil)
            })
        }
    }
    
}
