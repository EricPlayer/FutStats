//
//  AboutUsViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 01/31/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
