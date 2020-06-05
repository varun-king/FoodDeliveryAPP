//
//  DatabaseController.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseController{
    
    static let instance = DatabaseController()
    
    let database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   // let  database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func signUp(password:String, email:String, phone:String, image:NSData) -> String {
        var message = ""
        let customer  = Customer(context:database)
        customer.customer_password = password
        customer.customer_email = email
        customer.customer_phone = phone
        customer.customer_image = image
        
        // save to the database
        do {
            try database.save()
            message = "User Create Successfully"
        }
        catch {
            //   print("error!")
            message = "\(error)"
        }
        return message
    }
    
    func checkLogin(email:String, password:String) -> [Customer]{
        var customer:[Customer] = [Customer]()
        
        let request : NSFetchRequest<Customer> = Customer.fetchRequest()
        let query = NSPredicate(format: "customer_email == %@", "\(email)")
        request.predicate = query
        
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                print("no results found")
            }
            else {
                customer = results
                // print each user
                print("sign IN")
                for user in results {
                    print(user.customer_email!)
                }
            }
        }catch{
            //message = "\(error)"
            print("Error in signIn : \(error)")
        }
        return customer
    }
    
    
    func checkUserExist(email:String) -> [Customer]{
        var customer:[Customer] = [Customer]()
        
        let request : NSFetchRequest<Customer> = Customer.fetchRequest()
        let query = NSPredicate(format: "customer_email == %@", "\(email)")
        request.predicate = query
        
        do {
            let results = try database.fetch(request)
             customer = results
            print("Hey you are here")
           
        }catch{
            //message = "\(error)"
            print("Error in signIn : \(error)")
        }
        return customer
    }
    
    
    
    func saveFoodMenuToCoreData(sku:String, name:String, desc:String, img:String, price:Double, caloie:Int) -> String{
        var message = ""
        let food_menu  = FoodMenu(context:database)
        food_menu.meal_name = name
        food_menu.meal_sku = sku
        food_menu.meal_description = desc
        food_menu.meal_photo = img
        food_menu.meal_price = price
        food_menu.meal_calorie = Int16(caloie)
       
        // save to the database
        do {
            try database.save()
            message = "Save Successfully"
        }
        catch {
            print("error!")
            message = "\(error)"
        }
        return message
    }
    
    
    func foodDatabaseCheck() -> Int {
        var food:[FoodMenu] = [FoodMenu]()
        var value = 0
        let request : NSFetchRequest<FoodMenu> = FoodMenu.fetchRequest()
    //    let query = NSPredicate(format: "customer_email == %@", "\(email)")
     //   request.predicate = query
        
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                print("no results found")
                value = 0
            }
            else {
                
                // print each user
                print("sign IN")
                for user in results {
                    print(user.meal_photo!)
                }
                value = results.count
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Food : \(error)")
        }
        return value
    }
    
    
    func giveDataBackTo() -> [FoodMenu] {
        print("We are in func giveDataBackTo ")
        var food:[FoodMenu] = [FoodMenu]()
        let request : NSFetchRequest<FoodMenu> = FoodMenu.fetchRequest()
        //    let query = NSPredicate(format: "customer_email == %@", "\(email)")
        //   request.predicate = query
        
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                print("no results found")
               
            }
            else {
                food = results
                // print each user
               // print("sign IN")
                 print("IN else Found Result \(food)")
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Food : \(error)")
        }
        return food
    }
    
    
    
    //MARK: Add Coupon
    func addCoupon(coupon:String, mail:String, used:Bool, percentage:Int) -> String{
        var message = ""
        let reward_coupon  = Reward(context:database)
        reward_coupon.coupon = coupon
        reward_coupon.user_email = mail
        reward_coupon.per_off = Int16(percentage)
        reward_coupon.isUsed = false
        // save to the database
        do {
            try database.save()
            message = "You won Coupon"
        }
        catch {
            print("error!")
            message = "\(error)"
        }
        return message
    }
    
    //Display all Unused Coupon to user
    func getAllUnUsedCoupon(user:String) -> [String]{
        var couponArray:[String] = [String]()
        couponArray.append(" ")
        let request : NSFetchRequest<Reward> = Reward.fetchRequest()
        let query = NSPredicate(format: "user_email == %@", "\(user)")
        request.predicate = query
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                // print("no results found")
              //  message = "In Validate Coupon"
            }
            else {
               
                for user in results {
                    if(user.isUsed == false){
                        couponArray.append(user.coupon!)
                    }else {
                        print("No Coupon")
                    }
                }
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Coupon : \(error)")
        }
        
        return couponArray
    }
    
    //MARK: ValidationOfCoupon
    
    func validateCoupon(user:String, coupon:String) -> (off:Int,message:String) {
        var message = ""
        var off = 0
        print("We are in func validateCoupon ")
        var validaCop:[Reward] = [Reward]()
        let request : NSFetchRequest<Reward> = Reward.fetchRequest()
        let query = NSPredicate(format: "user_email == %@", "\(user)")
        request.predicate = query
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
               // print("no results found")
                message = "In Validate Coupon"
            }
            else {
                validaCop = results
                for user in results {
                    if(user.isUsed == false && user.coupon == coupon){
                        print("Is Used: \(user.isUsed)")
                        print("Coupon is \(coupon)")
                        message = "Successfully Applied"
                        off = Int(user.per_off)
                        print("Coupon Value: \(Int(user.per_off))")
                    } else if(user.isUsed == true && user.coupon == coupon){
                        print("Coupon is \(coupon)")
                        message = "Already Applied"
                        off = 0
                    }
                }
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Coupon : \(error)")
        }
         return (off,message)
    }
    
    //Update Coupon Usage
    func updateRewardCouponForthisUser(user:String, coupon:String){
        var validaCop:[Reward] = [Reward]()
        let request : NSFetchRequest<Reward> = Reward.fetchRequest()
        let query = NSPredicate(format: "user_email == %@", "\(user)")
        request.predicate = query
        let query2 = NSPredicate(format: "coupon == %@", "\(coupon)")
        request.predicate = query2
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                // print("no results found")
                //message = "In Validate Coupon"
            }
            else {
                validaCop = results
                
                
                let people = validaCop[0] as NSManagedObject
                
                //let person = NSManagedObject(entity: entity, insertInto: managedContext)
                
                people.setValue(true, forKeyPath: "isUsed")
                           //save the context
                do {
                    try database.save()
                    print("saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Coupon : \(error)")
        }
    }
    
    
    func saveOrderToDatabase(date:Date, subtotal:Double, taxD:Double, tipD:Double, discountD:Double, food_menu:FoodMenu, customerData:Customer){
        var message = ""
        let orderData  = OrderData(context:database)
        orderData.date = date as NSDate
        orderData.discount = discountD
        orderData.tax = taxD
        orderData.tip = tipD
        orderData.subtotal = subtotal
        orderData.foodOtions = food_menu
        orderData.orderCutomer = customerData
        // save to the database
        do {
            try database.save()
            message = "You won Coupon"
            print("Order Data Added to Data Base")
        }
        catch {
            print("error!")
            message = "\(error)"
        }
    }
    
    
    func foodObject(sku:String) -> [FoodMenu]{
        var foodOBJ:[FoodMenu] = [FoodMenu]()
        let request : NSFetchRequest<FoodMenu> = FoodMenu.fetchRequest()
        let query = NSPredicate(format: "meal_sku == %@", "\(sku)")
        request.predicate = query
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                print("no results found")
            }
            else {
                foodOBJ = results
                // print each user
                // print("sign IN")
               // print("IN else Found Result \(food)")
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Food : \(error)")
        }
        return foodOBJ
        
    }
    
    func getOrderHistory(userEmail:String) -> [OrderData] {
        var returnType:[OrderData] = [OrderData]()
        let request : NSFetchRequest<OrderData> = OrderData.fetchRequest()
       
      
        do {
            let results = try database.fetch(request)
            if results.count == 0 {
                print("no results found")
            }
            else {
               // returnType = results
                for order in results{
                    if(order.orderCutomer?.customer_email == userEmail){
                        returnType.append(order)
                    }
                }
             
                // print each user
                // print("sign IN")
                // print("IN else Found Result \(food)")
            }
        }catch{
            //message = "\(error)"
            print("Error in Finding Food : \(error)")
        }
        return returnType
        
    }
    
    
    //FInal CLose
}
