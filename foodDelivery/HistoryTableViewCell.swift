//
//  HistoryTableViewCell.swift
//  foodDelivery
//
//  Created by apple on 5/31/20.
//  Copyright © 2020 varun. All rights reserved. 
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var txtImage: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
