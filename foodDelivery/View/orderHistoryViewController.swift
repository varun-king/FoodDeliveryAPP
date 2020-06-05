//
//  orderHistoryViewController.swift
//  foodDelivery
//
//  Created by apple on 5/29/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit

class orderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var orderHistory:[OrderData] = [OrderData]()
    var defaults:UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaults = UserDefaults.standard
        
        print("You are in History")
        orderHistory = DatabaseController.instance.getOrderHistory(userEmail: "\(self.defaults.string(forKey: "username")!)")
         print("\(orderHistory)")
        for order  in orderHistory{
            print("Food Name: \((order.foodOtions?.meal_name!)!)")
             print("Customer Name: \((order.orderCutomer?.customer_email!)!)")
        }
        
        
    self.historyTableView.delegate = self
    self.historyTableView.dataSource = self
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "myCell") as! HistoryTableViewCell
        
        let date_time = orderHistory[indexPath.row].date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd  hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString = formatter.string(from: date_time! as Date)
        
        cell.txtName.text = "\((orderHistory[indexPath.row].foodOtions?.meal_name!)!)"
        cell.txtImage.image = UIImage(named: "\((orderHistory[indexPath.row].foodOtions?.meal_photo!)!)")
        cell.txtDate.text = "\(dateString)"
        
        
        
        return cell
    }
    
  

}
