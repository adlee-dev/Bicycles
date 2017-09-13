//
//  EditViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/27/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit


/// Enum that respresents the possible input modes (keyboard types) to be used by 
/// an instance of EditBicycleAttributeViewController.
enum EditViewControllerMode {
    case Text
    case Numeric
}


// This class dynamically manages the editing of a non-custom Bicycle instance
// attribute. Empty values entered here for an attribute will result in the 
// Bicycle instance registering the property as nil, not empty string.

class EditBicycleAttributeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var key: String?
    var value: String?
    var mode: EditViewControllerMode
    
    var textField: UITextField?
    weak var delegate: BicycleDelegate?
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add controls
        addNavigationBar()
        addTextField()
        
        // set background color
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(key: String, value: String?, mode: EditViewControllerMode) {
        self.key = key
        self.value = value
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // creation of UIBarButtonItems based on http://stackoverflow.com/a/24641521/3113924
    
    /// Instantiates a UINavigationItem and UINaviationBar and adds them to parent view.
    /// Returns: - Void
    func addNavigationBar() {
        let navigationItem = UINavigationItem()
        
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(cancelEdit)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Done",
            style: .Done,
            target: self,
            action: #selector(finishEdit)
        )
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "\(key!)"
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
    }
    
    /// Instantiates a UITextField and adds to parent view.
    /// - Returns: Void
    func addTextField() {
        
        textField = UITextField()
        
        // set the textField delegate
        textField?.delegate = self
        
        // add the placehodler text
        textField!.placeholder = key!
        
        // add the existing value, if any
        if let text = value {
            textField!.text = text
        }
        
        // originally attempted to position contorl using iOS 9 Layout Anchors, but
        // couldn't get to work properly (kept getting conflicts. It seems that
        // in order to use these anchors, you must turn of the autoresizing mask
        // which would mean specifying constraints for all of the subviews
        // (even the navigation bar?), which I don't really want to do for
        // a single textfield on a modal view
        // used http://useyourloaf.com/blog/pain-free-constraints-with-layout-anchors/ and https://cocoacasts.com/working-with-auto-layout-and-layout-anchors/ as resources
        // fell back to using frame
        
        // simulate margins of 20 points
        textField!.frame = CGRect(x: 20, y: 84, width: self.view.frame.width - 40, height: 30)
        textField!.borderStyle = .RoundedRect
        textField!.clearButtonMode = .WhileEditing
        
        // if input mode is numeric, use number pad, else use the default iOS keyboard
        if mode == .Numeric {
            textField?.keyboardType = .NumberPad
        }
        
        self.view.addSubview(textField!)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    /// Cancel action for the Cancel button in this view. Does not pass changes made, if
    /// any, to BicycleDetailTableViewController Bicycle instance.
    /// - Returns: Void
    func cancelEdit() {
        // dismiss the view controller and change nothing
        print("Cancel button pressed. Transitioning back to BicycleDetailTableViewController. No changes made to Bicycle instance.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Done action for the Done button in this view. Passes changes made here to
    /// BicycleDetailTableViewController Bicycle instance.
    /// - Note: Changes made here are not persisted to the NSCoding repository until
    /// Save action has been performed on BicycleDetailTableViewController.
    /// - Returns: Void
    func finishEdit() {
        let text = textField?.text != "" ? textField?.text : nil
        
        delegate?.updateGenericBicycleAttribute(key!, value: text)
        
        print("Done button pressed. Transitioning back to BicycleDetailTableViewController. Bicycle instance \(key) property set to current value")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
