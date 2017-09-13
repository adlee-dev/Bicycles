//
//  Wish.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/28/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import Foundation

// Instances of this class represent a wishlist item in either the current or
// history wishlists of the Wishlist tab in the app. Contains two enums, AcquireMethod
// and ItemCategory, to restrict the possible values assignable to the associated
// instance properties. Implements NSCoding to allow for persistence of underlying data.

class Wish : NSObject, NSCoding {
    
    // iterating over enums is apparently not supported by default, requiring
    // custom implementation; simplest I found at http://www.swift-studies.com/blog/2014/6/10/enumerating-enums-in-swift
    // though there are others:
    // http://natecook.com/blog/2014/10/loopy-random-enum-ideas/
    
    // MARK: - Archiving Keys
    
    struct CodingKeys {
        static let itemTitleKey = "itemTitle"
        static let itemDescriptionKey = "itemDescription"
        static let categoryKey = "category"
        static let dateAddedKey = "dateAdded"
        static let dateAcquiredKey = "dateAcquired"
        static let acquireMethodKey = "acquireMethod"
    }
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("wishlist")
    
    // MARK: - Enums
    
    enum AcquireMethod: String {
        case Purchase = "Purchase"
        case Gift = "Gift"
        case DIY = "DIY"
        case Other = "Other"
        
        static let values = [Purchase, Gift, DIY, Other]
    }
    
    enum ItemCategory: String {
        case Bicycle = "Bicycle"
        case Component = "Component"
        case Clothing = "Clothing"
        case Shoes = "Shoes"
        case Other = "Other"
        
        static let values = [Bicycle, Component, Clothing, Shoes, Other]
    }
    
    // MARK: - Properties
    
    var itemTitle: String
    var itemDescription: String?
    var category: ItemCategory
    var dateAdded = NSDate()
    var dateAcquired: NSDate?
    var acquireMethod: AcquireMethod?
    
    // MARK: - Initializers
    
    init(itemTitle: String, itemDescription: String?, category: ItemCategory) {
        self.itemTitle = itemTitle
        self.itemDescription = itemDescription
        self.category = category
        
        super.init()
    }
    
    // MARK: - NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let itemTitle = aDecoder.decodeObjectForKey(CodingKeys.itemTitleKey) as! String
        let itemDescription = aDecoder.decodeObjectForKey(CodingKeys.itemDescriptionKey) as! String
        let categoryRawValue = aDecoder.decodeObjectForKey(CodingKeys.categoryKey) as! String
        let category = ItemCategory(rawValue: categoryRawValue)
        
        self.init(itemTitle: itemTitle, itemDescription: itemDescription, category: category!)
        
        self.dateAdded = aDecoder.decodeObjectForKey(CodingKeys.dateAddedKey) as! NSDate
        self.dateAcquired = aDecoder.decodeObjectForKey(CodingKeys.dateAcquiredKey) as? NSDate
        if let methodRawValue = aDecoder.decodeObjectForKey(CodingKeys.acquireMethodKey) as? String {
            self.acquireMethod = AcquireMethod(rawValue: methodRawValue)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(itemTitle, forKey: CodingKeys.itemTitleKey)
        aCoder.encodeObject(itemDescription, forKey: CodingKeys.itemDescriptionKey)
        aCoder.encodeObject(category.rawValue, forKey: CodingKeys.categoryKey)
        aCoder.encodeObject(dateAdded, forKey: CodingKeys.dateAddedKey)
        aCoder.encodeObject(dateAcquired, forKey: CodingKeys.dateAcquiredKey)
        aCoder.encodeObject(acquireMethod?.rawValue, forKey: CodingKeys.acquireMethodKey)
    }
    
}