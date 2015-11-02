//
//  DoubletPair.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 25/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation

 /// Singleton class for a pair of Twitter accounts these app presenting at the moment

class DoublePair {
    
    static let sharedInstance = DoublePair()
    
    var topTimeline: TwitTimelineSource = TwitTimelineSource()
    var bottomTimeline: TwitTimelineSource = TwitTimelineSource()
    
    /**
     Singleton always initialized with two KHL's Twitter official accounts. User have to choose some other from Today Games screen or set them manually
     */
    init () {
        topTimeline.screenName = "khl"
        bottomTimeline.screenName = "khl_eng"
    }
    
    /**
     Getter for a pair of Twitter accounts to show
     
     - returns: array of strings (Twitter accounts) for top and bottom timelines
     */
    func screennamesToShow() -> [String] {
        return [topTimeline.screenName, bottomTimeline.screenName]
    }
    
}