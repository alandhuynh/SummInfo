//
//  APIRequest.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/30/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

class APIRequest {
    
    fileprivate var baseURL: String
    fileprivate var path: String?
    fileprivate var parameters: [String:String]?
    
    // The requestURL property is the complete URL for the request, i.e.
    // the baseURL + the path + the parameters
    var requestURL: String {
        var url = baseURL
        
        if path != nil {
            url += path!
        }
        
        if let paramDict = parameters, !paramDict.isEmpty {
            url += "?"
            for (paramName, paramValue) in paramDict {
                url += "\(paramName)=\(paramValue)&"
            }
        }
        
        return url
    }
    
    // Only the baseURL is mandatory for an APIRequest since the path and
    // parameters are an extension of the baseURL
    init(baseURL: String, path: String?, parameters: [String:String]?) {
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
    }
}
