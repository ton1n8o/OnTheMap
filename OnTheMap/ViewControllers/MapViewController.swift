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

class MapViewController: BaseMapViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapView")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
        loadUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.mapView.alpha = 0.5
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
            self.mapView.alpha = 1
            self.showLocations(locations: self.appDelegate.locations)
        }
    }
    
    private func showLocations(locations: [Location]) {
        mapView.removeAnnotations(mapView.annotations)
        for location in locations {
            if let coordinate = extractCoordinate(location: location) {
                let annotation = MKPointAnnotation()
                annotation.title = location.locationLabel
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
    
    private func loadUserInfo() {
        _ = Client.shared().studentInfo(completionHandler: { (studentInfo, error) in
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                return
            }
            Client.shared().userName = studentInfo?.user.name ?? ""
        })
    }
    
}
