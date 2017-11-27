//
//  UserSession.swift
//  OnTheMap
//
//  Created by Antonio on 11/27/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
