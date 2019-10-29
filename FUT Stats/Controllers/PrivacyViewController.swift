//
//  PrivacyViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 03/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController, UIWebViewDelegate {

    // url to load
    let urlString : String = "https://www.iubenda.com/privacy-policy/16880963"
    
    // outlet - webview
    @IBOutlet var myWebView: UIWebView!
    
    // outlet - back button
    @IBOutlet var btn_back: UIButton!
    
    // activity indicator i.e. spinner
    let loadingVC = WaitViewController(message: "Loading...")
    
    // MARK: -- View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set webview delegate
        self.myWebView.delegate = self
        
        // fit content within screen size.
        self.myWebView.scalesPageToFit = true
        
        // start spinner
        present(loadingVC, animated: true, completion: nil)
        
        // load url content within webview
        if let urlToBrowse = URL(string: self.urlString) {
            let urlRequest = URLRequest(url: urlToBrowse)
            self.myWebView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Web view delegate function
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingVC.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    } 
}
