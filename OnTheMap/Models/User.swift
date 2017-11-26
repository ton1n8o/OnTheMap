//
//  User.swift
//  OnTheMap
//
//  Created by Antonio on 11/26/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name = "nickname"
    }
}
