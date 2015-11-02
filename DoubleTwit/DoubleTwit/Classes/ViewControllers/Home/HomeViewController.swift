//
//  HomeViewController.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 22/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit
import TwitterKit

 /// Main screen - presents two Twitter timelines at once and also navigation UI (left and right side menu)

enum ConstraintsForMiddleButton: Int {
    case HalfScreen = 0
    case FullTop
    case FullBottom
    case Unknown
}

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    /// Timers for Twitter timeline auto-update and UI element that presents counter till next update
    var timer: NSTimer? = nil
    var refreshProgressTimer: NSTimer? = nil
    var autoUpdate = true
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var timelinesRefreshProgressView: UIProgressView!
    
    // Utility constraints for screen's layout manual updates
    @IBOutlet weak var verticalAlignmentConstraintForMiddleButton: NSLayoutConstraint!
    @IBOutlet weak var topConstraintForMiddleButton: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintForMiddleButton: NSLayoutConstraint!
    
    @IBOutlet var middleButtonPanGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup self as observer for all notifications required
        setupObservingForNotifications()
        
        // Add recognizer to the middle button to handle screen's layout changes
        middleButton.addGestureRecognizer(middleButtonPanGestureRecognizer)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation UI setup
        self.setNavigationBarItem()
        
        // Setup two instances of TWTRTimelineViewController
        self.setupTwitterTimelineContainers()
        
        // Kick off auto-update timers
        autoUpdateModeSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Utils
    
    /**
     Setup two instances of TWTRTimelineViewController with data from DoublePair singleton
    */
    
    func setupTwitterTimelineContainers () {
        // Set DataSource for each TWTRTimelineViewController
        for timelineController in self.childViewControllers as! [TWTRTimelineViewController] {
            let client = TWTRAPIClient()
            let dataSource = TWTRUserTimelineDataSource(screenName: DoublePair.sharedInstance.screennamesToShow()[self.childViewControllers.indexOf(timelineController)!], APIClient: client)
            
            timelineController.dataSource = dataSource
            // Disabled for 1st release due some technical issues of Twitter SDK
            //timelineController.showTweetActions = true
        }
    }
    
    /**
     Auto-update for pair of TWTRTimelineViewController fired by timer
     */
    
    func updateTwitterTimelineContainers () {
        for timelineController in self.childViewControllers as! [TWTRTimelineViewController] {
            let dataSource = timelineController.dataSource as! TWTRUserTimelineDataSource
            if dataSource.screenName != "" {
                timelineController.viewWillAppear(false)
                timelinesRefreshProgressView.setProgress(1.0, animated: false)
            }
        }
    }

    /**
     Auto-update for UIProgressView fired by timer
     */
    
    func updateRefreshProgress () {
            var currentProgress: Float = timelinesRefreshProgressView.progress - Float(1/refreshTimePeriod)
            
            if currentProgress < 0 {
                currentProgress = 0
            }
            
            timelinesRefreshProgressView.setProgress(currentProgress, animated: false)
    }

    /**
     Kick off auto-update timers
     */
    func autoUpdateModeSetup() {
        if autoUpdate {
            if timer == nil {
                timer = NSTimer.scheduledTimerWithTimeInterval(refreshTimePeriod, target:self, selector: Selector("updateTwitterTimelineContainers"), userInfo: nil, repeats: true)
            }
            
            if refreshProgressTimer == nil {
                refreshProgressTimer = NSTimer.scheduledTimerWithTimeInterval(refreshTimePeriodForProgressView, target:self, selector: Selector("updateRefreshProgress"), userInfo: nil, repeats: true)
            }
            
            timelinesRefreshProgressView.hidden = false
        } else {
            // If auto-update was turned off invalidate all timers and hide UIProgressView
            timer?.invalidate()
            timer = nil
            refreshProgressTimer?.invalidate()
            refreshProgressTimer = nil
            timelinesRefreshProgressView.hidden = true
            timelinesRefreshProgressView.setProgress(1, animated: false)
        }
    }
    
    /**
     Handle updates for DoublePair singleton
     */
    
    @objc func doubletPairChanged(notification: NSNotification){
        self.setupTwitterTimelineContainers()
        self.updateTwitterTimelineContainers()
    }
    
    /**
     Pan Gesture handler for Middle Button
     */
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            var newMode: ConstraintsForMiddleButton = .Unknown
            if translation.y > 0 {
                newMode = .FullTop
            } else if translation.y < 0 {
                newMode = .FullBottom
            }
            
            self.createAndApplyConstraintsForMiddleButtonWithMode(newMode)
        }
    }
    
    /**
     Setting up layout constrains according to specified mode
     
     - parameter mode: one of three possible modes (only top, only bottom, 50/50)
     */
    
    func createAndApplyConstraintsForMiddleButtonWithMode(mode: ConstraintsForMiddleButton) {
        self.cleanupAllVerticalConstraintsForMiddleButton()
        
        switch mode {
        case .HalfScreen:
            verticalAlignmentConstraintForMiddleButton = NSLayoutConstraint(item: middleButton, attribute:.CenterY, relatedBy:.Equal, toItem: middleButton.superview, attribute:.CenterY, multiplier: 1.0, constant: 0.0)
            self.view.addConstraint(verticalAlignmentConstraintForMiddleButton)
            break
        case .FullTop:
            bottomConstraintForMiddleButton = NSLayoutConstraint(item: middleButton, attribute:.Bottom, relatedBy:.Equal, toItem:middleButton.superview, attribute:.Bottom, multiplier: 1.0, constant: 0.0)
            self.view.addConstraint(bottomConstraintForMiddleButton)
            break
        case .FullBottom:
            topConstraintForMiddleButton = NSLayoutConstraint(item: middleButton, attribute:.Top, relatedBy:.Equal, toItem:self.topLayoutGuide, attribute:.Bottom, multiplier: 1.0, constant: 0.0)
            self.view.addConstraint(topConstraintForMiddleButton)
            break
        case .Unknown:
            self.view.layoutIfNeeded()
        }
        
        self.view.layoutIfNeeded()
    }

    /**
     Utility function for cleaning layout constraints before applying new ones
     */
    
    func cleanupAllVerticalConstraintsForMiddleButton () {
        if let verticalAlignmentConstraint = self.verticalAlignmentConstraintForMiddleButton {
            self.view.removeConstraint(verticalAlignmentConstraint)
        }

        if let topConstraint = self.topConstraintForMiddleButton {
            self.view.removeConstraint(topConstraint)
        }

        if let bottomConstraint = self.bottomConstraintForMiddleButton {
            self.view.removeConstraint(bottomConstraint)
        }
        
        middleButton.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    /**
     Setup self as observer for all notifications required
     */
    
    func setupObservingForNotifications () {
        // Add self as observer for the DoubletPair singleton changes
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "doubletPairChanged:",
            name: "DoubletPairWasChanged",
            object: nil)
        
        // Add self as observer for the layout changes
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "showOnlyTopTimeline:",
            name: "ShowOnlyTopTimeline",
            object: nil)
        
        // Add self as observer for the layout changes
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "showOnlyBottomTimeline:",
            name: "ShowOnlyBottomTimeline",
            object: nil)
        
        // Add self as observer for the layout changes
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "showEqualTimelines:",
            name: "ShowEqualTimelines",
            object: nil)
        
        // Add self as observer for setup Twitter timelines manually
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "setupTimelinesManually:",
            name: "SetupTimelinesManually",
            object: nil)
        
        // Add self as observer for changes in auto-update settings
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "changeAutoUpdateState:",
            name: "ChangeAutoUpdateState",
            object: nil)
    }
    
    //MARK: Actions
    
    /**
     Presenting alert controller with actions list - more details in UIActionSheetAlertController
    */
    
    @IBAction func onRefreshButtonTap(sender: AnyObject) {
        let actionsheet = UIActionSheetAlertController()
        actionsheet.showActionSheet(nil, message: nil, options: [NSLoc("alert.options.top"), NSLoc("alert.options.bottom"), NSLoc("alert.options.5050"), NSLoc("alert.options.custompair"), autoUpdate ? NSLoc("alert.options.autoupdate.turn.off") : NSLoc("alert.options.autoupdate.turn.on")], handlerMessages: ["ShowOnlyTopTimeline", "ShowOnlyBottomTimeline", "ShowEqualTimelines", "SetupTimelinesManually", "ChangeAutoUpdateState"],  presentFromViewController: self)
    }
    
    // Handling UI layout updates from notifications

    func showOnlyTopTimeline (notification: NSNotification) {
        createAndApplyConstraintsForMiddleButtonWithMode(.FullTop)
    }

    func showOnlyBottomTimeline (notification: NSNotification) {
        createAndApplyConstraintsForMiddleButtonWithMode(.FullBottom)
    }

    func showEqualTimelines (notification: NSNotification) {
        createAndApplyConstraintsForMiddleButtonWithMode(.HalfScreen)
    }

    func setupTimelinesManually (notification: NSNotification) {
        self.performSegueWithIdentifier("SetupTimelinesManually", sender: self)
    }
    
    // Handling auto-update settings changes from notifications
    
    func changeAutoUpdateState (notification: NSNotification) {
        autoUpdate = !autoUpdate
        autoUpdateModeSetup()
    }

    // MARK: UIPopoverPresentationController delegate methods
    
    /**
     Delegate's method for updating UIPopoverPresentationController at iPad family devices
     */
    
    func popoverPresentationController(popoverPresentationController: UIPopoverPresentationController,
        willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>,
        inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
            rect.initialize(middleButton.bounds)
    }
}
