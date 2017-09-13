//
//  BicycleImageViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/27/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class manages the assignment of a photo for a particular Bicycle instance.
// Changes here are not persisted until "Save" action is performed on
// BicycleDetailTableViewController.

class BicycleImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var bicycleImage: UIImage? = UIImage(named: "noImage")
    weak var delegate: BicycleDelegate?

    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = bicycleImage
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
        print("UIImagePickerController Cancel button pressed. Transitioning back to BicycleImageViewController.")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // If an image chosen in imagePicker, record the chosen image and close the picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = selectedImage
        
        print("UIImagePickerController Done button pressed. Setting BicycleImageViewController image property to selected image. Transitioning back to BicycleImageViewController.")
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

    // MARK: - Actions
    
    /// Cancel action for the Cancel button in this view. Does not pass changes made, if
    /// any, to BicycleDetailTableViewController Bicycle instance.
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        print("Cancel button pressed. Transitioning back to BicycleDetailTableViewController. No changes made to Bicycle instance.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Done action for the Done button in this view. Passes changes made here to
    /// BicycleDetailTableViewController Bicycle instance.
    /// - Note: Changes made here are not persisted to the NSCoding repository until
    /// Save action has been performed on BicycleDetailTableViewController.
    /// - Parameter sender: UIBarButtonItem which initiates this action
    /// - Returns: Void
    @IBAction func doneButton(sender: UIBarButtonItem) {
        self.delegate?.updateBicycleImage(imageView.image)
        
        print("Done button pressed. Transitioning back to BicycleDetailTableViewController. Bicycle instance image set to current BicycleImageViewController image.")
        
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
