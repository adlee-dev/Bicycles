//
//  AppDelegate.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/22/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var networkConnectionDelegate: NetworkConnectionDelegate?
    var splashControllerDisplayed = false
    var isInitialLaunch = true


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register perference defaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let dateFormatter = NSDateFormatter()
        
        print(userDefaults.stringForKey("developer_name"))
        print(userDefaults.stringForKey("developer_github_id"))
        print(userDefaults.stringForKey("initial_launch_date"))
        
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        let launchDate = dateFormatter.stringFromDate(NSDate())
        
        if userDefaults.stringForKey("initial_launch_date") == nil {
            // set the initial launch date
            userDefaults.setObject(launchDate, forKey: "initial_launch_date")
        }
        

        let defaults = [ "developer_name" : "Andrew Lee",
                         "developer_github_id" : "viking4821",
                         "initial_launch_date" : launchDate ]
        
        userDefaults.registerDefaults(defaults)
        print(userDefaults.dictionaryRepresentation())
        
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
        
        // Tests if the network is available for the Maps tab.
        // Assumes that Maps tab has been visited at least once during current 
        // application lifecycle. Allows application to reset controls disabled
        // due to lack of network.
        if let networkConnectionDelegate = networkConnectionDelegate {
            if !networkConnectionDelegate.connectedToNetwork() {
                networkConnectionDelegate.displayNetworkErrorMessage()
                networkConnectionDelegate.disableSearchControls()
            }
            else {
                networkConnectionDelegate.enableSearchControls()
            }
        }
        
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - UIViewController Extension - Splash Display

extension UIViewController {
    // based on http://stackoverflow.com/a/31954066/3113924
    /// Adds a NSNotification observer for the applicationDidBecomeActive event
    /// - Returns: Void
    func addApplicationDidBecomeActiveNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(displaySplash),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }

    /// Displays the splash view controller
    /// - Returns: Void
    func displaySplash() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // was having issue where topMostController() was getting called multiple times and attempting to display the controller multiple times
        // need to check for top-most controller to get around warning of attempting to present on non-existent view
        if appDelegate.splashControllerDisplayed == false {
            appDelegate.splashControllerDisplayed = true
            let controller = storyboard!.instantiateViewControllerWithIdentifier("Splash") as! SplashViewController
            
            let topController = topMostController()
            
            topController.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // based on http://stackoverflow.com/a/38327281/3113924
    /// Retrieves the top most view controller in the view stack.
    /// - Returns: UIViewController
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

