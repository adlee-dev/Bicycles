//
//  InstructionsViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/30/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class displays the instructions for the application.

class InstructionsViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // based on http://stackoverflow.com/a/34248700/3113924
    override func viewDidLayoutSubviews() {
        self.instructionsTextView.setContentOffset(CGPointZero, animated: false)
    }
}
