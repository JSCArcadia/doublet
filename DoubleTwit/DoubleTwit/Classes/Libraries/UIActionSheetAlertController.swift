//
//  UIActionSheetAlertController.swift
//
//  DoubleTwit
//
//  Created by Victor Kotov on 28/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import Foundation
import UIKit

class UIActionSheetAlertController {
    
    /**
     Compatibility class for using UIActionSheet at iOS 7 and UIAlertController at iOS 8+
     
     - parameter title:                     Title for action sheet or alert controller
     - parameter message:                   Message for user
     - parameter options:                   Array of titles for buttons (additional options)
     - parameter handlerMessages:           Array of notification names for every option in previous array
     - parameter presentFromViewController: ViewController to show the sheet or alert from
     */
    func showActionSheet (title: String?, message: String?, options: [String], handlerMessages: [String], presentFromViewController: UIViewController) {
// Commented in case we will add support for iOS 7
//        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

            // Additional setup for iPad devices
            if let alertController = alertController.popoverPresentationController {
                let presentFromViewController = presentFromViewController as! HomeViewController
                alertController.sourceView = presentFromViewController.middleButton
                alertController.sourceRect = presentFromViewController.middleButton.bounds
                alertController.delegate = presentFromViewController
            }
            
            // Create the actions.
            for var i = 0; i < options.count; ++i {
                let optionTitle = options[i] as String;
                
                if i < handlerMessages.count {
                    let handlerMessage = handlerMessages[i]
                    let action = UIAlertAction(title: optionTitle, style: .Default) { action in
                        NSNotificationCenter.defaultCenter().postNotificationName(handlerMessage, object: nil)
                    }
                    
                    alertController.addAction(action);
                }
            }
            
            // Add the actions.
            let cancelAction = UIAlertAction(title: NSLoc("common.cancel"), style: .Cancel) { action in
                NSLog("The \"Other\" alert's cancel action occured.")
            }
            
            alertController.addAction(cancelAction)
            
            presentFromViewController.presentViewController(alertController, animated: true, completion: nil)
//        } else {
//            // Fallback on earlier iOS versions
//            UIActionSheet.showInView(presentFromViewController.view, withTitle: title, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: options, tapBlock: { (actionSheet, buttonIndex) -> Void in
//                if buttonIndex < handlerMessages.count {
//                    let handlerMessage = handlerMessages[buttonIndex]
//                    NSNotificationCenter.defaultCenter().postNotificationName(handlerMessage, object: nil)
//                }
//            })
//        }
    }
}