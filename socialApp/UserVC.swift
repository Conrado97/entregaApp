//
//  UserVC.swift
//  socialApp
//
//  Created by Ahmad Ghadiri on 2/24/18.
//  Copyright © 2018 AhmadGhadiri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class UserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var completeSignInBtn: UIButton!
    
    var userUid: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImagePicker.image = image
            imageSelected = true
        } else {
            print("image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        if (usernameField.text == nil) {
            print("Must have user")
            completeSignInBtn.isEnabled = false
        } else {
            username = usernameField.text
            completeSignInBtn.isEnabled = true
        }
        guard let img = userImagePicker.image, imageSelected == true else {
            print("image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "img/jpeg"
            
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata) {
                (metadata, error) in
                if error != nil {
                    print("didn't upload the image")
                } else {
                    print("uploaded")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.setUpUser(img: url)
                    }
                }
            }
        }
    }
    
    func keychain() {
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    
    func setUpUser(img: String) {
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        keychain()
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        setLocation.setValue(userData)
    }
    
    @IBAction func completeAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: {
            (user, error) in
            if error != nil {
                print("can't create user \(String(describing: error))")
            }
            else {
                if let user = user {
                    self.userUid = user.uid
                }
                self.uploadImage()
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectedImagePicker(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
