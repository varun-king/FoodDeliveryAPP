//
//  FoodMenu+CoreDataProperties.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodMenu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodMenu> {
        return NSFetchRequest<FoodMenu>(entityName: "FoodMenu")
    }

    @NSManaged public var meal_calorie: Int16
    @NSManaged public var meal_description: String?
    @NSManaged public var meal_name: String?
    @NSManaged public var meal_photo: String?
    @NSManaged public var meal_price: Double
    @NSManaged public var meal_sku: String?
    @NSManaged public var orderIn: NSSet?

}

// MARK: Generated accessors for orderIn
extension FoodMenu {

    @objc(addOrderInObject:)
    @NSManaged public func addToOrderIn(_ value: OrderData)

    @objc(removeOrderInObject:)
    @NSManaged public func removeFromOrderIn(_ value: OrderData)

    @objc(addOrderIn:)
    @NSManaged public func addToOrderIn(_ values: NSSet)

    @objc(removeOrderIn:)
    @NSManaged public func removeFromOrderIn(_ values: NSSet)

}
