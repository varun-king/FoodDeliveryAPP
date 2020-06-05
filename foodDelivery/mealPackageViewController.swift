//
//  mealPackageViewController.swift
//  foodDelivery
//
//  Created by apple on 5/29/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit
import CoreData

class mealPackageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    // MARK: Outlets
    @IBOutlet weak var foodTabelView: UITableView!
    // MARK: Variables
    var menuData:[MenuStruct] = []
    var foodOptions:[FoodMenu] = []

    override func viewDidLoad() {
    
        foodTabelView.delegate = self
        foodTabelView.dataSource = self
       
       
        // load the json file here
        guard let file = openFile() else { return }
       

        // load words from file into data source
        menuData = self.getData(from: file)!
        
        //Check for blank Database
        let resultConts = DatabaseController.instance.foodDatabaseCheck()
        if(resultConts != 5){
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
    
    // MARK: Table View
    // Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return foodOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = foodTabelView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.txtFoodName.text = foodOptions[indexPath.row].meal_name!
        cell.txtFoodDescr.text = foodOptions[indexPath.row].meal_name!
        cell.txtFoodPrice.text = foodOptions[indexPath.row].meal_name!
        cell.txtFoodCalorie.text = foodOptions[indexPath.row].meal_name!
        cell.txtFoodImage.image = UIImage(named: "\(foodOptions[indexPath.row].meal_name!).jpg") 
        
        
        return cell
    }

   

}
