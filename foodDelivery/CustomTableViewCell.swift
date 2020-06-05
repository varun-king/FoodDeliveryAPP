//
//  CustomTableViewCell.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var txtFoodImage: UIImageView!
    @IBOutlet weak var txtFoodName: UILabel!
    @IBOutlet weak var txtFoodCalorie: UILabel!
    @IBOutlet weak var txtFoodPrice: UILabel!
    @IBOutlet weak var txtFoodDescr: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
