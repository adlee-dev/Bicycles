//
//  Bicycle.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/23/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import Foundation
import UIKit

// Instances of this class hold all the data for a particular bicycle in the "My Bikes"
// section of the app. Also contains two inner classes, SerialNumber and PurchaseDetails,
// to represent grouped/connected properties of the Bicycle instance. All classes in
// this file implement NSCoding to allow for persistence of the underlying data.

class Bicycle : NSObject, NSCoding {
    
    // MARK: - Archiving Keys
    
    struct CodingKeys {
        static let imageKey = "image"
        static let nicknameKey = "nickname"
        static let brandKey = "brand"
        static let modelKey = "model"
        static let typeKey = "type"
        static let serialNumberKey = "serialNumber"
        static let purchaseDetailsKey = "purchaseDetails"
        static let frameSizeKey = "frameSize"
        static let frameColorKey = "frameColor"
        static let chainringsKey = "chainrings"
        static let cassetteRangeKey = "cassetteRange"
        static let cassetteSprocketCountKey = "cassetteSprocketCount"
        static let wheelSizeKey = "wheelSize"
        static let stemLengthKey = "stemLength"
    }
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("bicycles")
    
    // MARK: - Properties
    
    var image = UIImage(named: "noImage")
    var nickname: String?
    var brand: String?
    var model: String?
    var type: String?
    
    var serialNumber: SerialNumber?
    var purchaseDetails: PurchaseDetails?
    
    // some brands may have frame sizes with additional elements beyond the size in cm
    // for example, Colnago C60 comes in sloping, traditional, and high frame sizes
    // referenced as XXs, XX, and XXh respectively (where XX is the cm value for the frame)
    var frameSize: String?
    
    var frameColor: String?
    var chainrings: String?
    var cassetteRange: String?
    var cassetteSprocketCount: Int?
    
    var wheelSize: String?
    var stemLength: Int?
    
    // MARK: - NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        // integer values still use encodeObject becuase they are Int? not Int
        
        aCoder.encodeObject(image, forKey: CodingKeys.imageKey)
        aCoder.encodeObject(nickname, forKey: CodingKeys.nicknameKey)
        aCoder.encodeObject(brand, forKey: CodingKeys.brandKey)
        aCoder.encodeObject(model, forKey: CodingKeys.modelKey)
        aCoder.encodeObject(type, forKey: CodingKeys.typeKey)
        aCoder.encodeObject(serialNumber, forKey: CodingKeys.serialNumberKey)
        aCoder.encodeObject(purchaseDetails, forKey: CodingKeys.purchaseDetailsKey)
        aCoder.encodeObject(frameSize, forKey: CodingKeys.frameSizeKey)
        aCoder.encodeObject(frameColor, forKey: CodingKeys.frameColorKey)
        aCoder.encodeObject(chainrings, forKey: CodingKeys.chainringsKey)
        aCoder.encodeObject(cassetteRange, forKey: CodingKeys.cassetteRangeKey)
        aCoder.encodeObject(cassetteSprocketCount, forKey: CodingKeys.cassetteSprocketCountKey)
        aCoder.encodeObject(wheelSize, forKey: CodingKeys.wheelSizeKey)
        aCoder.encodeObject(stemLength, forKey: CodingKeys.stemLengthKey)
    }
    
    // MARK: - Initializers
    
    required convenience init?(coder aDecoder: NSCoder) {
        // initialize the object, then set properties
        self.init()
        
        image = aDecoder.decodeObjectForKey(CodingKeys.imageKey) as? UIImage
        nickname = aDecoder.decodeObjectForKey(CodingKeys.nicknameKey) as? String
        brand = aDecoder.decodeObjectForKey(CodingKeys.brandKey) as? String
        model = aDecoder.decodeObjectForKey(CodingKeys.modelKey) as? String
        type = aDecoder.decodeObjectForKey(CodingKeys.typeKey) as? String
        serialNumber = aDecoder.decodeObjectForKey(CodingKeys.serialNumberKey) as? SerialNumber
        purchaseDetails = aDecoder.decodeObjectForKey(CodingKeys.purchaseDetailsKey) as? PurchaseDetails
        frameSize = aDecoder.decodeObjectForKey(CodingKeys.frameSizeKey) as? String
        frameColor = aDecoder.decodeObjectForKey(CodingKeys.frameColorKey) as? String
        chainrings = aDecoder.decodeObjectForKey(CodingKeys.chainringsKey) as? String
        cassetteRange = aDecoder.decodeObjectForKey(CodingKeys.cassetteRangeKey) as? String
        cassetteSprocketCount = aDecoder.decodeObjectForKey(CodingKeys.cassetteSprocketCountKey) as? Int
        wheelSize = aDecoder.decodeObjectForKey(CodingKeys.wheelSizeKey) as? String
        stemLength = aDecoder.decodeObjectForKey(CodingKeys.stemLengthKey) as? Int
    }
    
    override init() {
        super.init()
    }
    
    // convenience initializer to allow for copy of an existing Bicycle instance
    convenience init(bicycle: Bicycle) {
        self.init()
        
        self.image = bicycle.image
        self.nickname = bicycle.nickname
        self.brand = bicycle.brand
        self.model = bicycle.model
        self.type = bicycle.type
        self.serialNumber = bicycle.serialNumber
        self.purchaseDetails = bicycle.purchaseDetails
        self.frameSize = bicycle.frameSize
        self.frameColor = bicycle.frameColor
        self.chainrings = bicycle.chainrings
        self.cassetteRange = bicycle.cassetteRange
        self.cassetteSprocketCount = bicycle.cassetteSprocketCount
        self.wheelSize = bicycle.wheelSize
        self.stemLength = bicycle.stemLength
    }    

    // MARK: - Inner Classes
    
    class PurchaseDetails : NSObject, NSCoding {
        
        struct CodingKeys {
            static let datePurchasedKey = "datePurchased"
            static let amountPaidKey = "amountPaid"
            static let storeNameKey = "storeName"
        }
        
        var datePurchased: NSDate?
        var amountPaid: NSDecimalNumber?
        var storeName: String?
        
        // MARK: - NSCoding
    
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(datePurchased, forKey: CodingKeys.datePurchasedKey)
            aCoder.encodeObject(amountPaid, forKey: CodingKeys.amountPaidKey)
            aCoder.encodeObject(storeName, forKey: CodingKeys.storeNameKey)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            self.init()
            
            datePurchased = aDecoder.decodeObjectForKey(CodingKeys.datePurchasedKey) as? NSDate
            amountPaid = aDecoder.decodeObjectForKey(CodingKeys.amountPaidKey) as? NSDecimalNumber
            storeName = aDecoder.decodeObjectForKey(CodingKeys.storeNameKey) as? String
        }
        
        override init() {
            super.init()
        }
    }
    
    class SerialNumber : NSObject, NSCoding {
        
        struct CodingKeys {
            static let valueKey = "value"
            static let imageKey = "image"
        }
        
        // if specificying a serial number, at minimum must have value
        var value: String
        var image: UIImage
        
        init?(value: String?, image: UIImage?) {
            // fail initialization if value is nil
            if (value == nil) {
                return nil
            }
            
            self.value = value!
            
            if let image = image {
                self.image = image
            }
            else {
                self.image = UIImage(named: "noImage")!
            }
            
            super.init()
        }
        
        // MARK: - NSCoding
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(value, forKey: CodingKeys.valueKey)
            aCoder.encodeObject(image, forKey: CodingKeys.imageKey)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            let value = aDecoder.decodeObjectForKey(CodingKeys.valueKey) as? String
            let image = aDecoder.decodeObjectForKey(CodingKeys.valueKey) as? UIImage
            
            self.init(value: value, image: image)
        }
    }
    
    
}