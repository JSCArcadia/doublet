//
//  GamesCalendar.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 08/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation

/// GamesCalendar data model - for getting and managing data from the Backendless service https://backendless.com

class GamesCalendar: BackendlessEntity {
    var notes: String?
    var dateOfGame: NSDate?
    
    var ownerId: String?
    var score: String?
    
    var city: String?
    var cityEng: String?
    
    var guestTeam: Team?
    var hostTeam: Team?
    var season: Season?
    
    /**
     Getter for localized version of City were the game played in
     
     - returns: Russian for ru and English for any other languages
     */
    func cityLoc () -> String {
        return (currentLocale != "ru") && (cityEng != "") ? cityEng! : city!
    }

}