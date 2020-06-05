//
//  ViewController.swift
//  foodDelivery
//
//  Created by apple on 5/29/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var defaults:UserDefaults!

    override func viewDidLoad() {
        self.defaults = UserDefaults.standard
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    //MARK: ACTIONS
    
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        var message = ""
        
        
        // testing
        if(txtEmail.text! == "" || txtPassword.text! == ""){
            message = "Please fill required information"
            showAlertboax(title: "Error", message: "Please fill required information")
        }else{
            
            var customer = DatabaseController.instance.checkLogin(email: txtEmail.text!, password:  txtPassword.text!)
            
            if(customer.count != 0){
                for customerData in customer{
                    if(customerData.customer_email == txtEmail.text! && customerData.customer_password == txtPassword.text!){
                        print("Customer Found On Sign iN and Good to go")
                        self.defaults.set(txtEmail.text!, forKey: "username")
                        self.defaults.set(txtPassword.text!, forKey: "password")
                        txtEmail.text = ""
                        txtPassword.text = ""
                        performSegue(withIdentifier: "mealPackageViewController", sender: self)
                        
                    }
                }
            }
            else{
                 showAlertboax(title: "Error", message: "User does not exists")
                print("We Dont have that customer")
                
            }
            
            
        }
        
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        print("Create Button Pressed")
        performSegue(withIdentifier: "signUpViewController", sender: self)
        
    }
    
    func showAlertboax(title:String, message:String){
        let box = UIAlertController(
            title: "\(title)",
            message: "\(message)",
            preferredStyle: .alert
        )
        
        box.addAction(
            UIAlertAction(title: "OK", style: .default, handler: {action in
                // self.performSegue(withIdentifier: "signInPage", sender: self)
            })
        )
        self.present(box, animated: true)
        
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    

}

