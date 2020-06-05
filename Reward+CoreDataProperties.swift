//
//  Reward+CoreDataProperties.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//
//

import Foundation
import CoreData


extension Reward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reward> {
        return NSFetchRequest<Reward>(entityName: "Reward")
    }

    @NSManaged public var user_email: String?
    @NSManaged public var isUsed: Bool
    @NSManaged public var coupon: String?
    @NSManaged public var per_off: Int16

}
