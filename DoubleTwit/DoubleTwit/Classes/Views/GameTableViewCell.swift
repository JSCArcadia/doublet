//
//  GameTableViewCell.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 25/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit

 /// Class for custom UITableViewCell - used at the right menu (Today Games screen)

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var teamsLabel: UILabel!
    @IBOutlet weak var gameStartTimeLabel: UILabel!
    var hostTwitTimeLine: TwitTimelineSource!
    var guestTwitTimeLine: TwitTimelineSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     Setting up cell UI elements with data from an object of GamesCalendar type
     
     - parameter gameInfo: instance of GamesCalendar object
     */
    
    func setContentFromGameInfo (gameInfo: GamesCalendar) {
        leagueNameLabel.text = gameInfo.cityLoc()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        gameStartTimeLabel.text = dateFormatter.stringFromDate(gameInfo.dateOfGame!)
        
        // Some teams have same names, so we need add a suffix - City abbrevation
        teamsLabel.text = (gameInfo.hostTeam?.nameLoc())! + (gameInfo.hostTeam?.nameSuffixLoc())! + " - " + (gameInfo.guestTeam?.nameLoc())! + (gameInfo.guestTeam?.nameSuffixLoc())!
        
        hostTwitTimeLine = TwitTimelineSource()
        hostTwitTimeLine.screenName = gameInfo.hostTeam?.twitterLoc()
        hostTwitTimeLine.teamName = gameInfo.hostTeam?.nameLoc()
        guestTwitTimeLine = TwitTimelineSource()
        guestTwitTimeLine.screenName = gameInfo.guestTeam?.twitterLoc()
        guestTwitTimeLine.teamName = gameInfo.guestTeam?.nameLoc()
    }
    
}
