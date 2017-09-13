//
//  SerialNumberViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/27/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class manages the assignment of the SerialNumber instance for a 
// particular Bicycle instance.
// Changes here are not persisted until "Save" action is performed on
// BicycleDetailTableViewController.

class SerialNumberViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var serialNumberImage: UIImage? = UIImage(named: "noImage")
    var serialNumberValue: String?
    weak var delegate: BicycleDelegate?
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = serialNumberImage
        textField.text = serialNumberValue
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    // If imagePicker canceled, close the imagePicker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("UIImagePickerController Cancel button pressed. Transitioning back to SerailNumberViewController.")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // If an image chosen in imagePicker, record the chosen image and close the picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = selectedImage
        
        print("UIImagePickerController Done button pressed. Setting SerialNumberViewController image property to selected image. Transitioning back to SerialNumberViewController.")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Display the specified image picker (Camera or Photo Library)
    /// - Parameter mode: UIImagePickerControllerSourceType indicating whether the picker will be in Photo Library or Camera mode
    /// - Returns: Void
    func presentPicker(mode: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = mode
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
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
    
    /// Sends data entered by user to BicycleDetailTableViewController to save to update that view's Bicycle instance.
    /// Validates that the user has entered valid data into the UITextField control
    /// before continuing with save operation.
    /// - Note: Changes made here are not persisted to the NSCoding repository until
    /// Save action has been performed on BicycleDetailTableViewController.
    /// - Parameter sender: UIBarButtonItem which initiates the action
    /// - Returns: Void
    @IBAction func doneButton(sender: UIBarButtonItem) {
        
        // if serial number field is empty, but the image is not, cancel Done action
        // since serial number must be populated with value (can only have image if
        // also have serial number)
        if (textField.text == nil || textField.text!.isEmpty) && imageView.image != UIImage(named: "noImage")  {
            
            //present alert
            let title = "Serial Number value required!"
            let message = "You must enter a serial number in the designated field if you provide a Serial Number image. Alternatively, you may swipe the image to delete it."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            print("SerialNumber value property is empty or nil but image is not default noImage. SerialNumber value property must have a value if image is other than default.")
            
            // return to skip the rest of the done action
            return
        }
        
        self.delegate?.updateSerialNumber(textField.text, image: imageView.image)
        
        print("Done button pressed. Transitioning back to BicycleDetailTableViewController. Bicycle instance SerialNumber property set to current SerialNumber instance.")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Cancel action for the Cancel button in this view. Does not pass changes made, if
    /// any, to BicycleDetailTableViewController Bicycle instance.
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        print("Cancel button pressed. Transitioning back to BicycleDetailTableViewController. No changes made to Bicycle instance.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /// Opens UIImagePickerController in photo library mode
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func libraryButton(sender: UIBarButtonItem) {
        print("Photo Library button pressed. Opening UIImagePickerController in Library mode.")
        presentPicker(.PhotoLibrary)
    }
    
    /// Opens UIImagePickerController in camera mode
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        print("Camera button pressed. Opening UIImagePickerController in Camera mode.")
        presentPicker(.Camera)
    }
    
    /// Removes the existing photo and replaces with "noImage" photo when user
    /// swipes right.
    /// - Parameter sender: UISwipeGestureRecognizer that initiates the action
    /// - Returns: Void
    @IBAction func handleSwipeRight(sender: UISwipeGestureRecognizer) {
        // remove the existing image, if any
        print("Swipe Right gesture recognized. Overwritting existing image with noImage default.")
        imageView.image = UIImage(named: "noImage")
    }
    
    /// Removes the existing photo and replaces with "noImage" photo when user
    /// swipes left.
    /// - Parameter sender: UISwipeGestureRecognizer that initiates the action
    /// - Returns: Void
    @IBAction func handleSwipeLeft(sender: UISwipeGestureRecognizer) {
        // remove the existing image, if any
        print("Swipe Left gesture recognized. Overwritting existing image with noImage default.")
        imageView.image = UIImage(named: "noImage")
    }
}
