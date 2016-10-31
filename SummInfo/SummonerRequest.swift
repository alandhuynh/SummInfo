//
//  SummonerRequest.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/31/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

class SummonerRequest: RiotAPIRequest {
    
    // A SummonerRequest can be made for multiple summoners at once, so the initializer
    // accepts zero or more name Strings
    init(summonerNames: String...) {
        var path = RiotAPIRequest.getStandardPathBase() + "/\(APIVersions.SummonerAPI)" +
                    "/summoner/by-name/"
        
        // The summoner endpoint expects names in "standardized format", meaning lowercase
        // and without spaces
        // Additionally, summoner names should be comma separated
        path += summonerNames.map {
                $0.lowercased().replacingOccurrences(of: " ", with: "")
            }.joined(separator: ",")
        
        super.init(path: path, parameters: nil)
    }
    
}
