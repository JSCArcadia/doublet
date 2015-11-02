//
//  Season.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 08/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation

 /// Season data model - for getting and managing data from the Backendless service https://backendless.com

class Season: BackendlessEntity {
    var startDate: NSDate?
    var ownerId: String?
    var endDate: NSDate?
    var title: String?
}