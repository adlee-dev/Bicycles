//
//  WishlistViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/28/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class holds a UITableView which shows either the user's current wishlist or 
// the wishlist history (deletes are not part of the history). The same UITableView
// is used for both lists and is dynamically changed depending on the value of
// the segmentedControl.

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets

    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var newWishlistItemButton: UIBarButtonItem!
    
    /// MARK: - Properties
    
    
    var currentWishlist = [Wish]()
    var historyWishlist = [Wish]()
    var dateFormatter = NSDateFormatter()
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedCurrentWishlist = loadWishlist("Current") {
            currentWishlist += savedCurrentWishlist
            print("Existing current wishlist loaded as UITableView data source.")
        }
        else {
            loadSampleCurrentWishlist()
            print("Sample current wishlist loaded as UITableView data source.")
        }
        
        if let savedHistoryWishlist = loadWishlist("History") {
            historyWishlist += savedHistoryWishlist
            print("Existing history wishlist loaded into instance Array.")
        }
        else {
            loadSampleHistoryWishlist()
            print("Sample history wishlist loaded into instance Array.")
        }

        // don't want cells to be selectable since there's no action associated with that
        wishlistTableView.allowsSelection = false
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Sample Data Functions
    
    func loadSampleCurrentWishlist() {
        dateFormatter.dateStyle = .ShortStyle
        let wish = Wish(itemTitle: "Fixed-Gear Bicycle", itemDescription: "Want to see what it's like", category: .Bicycle)
        wish.dateAdded = dateFormatter.dateFromString("07/21/2016")!
    
        currentWishlist.append(wish)
    }
    
    func loadSampleHistoryWishlist() {
        dateFormatter.dateStyle = .ShortStyle
        let wish = Wish(itemTitle: "Shimano SPD-SL Pedals 105 PD-5800", itemDescription: "Clipless pedals for my road bike", category: .Component)
        wish.dateAcquired = NSDate()
        wish.acquireMethod = .DIY
        wish.dateAdded = dateFormatter.dateFromString("06/07/2016")!
        
        historyWishlist.append(wish)
    }
    
    // MARK: - UITableView Functions
    
    // fixed issue with autosized table cells using http://stackoverflow.com/a/30497510/3113924
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            // if segmented control set to current
            return currentWishlist.count
        }
        else {
            // if segmented control set to history
            return historyWishlist.count
        }
    }
    
    // Populates the UITableView with cells as determined by value of segmentedControl
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        dateFormatter.dateStyle = .ShortStyle
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = wishlistTableView.dequeueReusableCellWithIdentifier("currentWishCell", forIndexPath: indexPath) as! CurrentWishTableViewCell
            let row = indexPath.row
            
            let wish = currentWishlist[row]
            
            cell.itemTitleLabel.text = wish.itemTitle
            cell.itemDescriptionLabel.text = wish.itemDescription
            cell.dateAddedLabel.text = dateFormatter.stringFromDate(wish.dateAdded)
            cell.categoryLabel.text = wish.category.rawValue
            
            return cell
        }
        else {
            let cell = wishlistTableView.dequeueReusableCellWithIdentifier("historyWishCell", forIndexPath: indexPath) as! HistoryWishTableViewCell
            let row = indexPath.row
            
            let wish = historyWishlist[row]
            
            cell.itemTitleLabel.text = wish.itemTitle
            cell.itemDescriptionLabel.text = wish.itemDescription
            cell.dateAddedLabel.text = dateFormatter.stringFromDate(wish.dateAdded)
            cell.categoryLabel.text = wish.category.rawValue
            cell.dateAcquiredLabel.text = (wish.dateAcquired != nil) ? dateFormatter.stringFromDate(wish.dateAcquired!) : nil
            cell.methodLabel.text = wish.acquireMethod?.rawValue
            
            return cell
        }
    }
    
    // Override to support conditional editing of the table view.
    // Determines if table row is editable
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if segmentedControl.selectedSegmentIndex == 0 {
            // allow editing for current wishlist only
            return true
        }
        else {
            return false
        }
    }
    
    
    // functionality based on http://stackoverflow.com/a/32586617/3113924
    // Creates actions when user swipes left (right-to-left) on a table cell
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let moveToHistory = UITableViewRowAction(style: .Normal, title: "Move to History")
        { action, indexPath in
           // remove wish from current list, move to history
            self.moveWishToHistory(indexPath)
        }
        
        moveToHistory.backgroundColor = UIColor.blueColor()
        
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete")
        { action, indexPath in
            // delete the wish
            self.deleteCurrentWishlistItem(indexPath)
        }
        
        return [moveToHistory, delete]
    }
    
    // MARK: - Actions
    
    @IBAction func handleSegmentedControl(sender: UISegmentedControl) {
        // show/hide barbuttonitem based on http://stackoverflow.com/a/24643804/3113924
        if segmentedControl.selectedSegmentIndex == 0 {
            // show the add button
            self.newWishlistItemButton!.enabled = true
            self.newWishlistItemButton!.tintColor = nil
            self.navigationItem.title = "Wishlist"
            
            print("Segemented Control pressed. Switching state to current wishlist.")
        }
        else {
            // hide the add button
            self.newWishlistItemButton!.enabled = false
            self.newWishlistItemButton!.tintColor = UIColor.clearColor()
            self.navigationItem.title = "Wishlist History"
            
            print("Segmented Control pressed. Switching state to history wishlist.")
        }
        
        self.wishlistTableView.reloadData()
    }
    
    /// Presents NewWishViewController that enables user to add a new Wish instance
    /// to their current wishlist.
    /// - Parameter sender: UIBarButtonItem which initiates the action.
    /// - Returns: Void
    @IBAction func addNewWishlistItemButton(sender: UIBarButtonItem) {
        let destinationController = NewWishViewController()
        
        destinationController.delegate = self
        
        print("Add Button pressed. Transitioning to NewWishViewController.")
        
        self.presentViewController(destinationController, animated: true, completion: nil)
    }
    
    /// Action for the table cell "Move To History" button.
    /// - Note: The button performing this action appears when the user swipes left
    /// on a table cell.
    /// - Parameter indexPath: The NSIndexPath object of the cell that the user swiped.
    /// - Returns: Void
    func moveWishToHistory(indexPath: NSIndexPath) {
        let wish = currentWishlist[indexPath.row]
        let destinationController = MoveWishToHistoryViewController(indexPath: indexPath, wish: wish)
        destinationController.delegate = self
        
        print("Move To History button pressed. Transitioning to MoveWishToHistoryViewController with reference to selected wishlist item.")
        self.presentViewController(destinationController, animated: true, completion: nil)
    }
    
    // MARK: - NSCoding Functions
    
    /// Persists the specified list to the NSCoding repository.
    /// - Parameters:
    ///     - list: Array of Wish objects representing the list to be saved.
    ///     - fileSuffix: String representing the name of the wishlist to be saved.
    /// - Returns: Void
    func saveWishlist(list: [Wish], fileSuffix: String) {
        let path = Wish.ArchiveURL.path! + "\(fileSuffix)"
        
        print("Attempting to save \(fileSuffix) wishlist to NSCoding repository at \(path)")

        let successfulSave = NSKeyedArchiver.archiveRootObject(list, toFile: path)
        if !successfulSave {
            print("Failed to save \(fileSuffix) wishlist to NSCoding repository!")
        }
        else {
            print("Successfully saved \(fileSuffix) wishlist to NSCoding repository.")
        }
    }
    
    /// Loads the specified list from the NSCoding repository into an array.
    /// - Parameters:
    ///     - list: Array of Wish objects representing the list to be saved.
    ///     - fileSuffix: String representing the name of the wishlist to be saved.
    /// - Returns: Array of Wish objects or nil
    func loadWishlist(fileSuffix: String) -> [Wish]? {
        let path = Wish.ArchiveURL.path! + "\(fileSuffix)"
        
        print("Attempting to load \(fileSuffix) wishlist from NSCoding repository at \(path)")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Wish]
    }
}

// MARK: - WishlistPersistenceDelegate Protocol

protocol WishlistPersistenceDelegate : class {
    func saveCurrentWishlistItem(wishlistItem: Wish) -> Void
    
    func saveHistoryWishlistItem(wishlistItem: Wish) -> Void
    
    func deleteCurrentWishlistItem(indexPath: NSIndexPath) -> Void
}

// MARK: - WishlistPersistenceDelegate Extension

extension WishlistViewController : WishlistPersistenceDelegate {
    
    /// Updates the currentWishlst array with the new Wish instance and initiates
    /// NSCoding Save procedure. Also updates the UITableView to display the newly
    /// added Wish instance.
    /// - Parameter wishlistItem: Wish instance that will be added to the current 
    /// wishlist.
    /// - Returns: Void
    func saveCurrentWishlistItem(wishlistItem: Wish) {
        let newIndexPath = NSIndexPath(forRow: currentWishlist.count, inSection: 0)
        currentWishlist.append(wishlistItem)
        print("Added new Wish instance to current wishlist. Reloading UITableView.")
        wishlistTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
        
        
        saveWishlist(currentWishlist, fileSuffix: "Current")
    }
    
    /// Updates the historyWishlist array with the new Wish instance and initiates
    /// NSCoding Save procedure.
    /// - Parameter wishlistItem: Wish instance that will be added to the history.
    /// - Returns: Void
    func saveHistoryWishlistItem(wishlistItem: Wish) {
        historyWishlist.append(wishlistItem)
        print("Added existing Wish instance to history wishlist.")
        saveWishlist(historyWishlist, fileSuffix: "History")
    }
    
    /// Deletes the specified Wish instance from the currentWishlist array and 
    /// associated UITableView.
    /// - Note: This function is both used internally in this class and externally 
    /// through the WishlistPersistenceDelegate to handle delete operations.
    /// - Parameter indexPath: NSIndexPath object representing the cell that the user
    /// tapped on.
    /// - Returns: - Void
    func deleteCurrentWishlistItem(indexPath: NSIndexPath) {
        currentWishlist.removeAtIndex(indexPath.row)
        print("Deleted existing Wish instance from current wishlist. Removing associated row from UITableView.")
        wishlistTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        saveWishlist(currentWishlist, fileSuffix: "Current")
    }
}
