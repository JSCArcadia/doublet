//
//  DTLocalizableHelpers.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 14/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation

 /// Handy functions and variables for localization support. The application provides two languages support: English (primary) and Russian. There are two places with localization related files: Resources/Localization/ and base localization for Main.storyboard

let currentLocale: String = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)! as! String

/**
Get localized string by key provided

- parameter key: identifier for specific localized string (Resources/Localization/)

- returns: Localized string with NSLocalizedString
*/

func NSLoc(key: String) -> String {
    return NSLocalizedString(key, comment: key)
}
