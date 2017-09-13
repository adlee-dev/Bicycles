//
//  PurchaseDetailsViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/29/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class manages the assignment of the PurchaseDetails instance for a
// particular Bicycle instance.
// Changes here are not persisted until "Save" action is performed on
// BicycleDetailTableViewController.

class PurchaseDetailsViewController : UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var amountPaidTextField: UITextField!
    @IBOutlet weak var datePurchasedDatePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var storeName: String?
    var amountPaid: NSDecimalNumber?
    var datePurchased: NSDate?
    weak var delegate: BicycleDelegate?
    
    enum TextFieldTags: Int {
        case StoreName = 0
        case AmountPaid
    }
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeNameTextField.text = storeName
        storeNameTextField.delegate = self
        storeNameTextField.tag = TextFieldTags.StoreName.rawValue
        
        amountPaidTextField.text = amountPaid?.stringValue
        amountPaidTextField.delegate = self
        amountPaidTextField.tag = TextFieldTags.AmountPaid.rawValue
        
        // set properties of UIDatePicker
        datePurchasedDatePicker.date = (datePurchased != nil) ? datePurchased! : NSDate()
        datePurchasedDatePicker.maximumDate = NSDate()
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    // based on http://stackoverflow.com/a/27884715/3113924
    // Restricts input for NSDecimalNumber field to decimal values
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool
    {
        // only need to validate input for amountPaidTexField
        if textField.tag == TextFieldTags.AmountPaid.rawValue {
            if let text = textField.text {
                let components = text.componentsSeparatedByString(".")
                let countdots = components.count - 1
                if countdots > 0 && string == "." {
                    print("User attempting to add more than one decimal point. Rejecting attempt as this is not valid.")
                    return false
                }
                // only allow 2 numbers after the decimal
                // compare string parameter to "" to allow delete to occur in all cases
                else if components.count > 1 && components[1].characters.count > 1 && string != "" {
                    print("User attempting to add more than 2 digits after decimal point. Typical currency values only allow for 2 places after decimal in transactions.")
                    return false
                }
            }
        }
       
        return true
    }
    
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
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func cancelEditPurchaseDetails(sender: UIBarButtonItem) {
        print("Cancel button pressed. Transitioning back to BicycleDetailTableViewController. No changes made to Bicycle instance.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Sends data entered by user to BicycleDetailTableViewController to save to update that view's Bicycle instance.
    /// - Note: Changes made here are not persisted to the NSCoding repository until
    /// Save action has been performed on BicycleDetailTableViewController.
    /// - Parameter sender: UIBarButtonItem which initiates the action
    /// - Returns: Void
    @IBAction func finishEditPurchaseDetails(sender: UIBarButtonItem) {
        let storeName = storeNameTextField.text
        let amountPaid = NSDecimalNumber(string: amountPaidTextField.text)
        let datePurchased = datePurchasedDatePicker.date
        
        
        self.delegate?.updatePurchaseDetails(storeName, amountPaid: amountPaid, datePurchased: datePurchased) 
        
        print("Done button pressed. Transitioning back to BicycleDetailTableViewController. Bicycle instance PurchaseDetails property set to current PurchaseDetail instance.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
