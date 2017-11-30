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

class MapPinLocationView: BaseMapViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonLogin: UIButton!
    
    // MARK: - Variables
    
    var studentLocation: StudentLocation?
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        buttonLogin.roundCorners()
        
        if let studentLocation = studentLocation {
            let location = Location(
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            showLocations(location: location)
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
    
    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            self.showInfo(withTitle: "Success", withMessage: "Student Location updated!", action: {
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: .reload, object: nil)
            })
        }
    }
 
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let span = MKCoordinateSpanMake(CLLocationDegrees(5), CLLocationDegrees(5))
        let region = MKCoordinateRegion(center: mapView.annotations.first!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}