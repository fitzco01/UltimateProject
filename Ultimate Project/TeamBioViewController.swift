//
//  TeamBioViewController.swift
//  Ultimate Project
//
//  Created by Connor Fitzpatrick on 10/6/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class TeamBioViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var roster: UITableView!
    @IBOutlet weak var schedule: UITableView!
    @IBOutlet weak var tweets: UITableView!
    
    // MARK: - Variables
    
    var players: [PlayerFinder] = []
    var myTeam: TeamFinder?
    var games: [GameFinder] = []
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        let team = defaults.object(forKey: "team") as! String
        let twitter = defaults.object(forKey: "twitterHandle") as! String


        JsonParser.jsonClient.getMyPlayer(team: team, twitter: twitter) {[weak self](myPlayers) in
            self?.players = myPlayers
            DispatchQueue.main.async(execute: {
                self?.roster.reloadData()
            })
        }
        
        JsonParser.jsonClient.getMyGames(team: team, twitter: twitter) {[weak self](myGames) in
            self?.games = myGames
            DispatchQueue.main.async(execute: {
                self?.schedule.reloadData()
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TeamBioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.roster {
            count =  players.count
        } else if tableView == self.schedule {
            count = games.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.roster {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginplayercell", for: indexPath) as! PlayerTableViewCell
            
            let player = players[(indexPath as NSIndexPath).row]
            cell.configure(player)
            
            return cell
        } else if tableView == self.schedule {
            let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath) as! GameTableViewCell
            
            let game = games[(indexPath as NSIndexPath).row]
            cell.configure(game)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweets", for: indexPath) as! UITableViewCell
            
            let game = games[(indexPath as NSIndexPath).row]
//            cell.configure(game)
            
            return cell
        }
    }
}
