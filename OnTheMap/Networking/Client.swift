//
//  Client.swift
//  OnTheMap
//
//  Created by Antonio on 11/10/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class Client: NSObject {
    
    // MARK: - Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
}
