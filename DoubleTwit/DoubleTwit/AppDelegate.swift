//
//  AppDelegate.swift
//  DoubleTwit
//
//  Created by Victor Kotov on 17/09/15.
//  Copyright © 2015 Arcadia. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Init Fabric suite with two SDKs
        Fabric.with([Crashlytics.self(), Twitter.self()])
        
        //Backendless init
        Backendless.sharedInstance().initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        // iCloud + NSUserDefaults sync
        MKiCloudSync.startWithPrefix("DT")
        MKiCloudSync.forceUpdateFromiCloud()
        
        // Setup navigation with SlideMenuControllerSwift lib
        self.createMenuView()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Utils
    
    private func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        let leftMenuViewController = storyboard.instantiateViewControllerWithIdentifier("LeftMenuViewController") as! LeftMenuViewController
        let rightMenuViewController = storyboard.instantiateViewControllerWithIdentifier("RightMenuViewController") as! RightMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: homeViewController)
        
        leftMenuViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }

}

