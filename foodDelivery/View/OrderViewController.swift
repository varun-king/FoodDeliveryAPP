//
//  OrderViewController.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var username = ""
    var password = ""
    var price = 0.0
    var defaults:UserDefaults!
    var tip = 0
    var percentageOff = 0
    var sku = ""
    var selectedDay =  ""
    
    //MARK: Outlets
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var txtFoodName: UILabel!
    @IBOutlet weak var txtFoodPrice: UILabel!
    @IBOutlet weak var txtFoodDesc: UITextView!
    @IBOutlet weak var txtCouponMessage: UILabel!
    
    
    @IBOutlet weak var txtCoupon: UITextField!
    @IBOutlet weak var txtTip: UITextField!
    
    var couponArry:[String] = [String]()
    let couponTypePikerView = UIPickerView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaults = UserDefaults.standard
        
        let name = self.defaults.string(forKey: "foodName")
        let desc = self.defaults.string(forKey: "foodDesc")
        let photo = self.defaults.string(forKey: "foodImg")
        sku = self.defaults.string(forKey: "foodSku")!
        price = self.defaults.double(forKey: "foodPrice")
        let calorie = self.defaults.integer(forKey: "foodCalorie")
        username = self.defaults.string(forKey: "username")!
        password = self.defaults.string(forKey: "password")!
        // get the age
        
        foodImg.image = UIImage(named: "\(photo!).jpg")
        txtFoodName.text = name!
        txtFoodDesc.text = desc!
        txtFoodPrice.text = String(price)
    
        couponArry = DatabaseController.instance.getAllUnUsedCoupon(user: username)
        
        
        self.couponTypePikerView.delegate = self
        txtCoupon.inputView =  couponTypePikerView
        self.couponTypePikerView.reloadAllComponents()
        createToolbar()
        
        print("name: \(name!) \n desc: \(desc!) \n photo: \(photo!) \n sku: \(sku) \n price: \(price) \n calorie: \(calorie) \n username: \(username) \n password: \(password) \n")
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        self.couponTypePikerView.reloadAllComponents()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard
            ))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtCoupon.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return couponArry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return couponArry[row]
    }
    // To hidePikerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = couponArry[row]
        txtCoupon.text = selectedDay
        
    }
    
    
    
    @IBAction func addTipButtonPressed(_ sender: Any) {
        tip = Int(txtTip.text!) ?? 0
    }
    
    @IBAction func tip10(_ sender: Any) {
        tip = 10
        txtTip.text = "10%"
    }
    
    @IBAction func tip15(_ sender: Any) {
        tip = 15
        txtTip.text = "15%"
    }
    
    @IBAction func tip20(_ sender: Any) {
        tip =  20
        txtTip.text = "20%"
    }
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        let user = username
        let coupon = txtCoupon.text!
        
        if(coupon != "" || user != ""){
            let check = DatabaseController.instance.validateCoupon(user: user, coupon: coupon )
            txtCouponMessage.text = "\(check.message)"
            self.percentageOff = check.off
             DatabaseController.instance.updateRewardCouponForthisUser(user: user, coupon: coupon)
            
            
        }
        
    }
    
    
    
    @IBAction func placeOrderButtonPreesed(_ sender: Any) {
        let date = NSDate()
         var tipMoney = 0.0
        var discount = 0.0
        print("Tip \(tip)")
        if(tip != 0){
          tipMoney  = price * (Double(tip)/100.0)
        print("Tip \(tipMoney)")
        }
        if(self.percentageOff != 0){
            discount = price * Double(self.percentageOff) / 100.0
        }
        let tax = (price + tipMoney + discount) * 0.13
        let subtotal = price + tipMoney - discount + tax
        
        self.defaults.set(subtotal, forKey: "ordSubtotal")
        self.defaults.set(discount, forKey: "ordDiscont")
        self.defaults.set(tax, forKey: "ordTax")
        self.defaults.set(tipMoney, forKey: "ordTip")
         self.defaults.set(date, forKey: "ordDate")
        
        var customerInfo = DatabaseController.instance.checkLogin(email: username, password: password)
        
        var foodObje = DatabaseController.instance.foodObject(sku: sku)
        
        DatabaseController.instance.saveOrderToDatabase(date: date as Date, subtotal: subtotal, taxD: tax, tipD: tipMoney, discountD: discount, food_menu: foodObje[0], customerData: customerInfo[0])
        
        performSegue(withIdentifier: "receiptViewController", sender: self)
        
        
        
        
    }
    

}
