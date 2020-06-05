//
//  signUpViewController.swift
//  foodDelivery
//
//  Created by apple on 5/29/20.
//  Copyright © 2020 varun. All rights reserved.
//

import UIKit

class signUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    // MARKS: Outlets
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var saveImage: UIImageView!
    
    
    //MARK: Variebles
    let imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(gesture:)))
        self.saveImage.isUserInteractionEnabled = true
        self.saveImage.addGestureRecognizer(tapGuesture)
    }
    
    @objc func selectImage(gesture: UITapGestureRecognizer){
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // MARKS: Actions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        let img = info[.originalImage] as? UIImage
        self.saveImage.image = img
    }
    
    
    @IBAction func takePhotoFromCamara(_ sender: Any) {
        print("Camara Button Pressed")
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }else{
             showAlertboax(title: "No Camara", message: "This device does not have camara. You have to choose from galary by clicking on image section")
            print("this device does not have camara. You have choose from galary by clicking on image section")
        }
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
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        print("SignUp Button Pressed")
        var message = ""
        var count = 0
        if(txtEmail.text! != ""){
            var userExe = DatabaseController.instance.checkUserExist(email: txtEmail.text!)
            count = userExe.count
        }
        if(txtPassword.text! == "" || txtEmail.text! == "" || txtPhone.text! == ""){
           
            showAlertboax(title: "Error", message: "Every Field Must be filled")
        }else if(txtEmail.text! != "" && count != 0){
                showAlertboax(title: "Error", message: "User already exists")
                return
        
            
        }else{

            let jpg = self.saveImage.image?.jpegData(compressionQuality: 0.75)
            message =  DatabaseController.instance.signUp(password: txtPassword.text!, email: txtEmail.text!,  phone: txtPhone.text!,  image: jpg as! NSData)
            
            showAlertboax(title: "Successful", message: "\(message)")
            
            txtEmail.text = ""
            txtPhone.text = ""
            txtPassword.text = ""
            print(message)
        }
        
    }

}
