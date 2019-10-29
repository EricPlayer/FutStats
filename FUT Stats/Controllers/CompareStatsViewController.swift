//
//  CompareStatsViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase

class CompareStatsViewController: UIViewController {
    
    let loadingVC = WaitViewController(message: "Loading...")
    
    var firstWeekNumber = ""
    var secondWeekNumber = ""
    
    @IBOutlet var myFirstView: UIView!
    @IBOutlet var mySecondView: UIView!
    
    @IBOutlet var btn_average: UIButton!
    @IBOutlet var btn_total: UIButton!
    @IBOutlet var btn_back: UIButton!
    
    @IBOutlet var firstName: UILabel!
    @IBOutlet var firstScore: UILabel!
    @IBOutlet var firstShot: UILabel!
    @IBOutlet var firstTarget: UILabel!
    @IBOutlet var firstShotAcc: UILabel!
    @IBOutlet var firstPassAcc: UILabel!
    @IBOutlet var firstPossesion: UILabel!
    @IBOutlet var firstCorner: UILabel!
    @IBOutlet var firstTackle: UILabel!
    @IBOutlet var firstFoul: UILabel!
    
    @IBOutlet var secondName: UILabel!
    @IBOutlet var secondScore: UILabel!
    @IBOutlet var secondShot: UILabel!
    @IBOutlet var secondTarget: UILabel!
    @IBOutlet var secondShotAcc: UILabel!
    @IBOutlet var secondPassAcc: UILabel!
    @IBOutlet var secondPossesion: UILabel!
    @IBOutlet var secondCorner: UILabel!
    @IBOutlet var secondTackle: UILabel!
    @IBOutlet var secondFoul: UILabel!
    
    @IBOutlet var firstNameTotal: UILabel!
    @IBOutlet var firstScoreTotal: UILabel!
    @IBOutlet var firstShotTotal: UILabel!
    @IBOutlet var firstTargetTotal: UILabel!
    @IBOutlet var firstTime: UILabel!
    @IBOutlet var firstGameCount: UILabel!
    @IBOutlet var firstRageQuit: UILabel!
    @IBOutlet var firstCornerTotal: UILabel!
    @IBOutlet var firstTackleTotal: UILabel!
    @IBOutlet var firstFoulTotal: UILabel!
    @IBOutlet var firstWinTotal: UILabel!
    
    @IBOutlet var secondNameTotal: UILabel!
    @IBOutlet var secondScoreTotal: UILabel!
    @IBOutlet var secondShotTotal: UILabel!
    @IBOutlet var secondTargetTotal: UILabel!
    @IBOutlet var secondTime: UILabel!
    @IBOutlet var secondGameCount: UILabel!
    @IBOutlet var secondRageQuit: UILabel!
    @IBOutlet var secondCornerTotal: UILabel!
    @IBOutlet var secondTackleTotal: UILabel!
    @IBOutlet var secondFoulTotal: UILabel!
    @IBOutlet var secondWinTotal: UILabel!
    
    //initial values
    var mGoals = 0
    var sGoals = 0
    var mShots = 0
    var sShots = 0
    var mShotT = 0
    var sShotT = 0
    var mCorner = 0
    var sCorner = 0
    var mTackle = 0
    var sTackle = 0
    var mFoul = 0
    var sFoul = 0
    
    var isExtra = 0
    var sIsExtra = 0
    var RageQuit = 0
    var sRageQuit = 0
    var totalTime = 0
    var sTotalTime = 0
    var winCount = 0
    var sWinCount = 0
    var lossCount = 0
    var sLossCount = 0
    var matchCount = 0
    var secondMatchCount = 0
    
    var mShotAccu = 0
    var sShotAccu = 0
    var mPassAccu = 0
    var sPassAccu = 0
    var mPoss = 0
    var sPoss = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = "WL \(self.firstWeekNumber)"
        secondName.text = "WL \(self.secondWeekNumber)"
        self.mySecondView.isHidden = true
        
        firstNameTotal.text = "WL \(self.firstWeekNumber)"
        secondNameTotal.text = "WL \(self.secondWeekNumber)"
        
        self.getCompareWeekendData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func average_clk(_ sender: Any) {
        self.btn_average.setImage(UIImage(named: "AVERAGE_BUTTON"), for: .normal)
        self.btn_total.setImage(UIImage(named: "NON_AVERAGE_BUTTON_GREY"), for: .normal)
        self.mySecondView.isHidden = true
        self.myFirstView.addSubview(self.btn_average)
        self.myFirstView.addSubview(self.btn_total)
        self.myFirstView.addSubview(self.btn_back)
    }
    
    @IBAction func total_clk(_ sender: Any) {
        self.btn_average.setImage(UIImage(named: "AVERAGE_BUTTON_GREY"), for: .normal)
        self.btn_total.setImage(UIImage(named: "NON_AVERAGE_BUTTON"), for: .normal)
        self.mySecondView.isHidden = false
        self.mySecondView.addSubview(self.btn_average)
        self.mySecondView.addSubview(self.btn_total)
        self.mySecondView.addSubview(self.btn_back)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getCompareWeekendData(){
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        present(loadingVC, animated: true, completion: nil)
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isEqualTo: self.firstWeekNumber)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loadingVC.dismiss(animated: true,completion: nil)
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        if dbData["My Shots"] != nil {
                            let obj = MyScoreData()
                            let checkVal = obj.checkIsInt(data: dbData)
                            
                            if checkVal == 1 {
                                self.mGoals += Int(dbData["MyScore"] as! String)!
                                self.mShots += Int(dbData["My Shots"] as! String)!
                                self.mShotT += Int(dbData["My Shots on Targets"] as! String)!
                                self.mCorner += Int(dbData["My Corners"] as! String)!
                                self.mTackle += Int(dbData["My Tackles"] as! String)!
                                self.mFoul += Int(dbData["My Fouls"] as! String)!
                                
                                self.mShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                                self.mPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                                self.mPoss += Int(dbData["My Possession %"] as! String)!
                                
                                self.totalTime += Int(dbData["Time"] as! String)!
                                self.matchCount += 1
                                
                                if (dbData["RageQuit"] as! String) != "0" {
                                    self.RageQuit += 1
                                }
                                if (dbData["Extra"] as! String) != "0" {
                                    self.isExtra += 1
                                }
                                if Int(dbData["MyScore"] as! String)! > Int(dbData["OpScore"] as! String)! {
                                    self.winCount += 1
                                } else if Int(dbData["MyScore"] as! String)! < Int(dbData["OpScore"] as! String)! {
                                    self.lossCount += 1
                                }
                            }
                        }
                    }
                    /*************         cast value to Non Average       *******************/
                    
                    self.firstScoreTotal.text = String(self.mGoals)
                    self.firstShotTotal.text = String(self.mShots)
                    self.firstTargetTotal.text = String(self.mShotT)
                    self.firstTime.text = String(self.totalTime)
                    self.firstGameCount.text = String(self.matchCount)
                    self.firstRageQuit.text = String(self.RageQuit)
                    
                    self.firstCornerTotal.text = String(self.mCorner)
                    self.firstTackleTotal.text = String(self.mTackle)
                    self.firstFoulTotal.text = String(self.mFoul)
                    self.firstWinTotal.text = String(self.winCount)
                    
                    /*************         cast value to Average       *******************/
                    if self.RageQuit == 0 && self.isExtra == 0 {
                        self.firstScore.text = String(format: "%.02f", Double(round(100*Double(self.mGoals)/Double(self.matchCount))/100))
                        self.firstShot.text = String(format: "%.02f", Double(round(100*Double(self.mShots)/Double(self.matchCount))/100))
                        self.firstTarget.text = String(format: "%.02f", Double(round(100*Double(self.mShotT)/Double(self.matchCount))/100))
                        self.firstShotAcc.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.firstPassAcc.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.firstPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.firstCorner.text = String(format: "%.02f", Double(round(100*Double(self.mCorner)/Double(self.matchCount))/100))
                        self.firstTackle.text = String(format: "%.02f", Double(round(100*Double(self.mTackle)/Double(self.matchCount))/100))
                        self.firstFoul.text = String(format: "%.02f", Double(round(100*Double(self.mFoul)/Double(self.matchCount))/100))
                        
                    } else {
                        
                        let averageNum = Double(round(100*Double(self.totalTime)/Double(90))/100)
                        
                        self.firstScore.text = String(format: "%.02f", Double(round(Double(self.mGoals)/averageNum*100)/100))
                        self.firstShot.text = String(format: "%.02f", Double(round(Double(self.mShots)/averageNum*100)/100))
                        self.firstTarget.text = String(format: "%.02f", Double(round(Double(self.mShotT)/averageNum*100)/100))
                        self.firstShotAcc.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.firstPassAcc.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.firstPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.firstCorner.text = String(format: "%.02f", Double(round(Double(self.mCorner)/averageNum*100)/100))
                        self.firstTackle.text = String(format: "%.02f", Double(round(Double(self.mTackle)/averageNum*100)/100))
                        self.firstFoul.text = String(format: "%.02f", Double(round(Double(self.mFoul)/averageNum*100)/100))
                    }
                }
        }
        self.getSecondWeekendData()
    }
    
    func getSecondWeekendData(){
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isEqualTo: self.secondWeekNumber)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loadingVC.dismiss(animated: true,completion: nil)
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        if dbData["My Shots"] != nil {
                            let obj = MyScoreData()
                            let checkVal = obj.checkIsInt(data: dbData)
                            
                            if checkVal == 1 {
                                self.sGoals += Int(dbData["MyScore"] as! String)!
                                self.sShots += Int(dbData["My Shots"] as! String)!
                                self.sShotT += Int(dbData["My Shots on Targets"] as! String)!
                                self.sCorner += Int(dbData["My Corners"] as! String)!
                                self.sTackle += Int(dbData["My Tackles"] as! String)!
                                self.sFoul += Int(dbData["My Fouls"] as! String)!
                                
                                self.sShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                                self.sPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                                self.sPoss += Int(dbData["My Possession %"] as! String)!
                                
                                self.sTotalTime += Int(dbData["Time"] as! String)!
                                self.secondMatchCount += 1
                                
                                if (dbData["RageQuit"] as! String) != "0" {
                                    self.sRageQuit += 1
                                }
                                if (dbData["Extra"] as! String) != "0" {
                                    self.sIsExtra += 1
                                }
                                if Int(dbData["MyScore"] as! String)! > Int(dbData["OpScore"] as! String)! {
                                    self.sWinCount += 1
                                } else if Int(dbData["MyScore"] as! String)! < Int(dbData["OpScore"] as! String)! {
                                    self.sLossCount += 1
                                }
                            }
                        }
                    }
                    /*************         cast value to Non Average       *******************/
                    
                    self.secondScoreTotal.text = String(self.sGoals)
                    self.secondShotTotal.text = String(self.sShots)
                    self.secondTargetTotal.text = String(self.sShotT)
                    self.secondTime.text = String(self.sTotalTime)
                    self.secondGameCount.text = String(self.secondMatchCount)
                    self.secondRageQuit.text = String(self.sRageQuit)
                    
                    self.secondCornerTotal.text = String(self.sCorner)
                    self.secondTackleTotal.text = String(self.sTackle)
                    self.secondFoulTotal.text = String(self.sFoul)
                    self.secondWinTotal.text = String(self.sWinCount)
                    
                    /*************         cast value to Average       *******************/
                    if self.sRageQuit == 0 && self.sIsExtra == 0 {
                        self.secondScore.text = String(format: "%.02f", Double(round(100*Double(self.sGoals)/Double(self.secondMatchCount))/100))
                        self.secondShot.text = String(format: "%.02f", Double(round(100*Double(self.sShots)/Double(self.secondMatchCount))/100))
                        self.secondTarget.text = String(format: "%.02f", Double(round(100*Double(self.sShotT)/Double(self.secondMatchCount))/100))
                        self.secondShotAcc.text = String(format: "%.02f", Double(round(100*Double(self.sShotAccu)/Double(self.secondMatchCount))/100))
                        self.secondPassAcc.text = String(format: "%.02f", Double(round(100*Double(self.sPassAccu)/Double(self.secondMatchCount))/100))
                        self.secondPossesion.text = String(format: "%.02f", Double(round(100*Double(self.sPoss)/Double(self.secondMatchCount))/100))
                        self.secondCorner.text = String(format: "%.02f", Double(round(100*Double(self.sCorner)/Double(self.secondMatchCount))/100))
                        self.secondTackle.text = String(format: "%.02f", Double(round(100*Double(self.sTackle)/Double(self.secondMatchCount))/100))
                        self.secondFoul.text = String(format: "%.02f", Double(round(100*Double(self.sFoul)/Double(self.secondMatchCount))/100))
                    } else {
                        let secondAverageNum = Double(round(100*Double(self.sTotalTime)/Double(90))/100)
                        
                        self.secondScore.text = String(format: "%.02f", Double(round(Double(self.sGoals)/secondAverageNum*100)/100))
                        self.secondShot.text = String(format: "%.02f", Double(round(Double(self.sShots)/secondAverageNum*100)/100))
                        self.secondTarget.text = String(format: "%.02f", Double(round(Double(self.sShotT)/secondAverageNum*100)/100))
                        self.secondShotAcc.text = String(format: "%.02f", Double(round(100*Double(self.sShotAccu)/Double(self.secondMatchCount))/100))
                        self.secondPassAcc.text = String(format: "%.02f", Double(round(100*Double(self.sPassAccu)/Double(self.secondMatchCount))/100))
                        self.secondPossesion.text = String(format: "%.02f", Double(round(100*Double(self.sPoss)/Double(self.secondMatchCount))/100))
                        self.secondCorner.text = String(format: "%.02f", Double(round(Double(self.sCorner)/secondAverageNum*100)/100))
                        self.secondTackle.text = String(format: "%.02f", Double(round(Double(self.sTackle)/secondAverageNum*100)/100))
                        self.secondFoul.text = String(format: "%.02f", Double(round(Double(self.sFoul)/secondAverageNum*100)/100))
                    }
                }
        }
        self.loadingVC.dismiss(animated: true,completion: nil)
    } 
}
