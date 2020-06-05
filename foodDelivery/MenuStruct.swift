//
//  MenuStruct.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//

import Foundation

struct MenuStruct:Codable {
    
    var sku:String = ""
    var name:String = ""
    var description:String = ""
    var photo:String = ""
    var price:Double = 0.0
    var calorie:Int = 0
    
    init() {}
}
