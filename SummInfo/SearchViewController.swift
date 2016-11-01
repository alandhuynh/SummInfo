//
//  ViewController.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/30/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak fileprivate var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    fileprivate var summoner: Summoner?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a tap gesture recognizer so that the keyboard can be dismissed when the
        // user taps anywhere on the screen
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self,
                                                               action: #selector(handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended && searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
    
    @IBAction func searchButtonTapped(sender: UITextField) {
        initializeSummoner()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        initializeSummoner()
        searchTextField.resignFirstResponder()
        return true
    }
    
    fileprivate func initializeSummoner() {
        if let summonerName = searchTextField.text, !summonerName.isEmpty {
            let stdSummonerName = SummonerRequest.standardizeSummonerName(name: summonerName)
            if let summoner = summoner, summoner.stdName == stdSummonerName {
                return
            }
            summoner = Summoner.init(summonerName: summonerName)
        }
    }
}

