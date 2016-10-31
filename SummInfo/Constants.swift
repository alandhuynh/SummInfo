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

let APIServers = [ RegionNames.NorthAmerica : "na.api.pvp.net",
                   RegionNames.EuropeWest : "euw.api.pvp.net",
                   RegionNames.Korea : "kr.api.pvp.net" ]