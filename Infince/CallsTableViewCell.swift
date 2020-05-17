//
//  CallsTableViewCell.swift
//  Infince
//
//  Created by Habeeb Rahman on 17/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit

class CallsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
