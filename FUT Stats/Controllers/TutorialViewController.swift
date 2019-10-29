//
//  TutorialViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    // create swipe gesture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    // outlet - back button
    @IBOutlet var btn_back: UIButton!
    
    // outlet - page control
    @IBOutlet var myPageControl: UIPageControl!
    
    // outlet - image view
    @IBOutlet var myImageView: UIImageView!
    
    var myImage = ["page1", "page2", "page3", "page4", "page5"]
    
    // MARK: - view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        
        // add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(TutorialViewController.handleSwipeLeft(_:)))
        self.swipeGestureRight.addTarget(self, action: #selector(TutorialViewController.handleSwipeRight(_:)))
        
        // add gesture in to view
        self.view.addGestureRecognizer(self.swipeGestureLeft)
        self.view.addGestureRecognizer(self.swipeGestureRight)
        
        self.myPageControl.currentPage = 0
        self.myPageControl.numberOfPages = self.myImage.count
        self.myImageView.image = UIImage(named: "\(myImage[0])")
        self.btn_back.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility function
    
    // increase page number on swift left
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        if self.myPageControl.currentPage < 4 {
            self.myPageControl.currentPage += 1
            self.myImageView.image = UIImage(named: "\(myImage[myPageControl.currentPage])")
        }
        if self.myPageControl.currentPage ==  4 {
            self.btn_back.isHidden = false
        } else {
            self.btn_back.isHidden = true
        }
    }
    
    // reduce page number on swift right
    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer){
        if self.myPageControl.currentPage != 0 {
            self.myPageControl.currentPage -= 1
            self.myImageView.image = UIImage(named: "\(myImage[myPageControl.currentPage])")
        }
        if self.myPageControl.currentPage ==  4 {
            self.btn_back.isHidden = false
        } else {
            self.btn_back.isHidden = true
        }
    }
    
    @IBAction func back_clk(_ sender: Any) { 
        self.dismiss(animated: false, completion: nil)
    }
}
