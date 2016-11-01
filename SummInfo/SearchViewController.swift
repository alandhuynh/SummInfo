//
//  ViewController.swift
//  SummInfo
//
//  Created by Alan Huynh on 10/30/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, SummonerLoadingDelegate {
    
    @IBOutlet weak fileprivate var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    @IBOutlet weak fileprivate var searchButton: UIButton!    
    @IBOutlet weak fileprivate var spinner: UIActivityIndicatorView!
    
    fileprivate var summoner: Summoner?
    fileprivate var didFinishLoading = false

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
                // Since we're searching for the summoner we just looked at, we
                // can go straight to the segue
                didFinishLoading = true
                performSegue(withIdentifier: "Show Summoner Info", sender: nil)
                return
            }
            summoner = Summoner.init(summonerName: summonerName)
            summoner?.delegate = self
            
            // Disable search since we're in the middle of a query
            enableSearch(shouldEnable: false)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Show Summoner Info" {
            return didFinishLoading
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "Show Summoner Info":
                    // Reset the UI elements before the segue
                    enableSearch(shouldEnable: true)
                    
                    if let dest = segue.destination as? SummonerInfoTableViewController {
                        dest.summoner = summoner
                        
                        // Since we can only reach here if we already finished loading, we
                        // should reset the loading flag for future searches
                        didFinishLoading = false
                    }
                default:
                    break
            }
        }
    }
    
    fileprivate func enableSearch(shouldEnable: Bool) {
        if shouldEnable {
            searchTextField.isEnabled = true
            
            spinner.stopAnimating()
            searchButton.isHidden = false
        } else {
            searchTextField.isEnabled = false
            
            searchButton.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
        }
    }
    
    func summonerDidLoad(summoner: Summoner) {
        didFinishLoading = true
        performSegue(withIdentifier: "Show Summoner Info", sender: nil)
    }
    
    func summonerNotFound() {
        let alert = UIAlertController.init(title: "Summoner \(searchTextField.text!) not found",
            message: "Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true) {
            [unowned self] in
            self.enableSearch(shouldEnable: true)
            
            // Since we were unable to find the summoner, we should reset the summoner property
            self.summoner = nil
        }
        
    }
}

