//
//  SplashViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/30/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class exists solely to implement the continueButtonPressed action.

class SplashViewController: UIViewController {
    
    var isInitialLaunch = false
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // need some way to manage global state of application launch since
        // an NSNotification for applicationDidFinishLaunching wasn't working
        // in a different class
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        isInitialLaunch = appDelegate!.isInitialLaunch

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Splash" {
            appDelegate!.isInitialLaunch = false
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Splash" {
            return isInitialLaunch
        }
        
        // there aren't other segues in this view so this statement is technically
        // unreachable but makes the compiler happy
        return false
    }
    
    /// Method prints log message to console.
    /// - Parameter sender: UIButton that initiates this action
    /// - Returns: Void
    @IBAction func continueButtonPressed(sender: UIButton) {
        print("Continue Button pressed. Transitioning to next view in stack.")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.splashControllerDisplayed = false
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
