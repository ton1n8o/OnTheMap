//
//  Constants.swift
//  OnTheMap
//
//  Created by Antonio on 11/10/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
    }
    
    struct HTTPHeaderField {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct HTTPHeaderFieldValue {
        static let json = "application/json"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Authentication
        static let Authentication = "/session"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // MARK: Account
        static let Account = "account"
        static let Registered = "registered"
        static let Session = "session"
        static let SessionID = "id"
    }
}
