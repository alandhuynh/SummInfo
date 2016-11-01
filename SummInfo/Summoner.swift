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

let NOT_FOUND = "Not Found"

struct SummonerJSONKeys {
    static let Name = "name"
    static let Id = "id"
    static let IconId = "profileIconId"
    static let Level = "summonerLevel"
    
    static let Status = "status"
    static let Message = "message"
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

struct LeagueJSONKeys {
    static let Name = "name"
    static let Tier = "tier"
    static let Division = "division"
    static let LP = "leaguePoints"
    static let NumWins = "wins"
    static let NumLosses = "losses"
    
    static let Entries = "entries"
}

let UNKNOWN_LEAGUE = "Unknown"

struct LeagueInfo {
    var name: String?
    var tier: String?
    var division: String?
    var lp: String?
    var numWins: Int?
    var numLosses: Int?
    var emblem: UIImage?
    
    // A flag indicating that the Summoner is actually in a league
    var isInLeague: Bool = true
    
    init(infoJSON: JSON) {
        let infoEntry = infoJSON[0]
        name = infoEntry[LeagueJSONKeys.Name].stringValue
        tier = infoEntry[LeagueJSONKeys.Tier].stringValue
        
        let subEntries = infoEntry[LeagueJSONKeys.Entries][0]
        division = subEntries[LeagueJSONKeys.Division].stringValue
        lp = subEntries[LeagueJSONKeys.LP].stringValue
        numWins = subEntries[LeagueJSONKeys.NumWins].intValue
        numLosses = subEntries[LeagueJSONKeys.NumLosses].intValue
        
        emblem = UIImage.init(named: getEmblemImageName())
    }
    
    init() {
        tier = UNKNOWN_LEAGUE
        isInLeague = false
        emblem = UIImage.init(named: getEmblemImageName())
    }
    
    fileprivate func getEmblemImageName() -> String {
        var emblemImageName = ""
        if let tier = tier {
            emblemImageName = "\(tier.uppercased())"
            if let division = division {
                emblemImageName.append("_\(division)")
            }
            emblemImageName.append(".png")
        }
        return emblemImageName
    }
}

protocol SummonerLoadingDelegate: class {
    func summonerDidLoad(summoner: Summoner) -> Void
    
    func summonerNotFound() -> Void
}

class Summoner {
    weak var delegate: SummonerLoadingDelegate?
    
    fileprivate var stdSummonerName: String
    fileprivate var summonerInfo: SummonerInfo?
    var leagueInfo: LeagueInfo?
    
    var stdName: String {
        return stdSummonerName
    }
    
    var name: String? {
        if let info = summonerInfo, let summonerName = info.name {
            return summonerName
        }
        return nil
    }
    
    var level: String? {
        if let info = summonerInfo, let summonerLevel = info.level {
            return summonerLevel
        }
        return nil
    }
    
    var profileIcon: UIImage?
    
    fileprivate var hasLoadedId = false
    fileprivate var hasLoadedIcon = false
    fileprivate var hasLoadedLeague = false
    fileprivate var isDoneLoading: Bool {
        return hasLoadedId && hasLoadedIcon && hasLoadedLeague
    }
    
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
                                    
                                    if self.responseNotFound(response: responseJSON) {
                                        if let delegate = self.delegate {
                                            delegate.summonerNotFound()
                                        }
                                        return
                                    }
                                    
                                    self.summonerInfo = SummonerInfo.init(infoJSON: responseJSON[self.stdSummonerName])
                                    self.getProfileIcon()
                                    self.getLeagueInfo()
                                
                                case.failure(let error):
                                    if let delegate = self.delegate {
                                        delegate.summonerNotFound()
                                    }
                                    print("\(error)")
                            }
                            self.hasLoadedId = true
        }
    }
    
    fileprivate func getProfileIcon() {
        if let iconId = summonerInfo?.iconId {
            let iconRequest = GameImageRequest.init(imageType: ImageType.ProfileIcon,
                                                    imageId: iconId)
            Alamofire.request(iconRequest.requestURL,
                              method: iconRequest.requestType ?? .get).responseData {
                [unowned self] (response) in
                switch response.result {
                    case .success(let value):
                        let image = UIImage.init(data: value)
                        if let image = image {
                            self.profileIcon = image
                        }

                    case .failure(let error):
                        print("\(error)")
                }
                 
                self.hasLoadedIcon = true
                if self.isDoneLoading, let delegate = self.delegate {
                    delegate.summonerDidLoad(summoner: self)
                    self.delegate = nil
                }
            }
        }
    }
    
    fileprivate func getLeagueInfo() {
        if let summonerId = summonerInfo?.id {
            let leagueRequest = LeagueRequest.init(summonerIds: summonerId)
            Alamofire.request(leagueRequest.requestURL,
                              method: leagueRequest.requestType ?? .get).responseJSON {
                  [unowned self] (response) in
                    switch response.result {
                        case .success(let value):
                            let responseJSON = JSON(value)
                            
                            if self.responseNotFound(response: responseJSON) {
                                self.leagueInfo = LeagueInfo.init()
                            } else {
                                self.leagueInfo = LeagueInfo.init(infoJSON: responseJSON[summonerId])
                            }
                        case .failure(let error):
                            self.leagueInfo = LeagueInfo.init()
                            print("\(error)")
                    }
                    
                    self.hasLoadedLeague = true
                    if self.isDoneLoading, let delegate = self.delegate {
                        delegate.summonerDidLoad(summoner: self)
                        self.delegate = nil
                    }
            }
        }
    }
    
    // Helper method used to check for "Not Found" responses since they still register as
    // successful requests by Alamofire
    fileprivate func responseNotFound(response: JSON) -> Bool {
        return response[SummonerJSONKeys.Status][SummonerJSONKeys.Message].stringValue == NOT_FOUND
    }
}
