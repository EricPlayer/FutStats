//
//  UploadViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import IGRPhotoTweaks
import Firebase

class UploadViewController: UIViewController, UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var imageView: UIImageView!
    
    fileprivate var image: UIImage!
    
    @IBOutlet var txt_myScore: UITextField!
    @IBOutlet var txt_rightScore: UITextField!
    @IBOutlet var txt_rageQuit: UITextField!
    
    @IBOutlet var chk_extraTime: UIButton!
    @IBOutlet var chk_rageQuit: UIButton!
    @IBOutlet var btn_game: UIButton!
    
    let loadingVC = UploadWVC(message1: "Uploading photo...", message2: "Once finished, it can take up to 10 minutes to update stats.")
    
    //game id and week's number comes from weekend league
    var gameId = 0
    var weekNum = ""
    
    var extraTime_isCheck = 0
    var rageQuit_isCheck = 0
    var game_isCheck = 1
    
    var numberoflaunches : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txt_myScore.delegate = self
        self.txt_rightScore.delegate = self
        self.txt_rageQuit.delegate = self
        self.txt_rageQuit.isHidden = true
        
        LoadNumberOfLaunches()
        SaveNumberOfLaunches()
    }

    override func viewWillAppear(_ animated: Bool) {
        if ImageData.sharedInstance.isTakenPhoto == 1 {
            self.imageView.image = ImageData.sharedInstance.cropImage
        } else {
            self.imageView.image = UIImage(named: "img_bk")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto_clk(_ sender: Any) {
        if numberoflaunches == 1 {
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialViewController else {
                return
            }
            self.present(uvc, animated: false)
        } else {
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC") as? CameraViewController else {
                return
            }
            self.present(uvc, animated: false)
        }
        numberoflaunches = 0
        ImageData.sharedInstance.isTakenPhoto = 0
    }
    
    @IBAction func howTo_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialViewController else {
            return
        }
        self.present(uvc, animated: false)
    }
    
    @IBAction func upLoadPhoto_clk(_ sender: Any) {
        if ImageData.sharedInstance.isTakenPhoto == 0 {
            viewAlert(message: "Please take a picture of game result.")
        }
        if self.txt_myScore.text == "" {
            viewAlert(message: "Please fill HOME SCORE value.")
        }
        if self.txt_rightScore.text == "" {
            viewAlert(message: "Please fill AWAY SCORE value.")
        }
        
        let alert = UIAlertController(title: "Reminder:", message: "Are you sure upload current photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { (_) in
            self.appDelegate.stopTimer()
            self.present(self.loadingVC, animated: true, completion: nil)
            //get Current Datetime and replace bar to underbar
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateTime = formatter.string(from: now)
            dateTime = dateTime.replacingOccurrences(of: "[ |:-]", with: "_", options: [.regularExpression])
            
            //reference of storeage
            let storage = Storage.storage()
            let storageRef = storage.reference()
            //reference of cloud firestore
            let db = Firestore.firestore()
            
            let userName = Auth.auth().currentUser?.displayName
            let userId = Auth.auth().currentUser?.uid
            let storeName = userName! + "_" + userId!
            
            let imageRef = storageRef.child("\(storeName)/\(dateTime).jpg")
            
            //let photoData: Data = UIImagePNGRepresentation(self.imageView.image!)!
            let photoData: Data = UIImageJPEGRepresentation(self.imageView.image!, 10)!
            
            var myScore = self.txt_myScore.text as! String
            var opScore = self.txt_rightScore.text as! String
            var rageQuit = self.txt_rageQuit.text as! String
            var time = 90
            
            //check extra time and plus time
            if self.extraTime_isCheck == 1 {
                time = 120
            }
            
            if rageQuit == "" || rageQuit == "MIN" {
                rageQuit = "0"
            } else {
                time = Int(self.txt_rageQuit.text!)!
            }
            
            //change score according to played place
            if self.game_isCheck == 0 {
                let temp = myScore
                myScore = opScore
                opScore = temp
            }
            
            _ = imageRef.putData(photoData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print (error as Any)
                    self.appDelegate.startTimer()
                    self.loadingVC.dismiss(animated: true,completion: nil)
                    return
                }
                //decide weekend or division
                var idWeekEndLeague = ""
                var idWlGame = ""
                if self.weekNum.isEmpty {
                    idWeekEndLeague = "-1"
                } else {
                    idWeekEndLeague = self.weekNum
                }
                
                if self.gameId == 0 {
                    idWlGame = "-1"
                } else {
                    idWlGame = String(self.gameId)
                }
                
                let docData: [String: String] = [
                    "Extra" : "\(self.extraTime_isCheck)",
                    "Home" : "\(self.game_isCheck)",
                    "IdWLGame" : "\(idWlGame)",
                    "IdWeekendLeague" : "\(idWeekEndLeague)",
                    "MyScore" : "\(myScore)",
                    "OpScore" : "\(opScore)",
                    "RageQuit" : "\(rageQuit)",
                    "Time" : "\(time)",
                    "XmlSuccess" : "0"
                ]
                
                db.collection(userId!).document(dateTime).setData(docData)
                
                self.appDelegate.startTimer()
                self.loadingVC.dismiss(animated: true,completion: nil)
                self.dismiss(animated: false, completion: nil)
            })
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func extraTime_clk(_ sender: Any) {
        if self.extraTime_isCheck == 0 {
            viewAlert(message: "If there was a penalties shootout in the game, please give an extra goal to the winner.")
            self.extraTime_isCheck = 1
        } else {
            self.extraTime_isCheck = 0
        }
    }
    
    @IBAction func rageQuit_clk(_ sender: Any) {
        if self.rageQuit_isCheck == 0 {
            self.rageQuit_isCheck = 1
            self.txt_rageQuit.text = "MIN"
            self.txt_rageQuit.isHidden = false
        } else {
            self.rageQuit_isCheck = 0
            self.txt_rageQuit.text = ""
            self.txt_rageQuit.isHidden = true
        }
    }
    
    @IBAction func game_clk(_ sender: Any) {
        if self.game_isCheck == 1 {
            self.game_isCheck = 0
            self.btn_game.setImage(UIImage(named: "btn_away"), for: .normal)
        } else {
            self.game_isCheck = 1
            self.btn_game.setImage(UIImage(named: "btn_home"), for: .normal)
        }
    }
    
    @IBAction func back_clk(_ sender: Any) {
        ImageData.sharedInstance.isTakenPhoto = 0
        self.dismiss(animated: false, completion: nil)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if txt_rageQuit.text == "" && textField == txt_rageQuit {
            txt_rageQuit.text = "MIN"
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_myScore || textField == txt_rightScore {
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }

    //show alert with exception
    func viewAlert(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        return
    }
    
    func LoadNumberOfLaunches() {
        let defaults = UserDefaults.standard
        numberoflaunches = defaults.integer(forKey: "Launches")
    }
    
    func SaveNumberOfLaunches() {
        numberoflaunches = numberoflaunches + 1
        let defaults = UserDefaults.standard
        defaults.set(numberoflaunches, forKey: "Launches")
    }
}
