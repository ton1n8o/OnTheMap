//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/19/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Client.shared().taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: [:]) { (studentsLocation, error) in
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                return
            }
            guard let locations = studentsLocation?.locations else {
                return
            }
            print("Locations: \(locations.count)")
            self.appDelegate.locations = locations
            self.showLocations(locations: locations)
        }
    }
    
    // MARK: - Helpers
    
    private func showLocations(locations: [Location]) {
        for location in locations {
            if let coordinate = extractCoordinate(location: location) {
                let annotation = MKPointAnnotation()
                annotation.title = location.firstName ?? location.lastName
                annotation.subtitle = location.mediaURL ?? ""
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }

}
