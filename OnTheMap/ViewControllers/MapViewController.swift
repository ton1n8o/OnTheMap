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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapView")
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .reload, object: nil)
        mapView.delegate = self
        loadUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    @objc func reload() {
        performUIUpdatesOnMain {
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
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else  {
                self.showInfo(withMessage: "No link defined.")
                return
            }
            guard let link = subtitle else {
                self.showInfo(withMessage: "No link defined.")
                return
            }
            openWithSafari(link)
        }
    }
    
}
