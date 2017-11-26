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
    
    func studentInfo(completionHandler: @escaping (_ result: StudentInfo?, _ error: NSError?) -> Void) {
        let url = Constants.UdacityMethods.Users + "/\(userKey)"
        _ = taskForGETMethod(url, parameters: [:], completionHandlerForGET: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                let response = self.parseStudentInfo(data: data)
                if let info = response.0 {
                    completionHandler(info, nil)
                } else {
                    completionHandler(nil, response.1)
                }
            }
        })
    }
    
    /// Fetches the Location for the user logged in.
    ///
    /// - Parameter completionHandler: returns a student Location in case it was saved previously.
    func studentLocation(completionHandler: @escaping (_ result: StudentsLocation?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Where: "{\"uniqueKey\":\"\(userKey)\"}" as AnyObject]
        _ = taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: params, apiType: .parse) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                completionHandler(self.parseStudentsLocation(data: data), nil)
            }
        }
    }
    
    func postStudentLocation(location: StudentLocation, completionHandler: @escaping (_ result: StudentsLocation?, _ error: NSError?) -> Void) {
        
//        let paramHeaders = [
//            Constants.ParseParameterKeys.APIKey       : Constants.ParseParametersValues.APIKey,
//            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValues.ApplicationID,
//            ] as [String: AnyObject]
        
//        let jsonBody = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"
        
//        _ = taskForPOSTMethod(Constants.ParseMethods.StudentLocation, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse) { (data, error) in
//            
//        }
    }
    
    func parseStudentsLocation(data: Data?) -> StudentsLocation? {
        var studensLocation: StudentsLocation?
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                studensLocation = try jsonDecoder.decode(StudentsLocation.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
        }
        return studensLocation
    }
    
    func parseStudentInfo(data: Data?) -> (StudentInfo?, NSError?) {
        var response: (studentInfo: StudentInfo?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                response.studentInfo = try jsonDecoder.decode(StudentInfo.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey : error]
            response.error = NSError(domain: "parseStudentInfo", code: 1, userInfo: userInfo)
        }
        return response
    }
}
