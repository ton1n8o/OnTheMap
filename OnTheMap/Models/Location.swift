//
//  Location.swift
//  OnTheMap
//
//  Created by Antonio on 11/19/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = (firstName ?? lastName)
        if name == nil {
           name = "No name provided"
        }
        return name!
    }
    
}
