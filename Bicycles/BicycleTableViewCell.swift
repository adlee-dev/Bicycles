//
//  BicycleTableViewCell.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/24/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit

class BicycleTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var bicycleImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
