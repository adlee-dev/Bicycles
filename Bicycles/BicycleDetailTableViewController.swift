//
//  BicycleDetailTableViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/24/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class contains a static table view holding all the properties (which, are
// optional and so may not have values) for a particular Bicycle instance. Each table
// cell pushes a view controller onto the view stack which allos editing of a particular
// instance property. These changes are then saved through the appropriate action of this
// class (or not, if the changes are cancelled).

class BicycleDetailTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var bicycleImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var frameSizeLabel: UILabel!
    @IBOutlet weak var frameColorLabel: UILabel!
    @IBOutlet weak var chainringsLabel: UILabel!
    @IBOutlet weak var cassetteRangeLabel: UILabel!
    @IBOutlet weak var cassetteSprocketCountLabel: UILabel!
    @IBOutlet weak var wheelSizeLabel: UILabel!
    @IBOutlet weak var stemLengthLabel: UILabel!
    
    
    @IBOutlet weak var nicknameKeyLabel: UILabel!
    @IBOutlet weak var brandKeyLabel: UILabel!
    @IBOutlet weak var modelKeyLabel: UILabel!
    @IBOutlet weak var typeKeyLabel: UILabel!
    @IBOutlet weak var serialNumberKeyLabel: UILabel!
    @IBOutlet weak var frameSizeKeyLabel: UILabel!
    @IBOutlet weak var frameColorKeyLabel: UILabel!
    @IBOutlet weak var chainringsKeyLabel: UILabel!
    @IBOutlet weak var cassetteRangeKeyLabel: UILabel!
    @IBOutlet weak var cassetteSprocketCountKeyLabel: UILabel!
    @IBOutlet weak var purchaseDetailsKeyLabel: UILabel!
    @IBOutlet weak var wheelSizeKeyLabel: UILabel!
    @IBOutlet weak var stemLengthKeyLabel: UILabel!
    
    // MARK: - Properties
    
    var delegate: BicyclePersistenceDelegate?
    var bicycle: Bicycle?
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // had issue with navbar being transluscent dark
        // http://stackoverflow.com/questions/22413193/dark-shadow-on-navigation-bar-during-segue-transition-after-upgrading-to-xcode-5
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        // read attributes of bicycle object and apply to cells as needed
        addDataToCells()
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Populate Table
    
    /// Adds elements of bicycles array to table data fields.
    /// - Returns: Void
    func addDataToCells() {
        // assuming bicycle is not null
        if let bicycle = bicycle {            
            bicycleImageView.image = bicycle.image
            
            processTextData(nicknameKeyLabel, valueLabel: nicknameLabel, value: bicycle.nickname)
            processTextData(brandKeyLabel, valueLabel: brandLabel, value: bicycle.brand)
            processTextData(modelKeyLabel, valueLabel: modelLabel, value: bicycle.model)
            processTextData(typeKeyLabel, valueLabel: typeLabel, value: bicycle.type)
            processTextData(serialNumberKeyLabel, valueLabel: serialNumberLabel, value: bicycle.serialNumber?.value)
            processTextData(frameSizeKeyLabel, valueLabel: frameSizeLabel, value: bicycle.frameSize)
            processTextData(frameColorKeyLabel, valueLabel: frameColorLabel, value: bicycle.frameColor)
            processTextData(chainringsKeyLabel, valueLabel: chainringsLabel, value: bicycle.chainrings)
            processTextData(cassetteRangeKeyLabel, valueLabel: cassetteRangeLabel, value: bicycle.cassetteRange)
            processTextData(wheelSizeKeyLabel, valueLabel: wheelSizeLabel, value: bicycle.wheelSize)
            
            processIntegerData(cassetteSprocketCountKeyLabel, valueLabel: cassetteSprocketCountLabel, value: bicycle.cassetteSprocketCount)
            processIntegerData(stemLengthKeyLabel, valueLabel: stemLengthLabel, value: bicycle.stemLength)
            
            processSerialNumberData()
            processPurchaseDetailsData()
        }
    }
    
    /// Handles cell state for non-custom cell types containing String data.
    /// - Parameters:
    ///     - keyLabel: UILabel that holds the key for this cell
    ///     - valueLabel: UILabel that holds the value for this cell
    ///     - value: Optional String for the value stored in valueLabel
    /// - Returns: Void
    func processTextData(keyLabel: UILabel, valueLabel: UILabel, value: String?) {
        if let value = value {
            keyLabel.textColor = UIColor.darkTextColor()
            valueLabel.text = value
        }
        else {
            keyLabel.textColor = UIColor.lightGrayColor()
            valueLabel.text = nil
        }
    }
    
    /// Handles cell state for non-custom cell types containing Int data.
    /// - Parameters:
    ///     - keyLabel: UILabel that holds the key for this cell
    ///     - valueLabel: UILabel that holds the value for this cell
    ///     - value: Optional Int for the value stored in valueLabel
    /// - Returns: Void
    func processIntegerData(keyLabel: UILabel, valueLabel: UILabel, value: Int?) {
        if let value = value {
            keyLabel.textColor = UIColor.darkTextColor()
            valueLabel.text = String(value)
        }
        else {
            keyLabel.textColor = UIColor.lightGrayColor()
            valueLabel.text = nil
        }
    }
    
    /// Handles cell state for SerialNumber cell
    /// - Returns: Void
    func processSerialNumberData() {
        if let serialNumber = bicycle?.serialNumber {
            serialNumberKeyLabel.textColor = UIColor.darkTextColor()
            serialNumberLabel.text = serialNumber.value
        }
        else {
            serialNumberKeyLabel.textColor = UIColor.lightGrayColor()
            serialNumberLabel.text = nil
        }
    }
    
    /// Handles cell state for PurchaseDate cell
    /// - Returns: Void
    func processPurchaseDetailsData() {
        if bicycle?.purchaseDetails != nil {
            purchaseDetailsKeyLabel.textColor = UIColor.darkTextColor()
        }
        else {
            purchaseDetailsKeyLabel.textColor = UIColor.lightGrayColor()
        }
    }
    
    /// Handles cell state for BicycleImage cell
    /// - Returns: Void
    func processBicycleImageData() {
        if let bicycleImage = bicycle?.image {
            bicycleImageView.image = bicycleImage
        }
        else {
            bicycleImageView.image = UIImage(named: "noImage")
        }
    }
    
    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // determine which cell was clicked
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)!
        switch (selectedCell.reuseIdentifier)! {
        case "imageCell", "serialNumberCell", "purchaseDetailsCell":
            // do nothing here since segues will handle these selections
            break
        default:
            editGenericCell(selectedCell)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowSerialNumber" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationController.topViewController as! SerialNumberViewController
            
            targetController.delegate = self
            
            if let serialNumber = bicycle?.serialNumber {
                targetController.serialNumberValue = serialNumber.value
                targetController.serialNumberImage = serialNumber.image
            }
            
            print("SerialNumber UITableViewCell pressed. Transitioning to SerialNumberViewController with existing SerialNumber instance, if any.")
        }
        else if segue.identifier == "ShowBicycleImage" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationController.topViewController as! BicycleImageViewController
            targetController.delegate = self
            targetController.bicycleImage = bicycleImageView.image
            
            print("BicycleImage UITableViewCell pressed. Transitioning to BicycleImageViewController with existing UIImage instance, if any.")
        }
        else if segue.identifier == "ShowPurchaseDetails" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationController.topViewController as! PurchaseDetailsViewController
            targetController.delegate = self
            if let purchaseDetails = bicycle?.purchaseDetails {
                targetController.storeName = purchaseDetails.storeName
                targetController.amountPaid = purchaseDetails.amountPaid
                targetController.datePurchased = purchaseDetails.datePurchased
            }
            
            print("PurchaseDetails UITableViewCell pressed. Transitioning to PurchaseDetailsViewController with existing PurchaseDetails instance, if any.")
        }
        
    }
    
    /// Instantiates an EditBicycleAttributeViewController object and pushes to top 
    /// of view stack. Handles arbitrary data (so long as there is only one textField
    /// on the pushed controller.
    ///  - Parameter selected: UITableViewCell that was selected and which determines the
    /// data that will be viewed/modified by the pushed controller
    /// - Returns: Void
    func editGenericCell(selected: UITableViewCell) {
        // creates a view that allows the user to edit a cell that does not
        // require a custom edit procedure
        
        // determine the key for the cell, and the value text, if any
        let key = selected.textLabel!.text!
        let value = selected.detailTextLabel?.text
        let mode: EditViewControllerMode
        
        switch (key) {
            case "Cassette Sprocket Count", "Stem Length":
                mode = .Numeric
            default:
                mode = .Text
        }

        let controller = EditBicycleAttributeViewController(key: key, value: value, mode: mode)
        controller.delegate = self
        
        print("\(key) UITableViewCell pressed. Transitioning to EditBicycleAttributeViewController configured for \(key) with existing property data, if any.")
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    /// Save action for the Save button in this view. Persists changes made to the local
    /// Bicycle instance to Bicycle array in BicycleTableViewController, the associated
    /// TableView, and to the NSCoding data store and then returns to
    /// BicycleTableViewController
    /// - Parmeter sender: UIBarButtonItem which initiates the action
    /// - Returns: Void
    @IBAction func saveButton(sender: UIBarButtonItem) {
        print("Save Button pressed. Saving data to BicycleTableViewController bicycles Array through BicycleDelegate method.")
        delegate?.saveBicycle(bicycle!)
        
        print("Dismissing BicycleDetailTableViewController. Transitioning to BicycleTableViewController.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Cancel action for the Cancel button in this view. Makes no changes to the data
    /// model and returns to BicycleTableViewController
    /// - Parameter sender: UIBarbuttonItem which initiates the action
    /// - Returns: Void
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        print("Cancel Button pressed. No changes made to BicycleTableViewController bicycles Array.")
        
        print("Dismissing BicycleDetailTableViewController. Transitioning to BicycleTableViewController.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - BicycleDelegate Protocol

/// Delegate protocol which enables the various edit view controllers associated with
/// the property key-value pairs to commit their changes to the local Bicycle instance
protocol BicycleDelegate: class {
    func updateGenericBicycleAttribute(key: String, value: String?) -> Void
    
    func updateSerialNumber(value: String?, image: UIImage?) -> Void
    
    func updateBicycleImage(image: UIImage?) -> Void
    
    func updatePurchaseDetails(storeName: String?, amountPaid: NSDecimalNumber?, datePurchased: NSDate?) -> Void
}

// MARK: - BicycleDelegate Extension

extension BicycleDetailTableViewController : BicycleDelegate {
    
    /// Updates a simple (e.g. String, Int) Bicycle property. Does not persist changes
    /// to NSCoding repository.
    /// - Parameters:
    ///     - key: String representing the property to be updated
    ///     - value: Optional String representing the new value for the key
    /// - Returns: Void
    func updateGenericBicycleAttribute(key: String, value: String?) {
        switch (key) {
        case "Nickname":
            bicycle!.nickname = value
        case "Brand":
            bicycle!.brand = value
        case "Model":
            bicycle!.model = value
        case "Type":
            bicycle!.type = value
        case "Frame Size":
            bicycle!.frameSize = value
        case "Frame Color":
            bicycle!.frameColor = value
        case "Chainrings":
            bicycle!.chainrings = value
        case "Cassette Range":
            bicycle!.cassetteRange = value
        case "Cassette Sprocket Count":
            bicycle!.cassetteSprocketCount = Int(value!)
        case "Wheel Size":
            bicycle!.wheelSize = value
        case "Stem Length":
            bicycle?.stemLength = Int(value!)
        default:
            break
        }
        
        self.tableView.reloadData()
    }
    
    /// Updates the SerialNumber property of the current Bicycle instance. Does not
    /// persist changes to NSCoding repository.
    /// - Parameters:
    ///     - value: Optional String for the SerialNumber.value property
    ///     - image: Optional UIImage for the SerialNumber.image property
    /// - Returns: Void
    func updateSerialNumber(value: String?, image: UIImage?) {
        if value == nil {
            // destroy the instance since required value is nil
            bicycle?.serialNumber = nil
        }
        else if bicycle?.serialNumber != nil {
            // reassign instance properties if the instance already exists
            bicycle!.serialNumber!.value = value!
            bicycle!.serialNumber!.image = image!
        }
        else {
            // initialize the instance
            bicycle?.serialNumber = Bicycle.SerialNumber(value: value!, image: image)
        }
        
        self.tableView.reloadData()
    }
    
    /// Updates the PurchaseDetails property of the current Bicycle instance. Does not
    /// persist changes to NSCoding repository.
    /// - Parameters:
    ///     - storeName: Optional String for the PurchaseDetails.storeName property
    ///     - amountPaid: Optional NSDecimalNumber for the PurchaseDetails.amountPaid property
    ///     - datePurchased: Optional NSDate for the PurchaseDetails.datePurchased property
    /// - Returns: Void
    func updatePurchaseDetails(storeName: String?, amountPaid: NSDecimalNumber?, datePurchased: NSDate?) {
        if (storeName == nil && amountPaid == nil && datePurchased == nil) {
            // destroy the instance, if any, since no data in it
            bicycle?.purchaseDetails = nil
        }
        else if bicycle?.purchaseDetails != nil {
            // reassign instance properties if the instance already exists
            bicycle?.purchaseDetails?.storeName = storeName
            bicycle?.purchaseDetails?.amountPaid = amountPaid
            bicycle?.purchaseDetails?.datePurchased = datePurchased
        }
        else {
            // initialize the instance
            bicycle?.purchaseDetails = Bicycle.PurchaseDetails()
            bicycle?.purchaseDetails?.storeName = storeName
            bicycle?.purchaseDetails?.amountPaid = amountPaid
            bicycle?.purchaseDetails?.datePurchased = datePurchased
        }
        
        self.tableView.reloadData()
    }
    
    /// Updates the image property of the current Bicycle instance. Does not
    /// persist changes to NSCoding repository.
    /// - Parameter image: Optional UIImage for the bicycle
    /// - Returns: Void
    func updateBicycleImage(image: UIImage?) {
        bicycle?.image = image
        
        self.tableView.reloadData()
    }
}


