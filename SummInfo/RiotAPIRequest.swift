//
//  RiotAPIRequest.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/31/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

class RiotAPIRequest: APIRequest {
    
    init(path: String?, parameters: [String:String]?) {
        // Currently, this is hard coded to always use the North American region
        //
        // In the future, we should be able to accept an initialization parameter 
        // specifying the region we'd like to request information from
        let baseURL = APIServers[RegionNames.NorthAmerica]!
        
        // defaultParameters will always include the API key specified in the
        // Config plist as a parameter since all requests to the Riot API require
        // an API key
        var defaultParameters = parameters ?? [String:String]()
        if let apiKey = RiotAPIRequest.getApiKey() {
            defaultParameters["api_key"] = apiKey;
        }
        
        super.init(baseURL: baseURL, path: path, parameters: defaultParameters)
    }
    
    fileprivate static func getApiKey() -> String? {
        if let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
                let config = NSDictionary.init(contentsOfFile: configPath) {
            let riotAPISettings = config["RiotAPI"] as? NSDictionary
            let apiKey = riotAPISettings?["APIKey"] as? String
            return apiKey
        }
        return nil
    }
    
    // Most Riot API endpoint paths begin with this standard base, which again is
    // hard coded to North America
    static func getStandardPathBase() -> String {
        return "/api/lol/na"
    }
    
}


