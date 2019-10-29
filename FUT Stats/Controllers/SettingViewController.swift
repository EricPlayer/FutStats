//
//  SettingViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func about_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as? AboutUsViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func symbol_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SymbolVC") as? SymbolViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func howTo_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func privacy_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyVC") as? PrivacyViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func signOut_clk(_ sender: Any) {
        
        let alert = UIAlertController(title: "Reminder:", message: "Are you sure sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { (_) in
            self.appDelegate.stopTimer()
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let userDefaults = UserDefaults.standard
                userDefaults.set(false, forKey: "Students")
                
                let login = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = login
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .default))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
