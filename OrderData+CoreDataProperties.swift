//
//  OrderData+CoreDataProperties.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderData> {
        return NSFetchRequest<OrderData>(entityName: "OrderData")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var subtotal: Double
    @NSManaged public var tax: Double
    @NSManaged public var tip: Double
    @NSManaged public var discount: Double
    @NSManaged public var foodOtions: FoodMenu?
    @NSManaged public var orderCutomer: Customer?

}
