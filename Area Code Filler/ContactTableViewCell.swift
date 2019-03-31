//
//  ContactTableViewCell.swift
//  Area Code Filler
//
//  Created by Javon Davis on 3/30/19.
//  Copyright © 2019 Javon Davis. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
