//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation

/// Utility extension for SlideMenuControllerSwift lib

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}