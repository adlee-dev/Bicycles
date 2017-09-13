//
//  NewWishViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/28/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

// This class represents the view which allows the user to add a new wishlist item to
// their active wishlist.

class NewWishViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Properties
    
    var itemTitleTextField = UITextField()
    var itemDescriptionTextField = UITextField()
    var itemCategoryPicker = UIPickerView()
    var navigationBar = UINavigationBar()
    
    var pickerData = [String]()
    
    weak var delegate: WishlistPersistenceDelegate?
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBar()
        addTextFields()
        addPicker()
        
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPickerViewDelegate
    // UIPickerView implementation based on http://codewithchris.com/uipickerview-example/
    
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
    
    /// Sets properties of UITextFields instantiated earlier and adds to parent view.
    /// - Returns: Void
    func addTextFields() {
        let width = self.view.frame.width - 40
        
        let titleLabel = UILabel()
        
        titleLabel.text = "Item Name"
        titleLabel.textAlignment = .Left
        titleLabel.frame = CGRect(x: 20, y: 84, width: width, height: 21)
        
        itemTitleTextField.placeholder = "Enter the name of this item"
        itemTitleTextField.frame = CGRect(x: 20, y: 113, width: width, height: 30)
        itemTitleTextField.borderStyle = .RoundedRect
        itemTitleTextField.clearButtonMode = .WhileEditing
        itemTitleTextField.delegate = self
        
        let descriptionLabel = UILabel()
        
        descriptionLabel.text = "Item Description"
        descriptionLabel.textAlignment = .Left
        descriptionLabel.frame = CGRect(x: 20, y: 151, width: width, height: 21)
        
        itemDescriptionTextField.placeholder = "Enter a description of this item"
        itemDescriptionTextField.frame = CGRect(x: 20, y: 180, width: width, height: 30)
        itemDescriptionTextField.borderStyle = .RoundedRect
        itemDescriptionTextField.clearButtonMode = .WhileEditing
        itemDescriptionTextField.delegate = self
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(itemTitleTextField)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(itemDescriptionTextField)
    }
    
    /// Sets properties of UIPickerView instantiated earlier and adds to parent view.
    /// - Returns: Void
    func addPicker() {
        // add the categories to the picker data array
        populatePickerData()
        
        // set the delegate and datasource properties
        self.itemCategoryPicker.delegate = self
        self.itemCategoryPicker.dataSource = self
        
        // set the dimensions of the picker and place it in view
        let width = self.view.frame.width - 40
        
        let pickerLabel = UILabel()
        
        pickerLabel.text = "Item Category"
        pickerLabel.textAlignment = .Left
        pickerLabel.frame = CGRect(x: 20, y: 218, width: width, height: 21)
    
        itemCategoryPicker.frame = CGRect(x: 20, y: 247, width: width, height: 120)
        
        self.view.addSubview(pickerLabel)
        self.view.addSubview(itemCategoryPicker)
    }
    
    // creation of UIBarButtonItems based on http://stackoverflow.com/a/24641521/3113924
    
    /// Instantiates a UINavigationItem and and sets properties of previously
    /// instantiated UINaviationBar and adds them to parent view.
    /// Returns: - Void
    func addNavigationBar() {
        let navigationItem = UINavigationItem()

        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(cancelNewWish)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: #selector(saveNewWish)
        )
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "New Wishlist Item"
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
    }
    
    /// Iterates through cases of Wish.ItemCategory enum and assigns to UIPickerView
    /// data source.
    /// - Returns: Void
    func populatePickerData() {
        for category in Wish.ItemCategory.values {
            pickerData.append(category.rawValue)
        }
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
    
    /// Cancel action for the Cancel button in this view. Does not pass the new Wish
    /// instance to the current wishlist.
    /// - Returns: Void
    func cancelNewWish() {
        print("Cancel button pressed. Transitioning to WishlistViewController. No changes made to current wishlist Array.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Sends data entered by user to WishlistViewController to save to current wishlist.
    /// Validates that the user has entered valid data into the itemTitleTextField control
    /// before continuing with save operation.
    /// - Returns: Void
    func saveNewWish() {
        //
        guard let itemTitle = itemTitleTextField.text where !itemTitle.isEmpty else {
            // display alert informing user that itemTitle must have data
        
            let title = "Item Title required!"
            let message = "You must enter a valid title for this item before attempting to add it to your wishlist"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            print("itemTitle property is empty or nil. This property must have a value.")
        
            return
        }
        
        let itemDescription = itemDescriptionTextField.text
        let pickerSelection = itemCategoryPicker.selectedRowInComponent(0)
        let category = Wish.ItemCategory(rawValue: pickerData[pickerSelection])
        
        let wish = Wish(itemTitle: itemTitle, itemDescription: itemDescription, category: category!)
        
        delegate?.saveCurrentWishlistItem(wish)
        
        print("Save button pressed. Transitioning back to WishlistViewController. New Wish instance added to current wishlist.")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
