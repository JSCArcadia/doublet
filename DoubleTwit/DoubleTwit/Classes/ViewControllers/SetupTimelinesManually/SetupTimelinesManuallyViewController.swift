//
//  SetupTimelinesManuallyViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 05/10/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit
import TwitterKit

 /// Screen for setting Twitter timelines pair manually

class SetupTimelinesManuallyViewController: UIViewController {

    @IBOutlet weak var topTimelineTextField: UITextField!
    @IBOutlet weak var bottomTimelineTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Pre-load saved values from User Defaults if exists
        let doublePairFromUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("DT_CustomTimelinesPair") as? [String]
        
        if let doublePairFromUserDefaults = doublePairFromUserDefaults {
                topTimelineTextField.text = doublePairFromUserDefaults[0]
                bottomTimelineTextField.text = doublePairFromUserDefaults[1]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Check - Preload Twitter timeline that was typed by user
     */
    
    @IBAction func checkButtonsTap(sender: UIButton) {
        // Default value for Twitter timeline :)
        var screenName: String = "hcska"
        
        switch sender.tag {
        case 10:
            screenName = topTimelineTextField.text!
            topTimelineTextField.resignFirstResponder()
            break
        case 20:
            screenName = bottomTimelineTextField.text!
            bottomTimelineTextField.resignFirstResponder()
            break
        default: break
        }
        
        for timelineController in self.childViewControllers as! [TWTRTimelineViewController] {
            let client = TWTRAPIClient()
            let dataSource = TWTRUserTimelineDataSource(screenName: screenName, APIClient: client)
            
            timelineController.dataSource = dataSource
            timelineController.showTweetActions = false
            timelineController.viewWillAppear(false)
        }
    }
    
    /**
     Saving Twitter timeline pair to user defaults and updating DoublePair singleton object
     
     - parameter sender: <#sender description#>
     */
    
    @IBAction func onSaveButtonTap(sender: AnyObject) {
        let doublePair: DoublePair = DoublePair.sharedInstance

        let hostTeam: TwitTimelineSource = TwitTimelineSource()
        hostTeam.screenName = topTimelineTextField.text!
        let guestTeam: TwitTimelineSource = TwitTimelineSource()
        guestTeam.screenName = bottomTimelineTextField.text!
        
        doublePair.topTimeline = hostTeam
        doublePair.bottomTimeline = guestTeam
        
        NSUserDefaults.standardUserDefaults().setValue([topTimelineTextField.text!, bottomTimelineTextField.text!], forKey: "DT_CustomTimelinesPair")
        
        self.dismissViewControllerAnimated(true) { () -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("DoubletPairWasChanged", object: nil)
        }
    }
    
    @IBAction func cancelButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}
