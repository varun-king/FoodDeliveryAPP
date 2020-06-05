//
//  Customer+CoreDataProperties.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var customer_email: String?
    @NSManaged public var customer_image: NSData?
    @NSManaged public var customer_password: String?
    @NSManaged public var customer_phone: String?
    @NSManaged public var cutomerHasOrder: NSSet?

}

// MARK: Generated accessors for cutomerHasOrder
extension Customer {

    @objc(addCutomerHasOrderObject:)
    @NSManaged public func addToCutomerHasOrder(_ value: OrderData)

    @objc(removeCutomerHasOrderObject:)
    @NSManaged public func removeFromCutomerHasOrder(_ value: OrderData)

    @objc(addCutomerHasOrder:)
    @NSManaged public func addToCutomerHasOrder(_ values: NSSet)

    @objc(removeCutomerHasOrder:)
    @NSManaged public func removeFromCutomerHasOrder(_ values: NSSet)

}
