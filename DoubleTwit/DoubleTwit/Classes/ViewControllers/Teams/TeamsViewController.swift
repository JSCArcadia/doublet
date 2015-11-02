//
//  TeamsViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 09/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit

 /// Teams screen controller presenting list of all hockey teams that participated in the KHL championship

class TeamsViewController: UIViewController {

    @IBOutlet weak var favoriteTeamContainerView: UIView!
    @IBOutlet weak var favTeamNameLabel: UILabel!
    @IBOutlet weak var favTeamDetailsLabel: UILabel!
    @IBOutlet weak var favTeamWebsiteButton: UIButton!
    @IBOutlet weak var favTeamKHLPageButton: UIButton!
    
    @IBOutlet weak var teamsTableView: UITableView!
    
    // Array for keeping all teams data (instances of Team object)
    var teamsList = NSMutableArray()
    // Instance of the Backendless for sending API requests
    var backendless = Backendless.sharedInstance()
    // Utility variable for keeping a Team object for sub-screen with details about selected team (TeamDetailsViewController)
    var teamForDetails: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull Data from Backendless - requesting all teams data sorted by team name
        let queryOptions: QueryOptions = QueryOptions()
        let fieldName: String = (currentLocale != "ru") ? "nameEng" : "name"
        queryOptions.sortBy([fieldName])
        
        let query: BackendlessDataQuery = BackendlessDataQuery()
        query.queryOptions = queryOptions
        
        backendless.persistenceService.of(Team.ofClass()).find(
            
            query, response: { (results: BackendlessCollection!) -> () in
                
                let currentPage = results.getCurrentPage()
                
//                print("Total results in the Backendless storage - \(results.totalObjects)")
                
                // Saving all data into the mutable array
                for result in currentPage {
                    self.teamsList.addObject(result)
                }
                
                // Check user defaults and setup UI elements for a favorite team if any
                let teamObjIdFromUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("DT_FavoriteTeamID") as? String
                
                if let teamObjIdFromUserDefaults = teamObjIdFromUserDefaults {
                    self.setupFavoriteTeamWithID(teamObjIdFromUserDefaults)
                } else {
                    self.favoriteTeamContainerView.hidden = true
                }
                
                // Forcing table view reload
                self.teamsTableView.reloadData()
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
        
        // Add self as observer for the favorite team changes
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "favoriteTeamChanged:",
            name: "FavoriteTeamIDWasChanged",
            object: nil)
    }
    
    // Remove self from observers
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation UI setup
        self.setNavigationBarItemLeftOnly()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TeamTableViewCell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! TeamTableViewCell
        
        // Configure the custom cell with team info
        let teamInfo = teamsList[indexPath.row] as! Team
        cell.setContentFromTeamInfo(teamInfo)
        
        return cell
    }

    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        teamForDetails = teamsList[indexPath.row] as! Team
        // Present details screen for selected team
        performSegueWithIdentifier("TeamDetails", sender: self)
    }
    
    // MARK: Actions
    
    /**
    Utility function for handling all taps from favorite team buttons with link
    */
    
    @IBAction func onLinksButtonTap(sender: UIButton) {
        if let url = NSURL(string: (sender.titleLabel?.text)!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TeamDetails" {
            // Assign an instance of Team object to a variable of Team details controller
            let vc = segue.destinationViewController as! TeamDetailsViewController
            vc.team = teamForDetails
        }
    }
    
    // MARK: Utils
    
    /**
    Handling changes for the favorite team selection
    
    - parameter notification: notification with name FavoriteTeamIDWasChanged
    */
    
    @objc func favoriteTeamChanged(notification: NSNotification){
        // Getting Team ID for current favorite team from user defaults
        let teamObjIdFromUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("DT_FavoriteTeamID") as? String
        
        // Updating state of favorite team star button for visible cells
        for cell in teamsTableView.visibleCells {
            let cell = cell as! TeamTableViewCell
            if cell.teamObjId != teamObjIdFromUserDefaults {
                cell.favoriteTeamButton.selected = false
            }
        }
        
        // Setup UI elements for a favorite team if any
        if let teamObjIdFromUserDefaults = teamObjIdFromUserDefaults {
            self.setupFavoriteTeamWithID(teamObjIdFromUserDefaults)
        } else {
            favoriteTeamContainerView.hidden = true
        }
    }
    
    /**
     Setup UI elements for a favorite team with Team ID provided
     
     - parameter teamId: Team ID (Team.objectId)
     */
    
    func setupFavoriteTeamWithID (teamId: String) {
        for team in teamsList {
            let team = team as! Team
            
            if team.objectId == teamId {
                favTeamNameLabel.text = team.nameLoc() + NSLoc("teams.favorite.team")
                favTeamDetailsLabel.text = team.countryLoc() + ", " + team.cityLoc()
                favTeamWebsiteButton.setTitle(team.websiteLoc(), forState: .Normal)
                favTeamKHLPageButton.setTitle(team.khlPageLoc(), forState: .Normal)
                favoriteTeamContainerView.hidden = false
                break
            }
        }
    }
}
