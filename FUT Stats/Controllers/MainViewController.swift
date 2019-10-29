//
//  MainViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate.startTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func instagram_clk(_ sender: Any) {
        let Username =  "fut_18_stats" // Your Instagram Username here
        let appURL = NSURL(string: "instagram://user?username=\(Username)")!
        let webURL = NSURL(string: "https://instagram.com/\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
    
    @IBAction func facebook_clk(_ sender: Any) {
        let Username = "588777828130716" // Your facebook Username here
        let appURL = NSURL(string: "fb://profile/\(Username)")!
        let webURL = NSURL(string: "https://www.facebook.com/FifaFutStats/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if facebook app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
    
    @IBAction func settings_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as? SettingViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func division_clk(_ sender: Any) {
        // send ads request
        self.appDelegate.sendAdsRequest()
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "DivisionsVC") as? DivisionsViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func weekend_clk(_ sender: Any) {
        // send ads request
        self.appDelegate.sendAdsRequest()
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "WeekEndVC") as? WeekEndViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func allCompetition_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ShowStatsVC") as? ShowStatsViewController else {
            return
        }
        uvc.viewType = 1
        self.present(uvc, animated: false)
    }
}
