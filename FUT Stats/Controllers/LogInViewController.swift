//
//  ViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 01/31/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        
        //check user logged in or not
        checkLoggedIn()
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.standard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == user {
                if  user != nil {
                    guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainViewController else {
                        return
                    }
                    self.present(uvc, animated: false)
                } else {
                    print ("Please login")
                }
            } else {
                print("not signed in")
            }
        }
    }
}

