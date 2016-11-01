//
//  SummonerInfoTableViewController.swift
//  SummInfo
//
//  Created by Alan Huynh on 11/1/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation
import UIKit

class SummonerInfoTableViewController: UITableViewController {
    
    // Header Outlets
    @IBOutlet weak fileprivate var iconImage: UIImageView!
    @IBOutlet weak fileprivate var levelLabel: UILabel!
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    
    // League Outlets
    @IBOutlet weak fileprivate var leagueNameLabel: UILabel!
    @IBOutlet weak fileprivate var leagueEmblemImage: UIImageView!
    @IBOutlet weak fileprivate var tierDivisionLabel: UILabel!
    
    @IBOutlet weak fileprivate var lpLabel: UILabel!
    @IBOutlet weak fileprivate var winPercentageLabel: UILabel!
    @IBOutlet weak fileprivate var numWinsLabel: UILabel!
    @IBOutlet weak fileprivate var numLossesLabel: UILabel!
    
    var summoner: Summoner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    fileprivate func updateUI() {
        if let summoner = summoner {
            if let icon = summoner.profileIcon {
                iconImage.image = icon
            }
            if let name = summoner.name {
                nameLabel.text = name
            }
            if let level = summoner.level {
                levelLabel.text = "Level \(level)"
            }
            
            if let leagueInfo = summoner.leagueInfo {
                leagueNameLabel.text = leagueInfo.name
                leagueEmblemImage.image = leagueInfo.emblem
                
                
                if var tierDivision = leagueInfo.tier {
                    if let division = leagueInfo.division {
                        tierDivision.append(" \(division)")
                    }
                    tierDivisionLabel.text = tierDivision
                } else {
                    tierDivisionLabel.text = ""
                }
                
                if leagueInfo.isInLeague {
                    lpLabel.text = "\(leagueInfo.lp!) LP"
                    
                    let winPercentage = Double(leagueInfo.numWins!) /
                        Double((leagueInfo.numWins! + leagueInfo.numLosses!)) * 100
                    winPercentageLabel.text = "\(round(winPercentage))% Win Rate"
                    
                    numWinsLabel.text = leagueInfo.numWins!.description
                    numLossesLabel.text = leagueInfo.numLosses!.description
                } else {
                    lpLabel.text = "N/A"
                    winPercentageLabel.text = ""
                    numWinsLabel.text = "N/A"
                    numLossesLabel.text = "N/A"
                }
            }
        }
    }
}
