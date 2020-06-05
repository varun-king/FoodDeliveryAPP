//
//  receiptViewController.swift
//  foodDelivery
//
//  Created by apple on 5/29/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit
import CoreLocation


class receiptViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager?
    var count = 20
    var timer:Timer?
    //Outlets
    var defaults:UserDefaults!
    @IBOutlet weak var txtOrderDate: UILabel!
    @IBOutlet weak var txtOrderSku: UILabel!
    @IBOutlet weak var txtOrderName: UILabel!
    @IBOutlet weak var imgOrderImg: UIImageView!
    @IBOutlet weak var txtOrderPrice: UILabel!
    @IBOutlet weak var txtOrderDisnt: UILabel!
    @IBOutlet weak var txtOrderTip: UILabel!
    @IBOutlet weak var txtOrderTax: UILabel!
    @IBOutlet weak var txtOrderSubtotal: UILabel!
    
    
    
    var orderInfo:[OrderData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaults = UserDefaults.standard
        //   let date = self.defaults.data(forKey: "ordDate")!
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd  hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        //   let dateString = formatter.string(from: (date as!Date) as Date)
        
        txtOrderName.text = self.defaults.string(forKey: "foodName")!
        //  txtOrderDate.text = dateString
        imgOrderImg.image = UIImage(named: "\(self.defaults.string(forKey: "foodImg")!).jpg")
        txtOrderSku.text = self.defaults.string(forKey: "foodSku")!
        txtOrderPrice.text = String(self.defaults.double(forKey: "foodPrice"))
        //let calorie = self.defaults.integer(forKey: "foodCalorie")
        txtOrderSubtotal.text = String(self.defaults.double(forKey: "ordSubtotal"))
        txtOrderTax.text = String(self.defaults.double(forKey: "ordTax"))
        txtOrderTip.text = String(self.defaults.double(forKey: "ordTip"))
        txtOrderDisnt.text = String(self.defaults.double(forKey: "ordDiscont"))
        
        // For Order Notification
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // self.mapView.delegate = self
        // self.mapView.delegate = self
        
        let storeLocation = CLLocationCoordinate2D(latitude: 43.774710, longitude: -79.695090)
        let zoomLavel = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: storeLocation, span: zoomLavel)
        
        /*mapView.setRegion(region, animated: true)
         
         let storePin = MKPointAnnotation()
         storePin.coordinate = storeLocation
         storePin.title = "Store"
         mapView.addAnnotation(storePin)
         */
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        // mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        // userloca = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        let someOtherLocation: CLLocation = CLLocation(latitude: 43.774710, longitude: -79.695090)
        let usersCurrentLocation: CLLocation = CLLocation(latitude: lat, longitude: long)
        let distanceInMeters: CLLocationDistance = usersCurrentLocation.distance(from: someOtherLocation)
        if distanceInMeters < 100 {
            print("\(distanceInMeters)")
            print("He is near you")
            callNatifiation()
            
            
            let box = UIAlertController(
                title: "Start Preparing Order",
                message: "Your Order has been prepared.",
                preferredStyle: .alert
            )
            
            box.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            self.present(box, animated: true)
            
            
            guard timer == nil else { return }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                
                self.count = self.count - 1
                print("Count is \( self.count)")
                if(self.count == 0){
                    
                    let box = UIAlertController(
                        title: "Order ready",
                        message: "Your Order is ready",
                        preferredStyle: .alert
                        
                    )
                    
                    box.addAction(
                        UIAlertAction(title: "OK", style: .default,  handler: {action in
                            inavlidate()
                        })
                    )
                    self.present(box, animated: true)
                }
            })
            
            func inavlidate() {
                
                self.timer?.invalidate()
                print("you are here")
                count = 30
            }
            
            
            
            
        } else {
            print("\(distanceInMeters)")
            print("He is very Dooooor")
            // this user is at least over 100 meters outside the otherLocation
        }
    }
    
    func callNatifiation(){
        print("Notifucation Function")
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Your Oder is redy"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil{
                print("Error = \(error?.localizedDescription ?? "Local notification ")")
            }
        }
        
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "continue_shopping", sender: self)
    }
    
    
}
