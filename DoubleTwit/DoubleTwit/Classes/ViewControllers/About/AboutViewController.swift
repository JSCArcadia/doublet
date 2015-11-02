//
//  AboutViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 22/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit
import TwitterKit

 /// Presenting main information about the company and app's Twitter timeline as news feed

class AboutViewController: UIViewController {

    @IBOutlet weak var feedbackFormWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation UI setup
        self.setNavigationBarItemLeftOnly()
        
        // Setting up TWTRTimelineViewController with app's Twitter account
        for timelineController in self.childViewControllers as! [TWTRTimelineViewController] {
            let client = TWTRAPIClient()
            let dataSource = TWTRUserTimelineDataSource(screenName: "doublet4khl", APIClient: client)
            
            timelineController.dataSource = dataSource
            timelineController.showTweetActions = false
            timelineController.viewWillAppear(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    /**
    Utility function for handling taps from company website button
    */
    
    @IBAction func onCompanyWebsiteButtonTap(sender: AnyObject) {
        if let url = NSURL(string: NSLoc("common.arcadia.website")) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    /**
     Utility function for handling taps from feedback button. Opening the Google Forms document in Safari browser
     */
    
    @IBAction func onFeedbackButtonTap(sender: AnyObject) {
        if let url = NSURL(string: shortURLForFeedbackForm) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
