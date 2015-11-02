//
//  TeamDetailsViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 09/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit
import TwitterKit

 /// Team details screen controller presenting information about the team and team's Twitter timeline

class TeamDetailsViewController: UIViewController {

    // Team object - assigned from TeamsViewController
    var team: Team!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryAndCityLabel: UILabel!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var khlButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setting up UI elements for the team specified
        self.setupContentWithTeam(team)
        
        // Setting up TWTRTimelineViewController with team's Twitter account
        for timelineController in self.childViewControllers as! [TWTRTimelineViewController] {
            let client = TWTRAPIClient()
            let dataSource = TWTRUserTimelineDataSource(screenName: team.twitterLoc(), APIClient: client)
            
            timelineController.dataSource = dataSource
            timelineController.showTweetActions = false
            timelineController.viewWillAppear(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    Setting up UI elements for the team specified's name, city, Twitter, website and KHL website page

     
     - parameter team: instance of Team object
     */
    
    func setupContentWithTeam (team: Team) {
        nameLabel.text = team.nameLoc()
        countryAndCityLabel.text = team.countryLoc() + ", " + team.cityLoc()
        twitterButton.setTitle(("https://twitter.com/" + team.twitterLoc()), forState: .Normal)
        websiteButton.setTitle(team.websiteLoc(), forState: .Normal)
        khlButton.setTitle(team.khlPageLoc(), forState: .Normal)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
