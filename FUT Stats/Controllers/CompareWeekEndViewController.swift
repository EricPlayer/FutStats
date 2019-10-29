//
//  CompareWeekEndViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit

class CompareWeekEndViewController: UIViewController {

    var compareWeekList = [String]()
    var drop1: UIDropDown!
    var drop2: UIDropDown!
    var myImageview1: UIImageView!
    var myImageview2: UIImageView!
    
    var firstName = String()
    var secondName = String()
    var firstWeekNumber = ""
    var secondWeekNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drop2 = UIDropDown(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 5 * 3.5, height: UIScreen.main.bounds.width / 5 * 3.5 / 5))
        drop2.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.height / 2)
        drop2.options = compareWeekList
        drop2.placeholder = "Weekend League \(drop2.options[0])"
        self.secondWeekNumber = drop2.options[0]
        drop2.didSelect { (option, index) in
            print("You just select: \(option) at index: \(index)")
            self.drop2.placeholder = "Weekend League \(option)"
            self.secondWeekNumber = String(option)
        }
        if compareWeekList.count > 0 {
            self.view.addSubview(drop2)
        }
        
        myImageview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 5 * 3.5, height: UIScreen.main.bounds.width / 5 * 3.5 / 5))
        myImageview2.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.height / 2)
        myImageview2.image = UIImage(named: "bk_dropdown")
        self.view.addSubview(myImageview2)
        
        drop1 = UIDropDown(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 5 * 3.5, height: UIScreen.main.bounds.width / 5 * 3.5 / 5))
        drop1.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.height / 4)
        drop1.options = compareWeekList
        drop1.placeholder = "Weekend League \(drop1.options[0])"
        self.firstWeekNumber = drop1.options[0]
        drop1.didSelect { (option, index) in
            print("You just select: \(option) at index: \(index)")
            self.drop1.placeholder = "Weekend League \(option)"
            self.firstWeekNumber = String(option)
        }
        
        if compareWeekList.count > 0 {
            self.view.addSubview(drop1)
        }
        
        myImageview1 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 5 * 3.5, height: UIScreen.main.bounds.width / 5 * 3.5 / 5))
        myImageview1.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.height / 4)
        myImageview1.image = UIImage(named: "bk_dropdown")
        self.view.addSubview(myImageview1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func compare_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "CompareStatsVC") as? CompareStatsViewController else {
            return
        }
        uvc.firstWeekNumber = self.firstWeekNumber
        uvc.secondWeekNumber = self.secondWeekNumber
        self.present(uvc, animated: false)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
