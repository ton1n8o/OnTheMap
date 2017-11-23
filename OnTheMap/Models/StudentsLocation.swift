//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

struct StudentsLocation: Codable {
    
    let locations: [Location]
    
    enum CodingKeys: String, CodingKey {
        case locations = "results"
    }
}
