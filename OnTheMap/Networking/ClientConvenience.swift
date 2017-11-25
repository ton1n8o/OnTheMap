//
//  ClientConvenience.swift
//  OnTheMap
//
//  Created by Antonio on 11/25/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation

extension Client {
    
    func authenticateWith(userEmail: String, andPassword: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(andPassword)\"}}"
        _ = taskForPOSTMethod(Constants.UdacityMethods.Authentication, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForAuth(false, error.localizedDescription)
            } else {
                if let account = results?[Constants.UdacityJSONResponseKeys.Account] as? [String: AnyObject] {
                    guard let registered = account[Constants.UdacityJSONResponseKeys.Registered] as? Bool, registered == true else {
                        completionHandlerForAuth(false, "Login Failed, user not registered.")
                        return
                    }
                    guard let userKey = account[Constants.UdacityJSONResponseKeys.UserKey] as? String else {
                        completionHandlerForAuth(false, "Login Failed, user not registered.")
                        return
                    }
                    guard let session = results?[Constants.UdacityJSONResponseKeys.Session] as? [String: AnyObject] else {
                        completionHandlerForAuth(false, "Login Failed, no session to the user credentials provided.")
                        return
                    }
                    guard let sessionID = session[Constants.UdacityJSONResponseKeys.SessionID] as? String else {
                        completionHandlerForAuth(false, "Login Failed, no session ID to the user credentials provided.")
                        return
                    }
                    self.userKey = userKey
                    self.sessionID = sessionID
                    completionHandlerForAuth(true, nil)
                } else {
                    self.sessionID = nil
                    completionHandlerForAuth(false, "Login Failed, user not registered.")
                }
            }
        })
    }
    
    /// Fetches the Location for the user logged in.
    ///
    /// - Parameter completionHandler: returns a student Location in case it was saved previously.
    func studentLocation(completionHandler: @escaping (_ result: StudentsLocation?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Where: "{\"uniqueKey\":\"\(userKey)\"}" as AnyObject]
        _ = taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: params) { (studentLocation, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                completionHandler(studentLocation, nil)
            }
        }
    }
}
