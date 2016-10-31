//
//  Summoner.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/31/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation
import Alamofire

let INVALID_ID = -1

class Summoner {
    fileprivate var summonerName: String
    fileprivate var summonerId: Int?
    
    init(summonerName: String) {
        self.summonerName = summonerName
        self.beginSummonerDataRetrieval()
    }
    
    fileprivate func beginSummonerDataRetrieval() {
        let summonerRequest = SummonerRequest.init(summonerNames: summonerName)
        Alamofire.request(summonerRequest.requestURL,
                          method:summonerRequest.requestType ?? .get).responseJSON {
                            [unowned self] (response) in
                            switch response.result {
                                case .success(let value):
                                    print("\(value)")
                                case.failure(let error):
                                    self.summonerId = INVALID_ID
                                    print("\(error)")
                            }
        }
    }
}
