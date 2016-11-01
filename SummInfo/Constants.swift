//
//  Constants.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/31/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

// NOTE: This does not include all supported regions yet
struct RegionNames {
    static let NorthAmerica = "NA"
    static let EuropeWest = "EUW"
    static let Korea = "KR"
}

// Data Dragon is the name of Riot's service for images
let DataDragon = "Data Dragon"

let APIServers = [ RegionNames.NorthAmerica : "https://na.api.pvp.net",
                   RegionNames.EuropeWest : "https://euw.api.pvp.net",
                   RegionNames.Korea : "https://kr.api.pvp.net",
                   DataDragon : "http://ddragon.leagueoflegends.com/cdn"]

struct APIVersions {
    static let SummonerAPI = "v1.4"
    static let LeagueAPI = "v2.5"
    static let DataDragon = "6.21.1"
}
