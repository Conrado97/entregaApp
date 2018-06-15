//
//  ViewController.swift
//  socialApp
//
//  Created by Ahmad Ghadiri on 2/24/18.
//  Copyright © 2018 AhmadGhadiri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            goToFeedVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToCreateUserVC() {
        performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    func goToFeedVC() {
        performSegue(withIdentifier: "ToFeed", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUp" {
            if let destination = segue.destination as? UserVC {
                if self.userUid != nil {
                    destination.userUid = self.userUid
                }
                if emailField.text != nil {
                    destination.emailField = self.emailField.text
                }
                if self.passwordField.text != nil {
                    destination.passwordField = self.passwordField.text
                }
            }
        }
    }

    @IBAction func signInTapped(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        if (email != nil), (password != nil) {
            Auth.auth().signIn(withEmail: email!, password: password!, completion:
                {
                    (user, error) in
                    if error == nil {
                        if let curUser = user {
                            self.userUid = curUser.uid
                            self.goToFeedVC()
                        }
                    } else {
                        self.goToCreateUserVC()
                    }
            })
        }
    }
}

