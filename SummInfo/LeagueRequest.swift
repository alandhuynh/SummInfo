//
//  LeagueRequest.swift
//  SummInfo
//
//  Created by Alan Huynh on 11/1/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

class LeagueRequest: RiotAPIRequest {
    
    init(summonerIds: String...) {
        // The summoner IDs should be comma separated
        let summonerIdString = summonerIds.joined(separator: ",")
        let path = RiotAPIRequest.getStandardPathBase() + "/\(APIVersions.LeagueAPI)/" +
        "league/by-summoner/\(summonerIdString)/entry"
        
        super.init(path: path, parameters: nil)
    }
}
