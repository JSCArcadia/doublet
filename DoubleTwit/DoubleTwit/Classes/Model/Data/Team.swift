//
//  Teams.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 08/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation

/// Team data model - for getting and managing data from the Backendless service https://backendless.com

class Team: BackendlessEntity {
    var twitterEng: String?
    var city: String?
    var country: String?
    var countryEng: String?
    var nameEng: String?
    var cityEng: String?
    var khlPageEng: String?
    var website: String?
    var ownerId: String?
    var twitter: String?
    var khlPage: String?
    var name: String?
    var websiteEng: String?
    var nameSuffix: String?
    var nameSuffixEng: String?
    
    /**
    Getter for localized version of Twitter timeline
    
    - returns: Russian for ru and English for any other languages (if exists)
    */
    func twitterLoc () -> String {
        return (currentLocale != "ru") && (twitterEng != "") ? twitterEng! : twitter!
    }
    
    /**
     Getter for localized version of City
     
     - returns: Russian for ru and English for any other languages
     */
    func cityLoc () -> String {
        return (currentLocale != "ru") && (cityEng != "") ? cityEng! : city!
    }
    
    /**
     Getter for localized version of Country
     
     - returns: Russian for ru and English for any other languages
     */
    func countryLoc () -> String {
        return (currentLocale != "ru") && (countryEng != "") ? countryEng! : country!
    }
    
    /**
     Getter for localized version of Team name
     
     - returns: Russian for ru and English for any other languages
     */
    func nameLoc () -> String {
        return (currentLocale != "ru") && (nameEng != "") ? nameEng! : name!
    }
    
    /**
     Getter for localized version of Team name suffix as some teams have same names, so we have to add a City's name abbrevation
     
     - returns: Russian for ru and English for any other languages
     */
    func nameSuffixLoc () -> String {
        return (currentLocale != "ru") ? (nameSuffixEng != nil ? nameSuffixEng! : "" ) : (nameSuffix != nil ? nameSuffix! : "")
    }
    
    /**
     Getter for localized version of Team's page at KHL website
     
     - returns: Russian for ru and English for any other languages (if exists)
     */
    func khlPageLoc () -> String {
        return (currentLocale != "ru") && (khlPageEng != "") ? khlPageEng! : khlPage!
    }
    
    /**
     Getter for localized version of Team's website
     
     - returns: Russian for ru and English for any other languages (if exists)
     */
    func websiteLoc () -> String {
        return (currentLocale != "ru") && (websiteEng != "") ? websiteEng! : website!
    }
}