//
//  CurrentWishTableViewCell.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/28/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

class CurrentWishTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
