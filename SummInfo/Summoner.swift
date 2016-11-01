//
//  Summoner.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/31/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SummonerJSONKeys {
    static let Name = "name"
    static let Id = "id"
    static let IconId = "profileIconId"
    static let Level = "summonerLevel"
}

struct SummonerInfo {
    var name: String?
    var id: String?
    var iconId: String?
    var level: String?
    
    init(infoJSON: JSON) {
        name = infoJSON[SummonerJSONKeys.Name].stringValue
        id = infoJSON[SummonerJSONKeys.Id].stringValue
        iconId = infoJSON[SummonerJSONKeys.IconId].stringValue
        level = infoJSON[SummonerJSONKeys.Level].stringValue
    }
}

class Summoner {
    fileprivate var stdSummonerName: String
    fileprivate var summonerInfo: SummonerInfo?
    
    init(summonerName: String) {
        // We should standardize the Summoner name because names are used in standardized
        // format in the Riot API, so we'll need it in standard form when processing the
        // API responses
        stdSummonerName = SummonerRequest.standardizeSummonerName(name: summonerName)
        beginSummonerDataRetrieval()
    }
    
    fileprivate func beginSummonerDataRetrieval() {
        let summonerRequest = SummonerRequest.init(summonerNames: stdSummonerName)
        Alamofire.request(summonerRequest.requestURL,
                          method:summonerRequest.requestType ?? .get).responseJSON {
                            [unowned self] (response) in
                            switch response.result {
                                case .success(let value):
                                    let responseJSON = JSON(value)
                                    self.summonerInfo = SummonerInfo.init(infoJSON: responseJSON[self.stdSummonerName])
                                
                                case.failure(let error):
                                    print("\(error)")
                            }
        }
    }
}
