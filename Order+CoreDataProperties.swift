//
//  Order+CoreDataProperties.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var subtotal: Double
    @NSManaged public var total: Double
    @NSManaged public var tax: Double
    @NSManaged public var discount: Double
    @NSManaged public var tip: Double

}
