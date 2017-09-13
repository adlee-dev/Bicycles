//
//  MoveWishToHistoryViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/29/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class represents the view which allows the user to add relevant details to an
// existing Wish instance in the current wishlist before moving it to the history
// wishlist.

class MoveWishToHistoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    var acquireMethodPicker = UIPickerView()
    var navigationBar = UINavigationBar()
    var dateAcquiredPicker = UIDatePicker()
    
    var pickerData = [String]()

    weak var delegate: WishlistPersistenceDelegate?
    let indexPath: NSIndexPath
    var wish: Wish
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationBar()
        addMethodPicker()
        addDateAcquiredPicker()
        
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
    
    init(indexPath: NSIndexPath, wish: Wish) {
        self.indexPath = indexPath
        self.wish = wish
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPickerViewDelegate
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // MARK: - Controls
    
    /// Sets properties of UIPickerView instantiated earlier and adds to parent view.
    /// - Returns: Void
    func addMethodPicker() {
        // add the categories to the picker data array
        populatePickerData()
        
        // set the delegate and datasource properties
        self.acquireMethodPicker.delegate = self
        self.acquireMethodPicker.dataSource = self
        
        // set the dimensions of the picker and place it in view
        let width = self.view.frame.width - 40
        
        let pickerLabel = UILabel()
        
        pickerLabel.text = "How did you get this item?"
        pickerLabel.textAlignment = .Left
        pickerLabel.frame = CGRect(x: 20, y: 84, width: width, height: 21)
        
        acquireMethodPicker.frame = CGRect(x: 20, y: 113, width: width, height: 120)
        
        self.view.addSubview(pickerLabel)
        self.view.addSubview(acquireMethodPicker)
    }
    
    /// Sets properties of UIDatePicker instantiated earlier and adds to paren view.
    /// - Returns: Void
    func addDateAcquiredPicker() {
        // set properties of date picker
        dateAcquiredPicker.maximumDate = NSDate()
        dateAcquiredPicker.datePickerMode = .Date
        
        // set dimensions of the picker and place in view
        let width = self.view.frame.width - 40
        
        let datePickerLabel = UILabel()
        
        datePickerLabel.text = "When did you get this item?"
        datePickerLabel.textAlignment = .Left
        datePickerLabel.frame = CGRect(x: 20, y: 241, width: width, height: 21)
        
        dateAcquiredPicker.frame = CGRect(x: 20, y: 270, width: width, height: 200)
        
        self.view.addSubview(datePickerLabel)
        self.view.addSubview(dateAcquiredPicker)
    }
    
    /// Instantiates a UINavigationItem and and sets properties of previously
    /// instantiated UINaviationBar and adds them to parent view.
    /// Returns: - Void
    func addNavigationBar() {
        // creation of UIBarButtonItems based on http://stackoverflow.com/a/24641521/3113924
        let navigationItem = UINavigationItem()
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(cancelWishMove)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: #selector(saveWishMove)
        )
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "Move To History"
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
    }
    
    /// Iterates through cases of Wish.AcquireMethod enum and assigns to UIPickerView
    /// data source.
    /// - Returns: Void
    func populatePickerData() {
        for method in Wish.AcquireMethod.values {
            pickerData.append(method.rawValue)
        }
    }
    
    // MARK: - Actions
    
    /// Cancel action for the Cancel button in this view. Does not move the specified
    /// Wish instance to the history wishlist.
    /// - Returns: Void
    func cancelWishMove() {
        print("Cancel button pressed. Transitioning to WishlistViewController. No changes made to current wishlist or history wishlist Arrays.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Save action for the Save Button in this view. Updates the dateAcquired and 
    /// acquireMethod properties of the particular Wish instance. The updated Wish is
    /// saved to the history wishlist and then deleted from the current wishlist.
    /// This view is then dismissed and control is returned to WishlistViewController.
    /// - Returns: Void
    func saveWishMove() {
        let pickerSelection = acquireMethodPicker.selectedRowInComponent(0)
        let method = Wish.AcquireMethod(rawValue: pickerData[pickerSelection])
        
        wish.dateAcquired = dateAcquiredPicker.date
        wish.acquireMethod = method
        
        delegate?.saveHistoryWishlistItem(wish)
        delegate?.deleteCurrentWishlistItem(indexPath)
        
        print("Save button pressed. Transitioning back to WishlistViewController. Updated Wish instance added to history wishlist and removed from current wishlist.")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
