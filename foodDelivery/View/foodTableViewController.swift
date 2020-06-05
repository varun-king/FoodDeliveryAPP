//
//  foodTableViewController.swift
//  foodDelivery
//
//  Created by apple on 5/30/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit

extension String {
    
    static func random(length: Int = 6) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

class foodTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var defaults:UserDefaults!
    // MARK: Outlets
    @IBOutlet weak var foodTabelView: UITableView!
    // MARK: Variables
    var menuData:[MenuStruct] = []
    var foodOptions:[FoodMenu] = []
    var reward_point = 0
    var reward:[String] = []
    var off = 0
    
        
        override func viewDidLoad() {
            reward_point = 0
             self.defaults = UserDefaults.standard
            
            foodTabelView.delegate = self
            foodTabelView.dataSource = self
            
            // load the json file here
            guard let file = openFile() else { return }
            
            // load words from file into data source
            menuData = self.getData(from: file)!
            
            //Check for blank Database
            
            let resultConts = DatabaseController.instance.foodDatabaseCheck()
         //   var resultCounts = DatabaseController.instance.giveDataBackTo()
            
            if(resultConts < 5){
                for i in 0 ..<  menuData.count{
                    
                    let message = DatabaseController.instance.saveFoodMenuToCoreData(sku: menuData[i].sku, name: menuData[i].name, desc: menuData[i].description, img: menuData[i].photo, price: menuData[i].price, caloie: menuData[i].calorie)
                    print("Menu Item Stored in Data : \(message)")
                }
            }
            foodOptions = DatabaseController.instance.giveDataBackTo()
            super.viewDidLoad()
        }
        
        func openDefaultFile()-> String? {
            guard let file = Bundle.main.path(forResource:"MenuDetail", ofType:"json") else {
                print("Cannot find file")
                return nil;
            }
            print("File found: \(file.description)")
            return file
        }
        
        
        func openFile() -> String? {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let finalPath = paths[0]
            
            let filename = finalPath.appendingPathComponent("MenuDetail.json")
            
            // check if file exists
            let fileExists = FileManager().fileExists(atPath: filename.path)
            
            if (fileExists == true) {
                // load words from saved file
                return filename.path;
            }
            else {
                // open words from default file
                return self.openDefaultFile()
            }
            return nil
        }
        
        func getData(from file:String?) -> [MenuStruct]? {
            if (file == nil) {
                print("File path is null")
                return nil
            }
            do {
                // open the file
                let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
                print(jsonData)         // outputs: Optional(749Bytes)
                
                // get content of file
                let decodedData =
                    try JSONDecoder().decode([MenuStruct].self, from: jsonData!)
                
                // DEBUG: print file contents to screen
                dump(decodedData)
                
                return decodedData
            } catch {
                print("Error while parsing file")
                print(error.localizedDescription)
            }
            return nil
        }
    
        //Get Reward FUnction
    
    @IBAction func getRewardButtonPressed(_ sender: Any) {
        
        let box = UIAlertController(
            title: "Want Reward",
            message: "To get Reward you have to shake your device three times",
            preferredStyle: .alert
        )
        box.addAction(
            UIAlertAction(title: "No", style: .default, handler: nil)
        )
        box.addAction(
            UIAlertAction(title: "Yes", style: .default, handler: nil)
        )
       
        
        // show alert box
        self.present(box, animated: true)
      
        
    }
    
    
    @IBAction func orderHistoryButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "orderHistoryController", sender: self)
    }
    //orderHistoryController
    
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("Device is shaking")
      //  result.text = result.text + "Device is Shaking \n"
        //
        self.reward_point = self.reward_point + 1
        var randomString = ""
        if(self.reward_point == 3){
            repeat{
                randomString = String.random()
            } while(self.reward.contains(randomString))
           
            
            func randomNumber(probabilities: [Double]) -> Int {
                
                // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
                let sum = probabilities.reduce(0, +)
                // Random number in the range 0.0 <= rnd < sum :
                let rnd = Double.random(in: 0.0 ..< sum)
                // Find the first interval of accumulated probabilities into which `rnd` falls:
                var accum = 0.0
                for (i, p) in probabilities.enumerated() {
                    accum += p
                    if rnd < accum {
                        return i
                    }
                }
                // This point might be reached due to floating point inaccuracies:
                return (probabilities.count - 1)
            }
            var message = ""
            let x = randomNumber(probabilities: [0.65, 0.3, 0.05])
            print("x is \(x)")
             if(x == 2){
                off = 10
                message = "Congrats, you won 10 % off"
            }
            else if(x == 3){
                off = 50
                message = "Congrats, you won 50 % off"
            }else{
                off = 0
                message = "Sorry you don't win reward"
                
            }
            
            
          //  addCoupon
            let box = UIAlertController(
                title: "Coupon",
                message: "\(message)",
                preferredStyle: .alert
            )
          /*  box.addAction(
                UIAlertAction(title: "No", style: .default, handler:
                    {
                        action in
                        self.reward_point = 0
                })
            )*/
            
            box.addAction(
                UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    self.reward_point = 0
                    self.reward.append(randomString)
                    let username = self.defaults.string(forKey: "username")
                    print("Random \(randomString) \n mail \( username!) \n off \(self.off) \n ")
                    if(self.off > 0){
                    DatabaseController.instance.addCoupon(coupon: randomString, mail: username!, used: false, percentage: self.off)
                    }
                })
            )
            
            // show alert box
            self.present(box, animated: true)
        }
        
      //  let color = [UIColor.white, UIColor.red, UIColor.green, UIColor.yellow, UIColor.cyan, UIColor.magenta, UIColor.purple]
      //  let number = Int.random(in: 0 ..< color.count)
      //  self.view.backgroundColor = color[number]
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("Device stop shaking")
       // self.view.backgroundColor = UIColor.white
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return foodOptions.count
        }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = foodTabelView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
            
            cell.txtFoodName.text = foodOptions[indexPath.row].meal_name!
            cell.txtFoodDescr.text = foodOptions[indexPath.row].meal_description!
            cell.txtFoodPrice.text = String(foodOptions[indexPath.row].meal_price)
            cell.txtFoodCalorie.text = String(foodOptions[indexPath.row].meal_calorie)
            cell.txtFoodImage.image = UIImage(named: "\(foodOptions[indexPath.row].meal_photo!).jpg")
            
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
       
        self.defaults.set(foodOptions[indexPath.row].meal_name!, forKey: "foodName")
        self.defaults.set(foodOptions[indexPath.row].meal_description!, forKey: "foodDesc")
         self.defaults.set(foodOptions[indexPath.row].meal_photo!, forKey: "foodImg")
        self.defaults.set(foodOptions[indexPath.row].meal_price, forKey: "foodPrice")
        self.defaults.set(foodOptions[indexPath.row].meal_calorie, forKey: "foodCalorie")
         self.defaults.set(foodOptions[indexPath.row].meal_sku!, forKey: "foodSku")
       // self.navigationController?.pushViewController(PatientNumber_priority, animated: true)
        performSegue(withIdentifier: "OrderViewController", sender: self)
        
    }
        
        
        
    }

    
    


