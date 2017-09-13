//
//  BicycleTableViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/24/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class is the initial view the user sees after the splash screen. It contains
// a UITableView that displays the Bicycle instances stored by the user to date or
// the sample data if the user has not added any of their own. The user can view or edit
// additional properties of a particular Bicycle instance by tapping on the associated
// table cell, or create a new Bicycle instance by tapping the Add button.

class BicycleTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var bicycles = [Bicycle]()

    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedBicycles = loadBicycles() {
            bicycles += savedBicycles
            print("Existing bicycles loaded as UITableView data source.")
        }
        else {
            loadSampleBicycles()
            print("Sample bicycles loaded as UITableView data source.")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Sampele Data Functions
    
    func loadSampleBicycles() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        let bicycle = Bicycle()
        let bicycle1 = Bicycle()
        
        bicycle.brand = "Bianchi"
        bicycle.image = UIImage(named: "bianchi")
        bicycle.nickname = "My Precious"
        bicycle.model = "Vigorelli 105"
        bicycle.type = "Road"
        bicycle.frameSize = "57 cm"
        bicycle.frameColor = "Celeste"
        bicycle.stemLength = 90
        bicycle.cassetteRange = "12-30T"
        bicycle.cassetteSprocketCount = 10
        bicycle.chainrings = "50-34"
        bicycle.wheelSize = "700x23C"
        
        bicycle.serialNumber = Bicycle.SerialNumber(value: "WBK733033H", image: UIImage(named: "noImage"))
        bicycle.purchaseDetails = Bicycle.PurchaseDetails()
        bicycle.purchaseDetails?.amountPaid = 999.00
        
        bicycle.purchaseDetails?.datePurchased = dateFormatter.dateFromString("12/5/2015")
        bicycle.purchaseDetails?.storeName = "On The Route Bicycles"
        
        bicycles.append(bicycle)
        
        
        
        bicycle1.brand = "Kona"
        bicycle1.image = UIImage(named: "kona")
        bicycle1.nickname = "Beater Bike"
        bicycle1.model = "Dew Deluxe"
        bicycle1.type = "Hybrid"
        bicycle1.frameSize = "56 cm"
        bicycle1.frameColor = "Green Metallic"
        bicycle1.stemLength = 90
        bicycle1.cassetteRange = "11-32T"
        bicycle1.cassetteSprocketCount = 9
        bicycle1.chainrings = "48-38-28"
        bicycle1.wheelSize = "700x32C"
        
        bicycle1.serialNumber = Bicycle.SerialNumber(value: "F1112K1748", image: UIImage(named: "noImage"))
        bicycle1.purchaseDetails = Bicycle.PurchaseDetails()
        bicycle1.purchaseDetails?.amountPaid = 800.00
        bicycle1.purchaseDetails?.datePurchased = dateFormatter.dateFromString("10/14/2011")
        bicycle1.purchaseDetails?.storeName = "Turin Bicycles"
        
        bicycles.append(bicycle1)
        
        saveBicycles()
    }
    
    // MARK: - UITableView Functions

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bicycles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // reuse identifier for cells in this table
        let cellIdentifier = "bicycleCell"
        
        // cast the cell as its type
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BicycleTableViewCell

        // Configure the cell...
        let bicycle = bicycles[indexPath.row]
        
        cell.bicycleImage.image = bicycle.image
        cell.nicknameLabel.text = (bicycle.nickname != nil) ? bicycle.nickname : "Bicycle #\(indexPath.row + 1)"
        
        // provide placeholders for label if they have no data
        if let brand = bicycle.brand {
            cell.brandLabel.text = brand
        }
        else {
            cell.brandLabel.text = "No Brand"
            cell.brandLabel.textColor = UIColor.lightGrayColor()
        }
        
        if let model = bicycle.model {
            cell.modelLabel.text = model
        }
        else {
            cell.modelLabel.text = "No Model"
            cell.modelLabel.textColor = UIColor.lightGrayColor()
        }
        
        if let type = bicycle.type {
            cell.typeLabel.text = type
        }
        else {
            cell.typeLabel.text = "No Type"
            cell.typeLabel.textColor = UIColor.lightGrayColor()
        }
        
        if let serialNumber = bicycle.serialNumber?.value {
            cell.serialNumberLabel.text = serialNumber
        }
        else {
            cell.serialNumberLabel.text = "No Serial Number"
            cell.serialNumberLabel.textColor = UIColor.lightGrayColor()
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            bicycles.removeAtIndex(indexPath.row)
            // persist the deleteion to data store
            saveBicycles()
            // remove the row from table
            print("Deleted existing Bicycle instance. Removing associated row from UITableView.")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowBicycle" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationController.topViewController as! BicycleDetailTableViewController
            
            if let selectedCell = sender as? BicycleTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedBicycle = bicycles[indexPath.row]
                
                targetController.navigationItem.title = "Edit Bicycle"
                // pass in a copy, not the original object so that changes can be 
                // easily cancelled
                targetController.bicycle = Bicycle(bicycle: selectedBicycle)
                targetController.delegate = self
                
                print("UITableViewCell pressed. Transitioning to BicycleDetailTableViewController with copy of existing Bicycle instance.")
            }
        }
        else if segue.identifier == "NewBicycle" {
            let destinationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationController.topViewController as! BicycleDetailTableViewController
            
            targetController.navigationItem.title = "Add Bicycle"
            targetController.bicycle = Bicycle()
            targetController.delegate = self
            
            print("Add Button pressed. Transitioning to BicycleDetailTableViewController with new Bicycle instance.")
        }
    }
    
    // MARK: - NSCoding Functions
    
    /// Persists all Bicycle instances to NSCoding directory
    /// - Returns: Void
    func saveBicycles() {
        print("Attempting to save bicycles to NSCoding repository at \(Bicycle.ArchiveURL.path!)")
        let successfulSave = NSKeyedArchiver.archiveRootObject(bicycles, toFile: Bicycle.ArchiveURL.path!)
        if !successfulSave {
            print("Failed to save bicycles to NSCoding repository!")
        }
        else {
            print("Successfully saved bicycles to NSCoding respository.")
        }
    }
    
    /// Loads all Bicycle instances from NSCoding directory
    /// - Returns: Array of Bicycle instances or nil
    func loadBicycles() -> [Bicycle]? {
        print("Attempting to load bicycles from NSCoding repository at \(Bicycle.ArchiveURL.path!)")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Bicycle.ArchiveURL.path!) as? [Bicycle]
    }

}

// MARK: - BicyclePersistenceDelegate Protocol

protocol BicyclePersistenceDelegate : class {
    func saveBicycle(bicycle: Bicycle) -> Void
}

// MARK: - BicycleCodingDelegate Extension

extension BicycleTableViewController : BicyclePersistenceDelegate {
    
    /// Enables the caller to pass changes made to the Bicycle array and updates
    /// the UITableView by either refreshing the existing cell or adding a new one.
    /// These changes are then persisted to the NSCoding repository.
    /// - Parameter bicycle: Bicycle instance which contains the changes for the 
    /// Bicycle instance that will be updated.
    func saveBicycle(bicycle: Bicycle) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // update the selected bicycle if a row was selected
            bicycles[selectedIndexPath.row] = bicycle
            print("Updated existing Bicycle instance. Reloading UITableView.")
            tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Automatic)
        }
        else {
            // otherwise, append the new bicycle to the list
            // an added bicycle will have the index of the current count since array is zero-based index
            let newIndexPath = NSIndexPath(forRow: bicycles.count, inSection: 0)
            bicycles.append(bicycle)
            print("Added new Bicycle instance. Reloading UITableView.")
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Left)
        }
        
        saveBicycles()
    }
}
