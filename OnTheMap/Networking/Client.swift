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
    
    // MARK: Shared Instance
    
    class func shared() -> Client {
        struct Singleton {
            static var shared = Client()
        }
        return Singleton.shared
    }
    
    func authenticateWith(userEmail: String, andPassword: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(andPassword)\"}}"
        _ = taskForPOSTMethod(Constants.UdacityMethods.Authentication, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForAuth(false, "Login Failed.")
            } else {
                if let account = results?[Constants.UdacityJSONResponseKeys.Account] as? [String: AnyObject] {
                    guard let registered = account[Constants.UdacityJSONResponseKeys.Registered] as? Bool, registered == true else {
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
                    self.sessionID = sessionID
                    completionHandlerForAuth(true, nil)
                } else {
                    self.sessionID = nil
                    completionHandlerForAuth(false, "Login Failed, user not registered.")
                }
            }
        })
    }
    
    // MARK: GET
    
    func taskForGETMethod(
        _ method: String,
        parameters: [String:AnyObject],
        completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method, apiType: .parse))
        request.addValue(Constants.ParseParametersValues.APIKey, forHTTPHeaderField: Constants.ParseParameterKeys.APIKey)
        request.addValue(Constants.ParseParametersValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(
        _ method                 : String,
        parameters               : [String:AnyObject],
        jsonBody                 : String,
        completionHandlerForPOST : @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    enum APIType {
        case udacity
        case parse
    }
    
    // create a URL from parameters
    private func buildURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, apiType: APIType = .udacity) -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == .udacity ? Constants.Udacity.APIScheme : Constants.Parse.APIScheme
        components.host = apiType == .udacity ? Constants.Udacity.APIHost : Constants.Parse.APIHost
        components.path = (apiType == .udacity ? Constants.Udacity.APIPath : Constants.Parse.APIPath) + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}
