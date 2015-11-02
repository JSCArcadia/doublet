//
//  TeamTableViewCell.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 09/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit

/// Class for custom UITableViewCell - used at the Teams screen

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    // Country and City - more details at next screen
    @IBOutlet weak var shortDetailsLabel: UILabel!
    
    var teamObjId: String!
    
    @IBOutlet weak var favoriteTeamButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Sending notifications about the favorite team selection (or deselection)
     */
    
    @IBAction func onFavoriteButtonTap(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.selected {
            NSUserDefaults.standardUserDefaults().setValue(teamObjId, forKey: "DT_FavoriteTeamID")
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("DT_FavoriteTeamID")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("FavoriteTeamIDWasChanged", object: nil)
    }
    
    /**
     Setting up cell UI elements with data from an object of Team type
     
     - parameter teamInfo: instance of Team object
     */
    
    func setContentFromTeamInfo (teamInfo: Team) {
        nameLabel.text = teamInfo.nameLoc()
        shortDetailsLabel.text = teamInfo.countryLoc() + ", " + teamInfo.cityLoc()
        teamObjId = teamInfo.objectId
        
        // Highlight a favorite team if any from user defaults.
        let teamObjIdFromUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("DT_FavoriteTeamID") as? String
        
        if teamObjId == teamObjIdFromUserDefaults {
            favoriteTeamButton.selected = true
        } else {
            favoriteTeamButton.selected = false
        }
    }
}
