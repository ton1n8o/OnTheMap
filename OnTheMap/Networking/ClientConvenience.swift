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
        _ = taskForPOSTMethod(Constants.UdacityMethods.Authentication, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: { (data, error) in
            if let error = error {
                print(error)
                completionHandlerForAuth(false, error.localizedDescription)
            } else {
                
                let userSessionData = self.parseSession(data: data)
                if let sessionData = userSessionData.0 {
                    guard let account = sessionData.account, account.registered == true else {
                        completionHandlerForAuth(false, "Login Failed, user not registered.")
                        return
                    }
                    guard let userSession = sessionData.session else {
                        completionHandlerForAuth(false, "Login Failed, no session to the user credentials provided.")
                        return
                    }
                    self.userKey = account.key
                    self.sessionID = userSession.id
                    completionHandlerForAuth(true, nil)
                } else {
                    completionHandlerForAuth(false, userSessionData.1!.localizedDescription)
                    self.sessionID = nil
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
    
    func postStudentLocation(location: StudentLocation, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey       : Constants.ParseParametersValues.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValues.ApplicationID,
            ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"
        
        _ = taskForPOSTMethod(Constants.ParseMethods.StudentLocation, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                struct Response: Codable {
                    let createdAt: String?
                    let objectId: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let response = response, response.createdAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let msg = "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey : msg]
                    completionHandler(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
                }
                
            }
        }
    }
    
    func updateStudentLocation(location: StudentLocation, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey       : Constants.ParseParametersValues.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValues.ApplicationID,
            ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"
        
        let url = Constants.ParseMethods.StudentLocation + "/" + (location.locationID ?? "")
        
        _ = taskForPUTMethod(url, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse, completionHandlerForPUT: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                struct Response: Codable {
                    let updatedAt: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let response = response, response.updatedAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let msg = "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey : msg]
                    completionHandler(false, NSError(domain: "updateStudentLocation", code: 1, userInfo: userInfo))
                }
                
            }
        })
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
    
    func parseSession(data: Data?) -> (UserSession?, NSError?) {
        var studensLocation: (userSession: UserSession?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                studensLocation.userSession = try jsonDecoder.decode(UserSession.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey : error]
            studensLocation.error = NSError(domain: "parseSession", code: 1, userInfo: userInfo)
        }
        return studensLocation
    }
}
