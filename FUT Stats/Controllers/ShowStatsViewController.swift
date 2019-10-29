//
//  ShowStatsViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase

class ShowStatsViewController: UIViewController {
    
    //constant for view data type
    //0:Division Stats, 1:All Competition Stat, 2:All Weekend League Stat, 3:Current weekend league stat
    var viewType = 0
    var weekNum = ""

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet var myFirstView: UIView!
    @IBOutlet var mySecondView: UIView!
    
    @IBOutlet var btn_average: UIButton!
    @IBOutlet var btn_total: UIButton!
    @IBOutlet var btn_back: UIButton!
    
    @IBOutlet var myScore: UILabel!
    @IBOutlet var myShot: UILabel!
    @IBOutlet var myTarget: UILabel!
    @IBOutlet var myAccuracy: UILabel!
    @IBOutlet var myPass: UILabel!
    @IBOutlet var myPossesion: UILabel!
    @IBOutlet var myCorner: UILabel!
    @IBOutlet var myTackle: UILabel!
    @IBOutlet var myFoul: UILabel!
    
    @IBOutlet var opScore: UILabel!
    @IBOutlet var opShot: UILabel!
    @IBOutlet var opTarget: UILabel!
    @IBOutlet var opAccuracy: UILabel!
    @IBOutlet var opPass: UILabel!
    @IBOutlet var opPossesion: UILabel!
    @IBOutlet var opCorner: UILabel!
    @IBOutlet var opTackle: UILabel!
    @IBOutlet var opFoul: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var myTotalScore: UILabel!
    @IBOutlet var myTotalShot: UILabel!
    @IBOutlet var myTotalTarget: UILabel!
    @IBOutlet var myTotalCorner: UILabel!
    @IBOutlet var myTotalTackle: UILabel!
    @IBOutlet var myTotalFoul: UILabel!
    
    @IBOutlet var opTotalScore: UILabel!
    @IBOutlet var opTotalShot: UILabel!
    @IBOutlet var opTotalTarget: UILabel!
    @IBOutlet var opTotalCorner: UILabel!
    @IBOutlet var opTotalTackle: UILabel!
    @IBOutlet var opTotalFoul: UILabel!
    
    @IBOutlet var TotalRangeQuit: UILabel!
    @IBOutlet var TotalCount: UILabel!
    @IBOutlet var TotalTime: UILabel!
    @IBOutlet var TotalWin: UILabel!
    @IBOutlet var TotalLoss: UILabel!
    
    //initial values
    var mGoals = 0
    var oGoals = 0
    var mShots = 0
    var oShots = 0
    var mShotT = 0
    var oShotT = 0
    var mCorner = 0
    var oCorner = 0
    var mTackle = 0
    var oTackle = 0
    var mFoul = 0
    var oFoul = 0
    
    var isExtra = 0
    var RageQuit = 0
    var totalTime = 0
    var winCount = 0
    var lossCount = 0
    var matchCount = 0
    
    var mShotAccu = 0
    var oShotAccu = 0
    var mPassAccu = 0
    var oPassAccu = 0
    var mPoss = 0
    var oPoss = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mySecondView.isHidden = true
        self.loading.isHidden = true
        if self.viewType == 0 {
            getDivisionData()
        } else if self.viewType == 2 {
            getAllWeekEndData()
        } else if self.viewType == 3 {
            getCurrentWeekendData()
        } else {
            getAllCompetitionData()
        }
    }
    
    func getDivisionData(){
        self.loading.isHidden = false
        self.loading.startAnimating()
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isEqualTo: "-1")
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)");
                self.loading.stopAnimating()
                self.loading.isHidden = true
            } else {
                for document in querySnapshot!.documents {
                    let dbData = document.data()
                    if dbData["My Shots"] != nil {
                        let obj = MyScoreData()
                        let checkVal = obj.checkIsInt(data: dbData)
                        
                        if checkVal == 1 {
                            self.mGoals += Int(dbData["MyScore"] as! String)!
                            self.oGoals += Int(dbData["OpScore"] as! String)!
                            self.mShots += Int(dbData["My Shots"] as! String)!
                            self.oShots += Int(dbData["Op Shots"] as! String)!
                            self.mShotT += Int(dbData["My Shots on Targets"] as! String)!
                            self.oShotT += Int(dbData["Op Shots on Targets"] as! String)!
                            self.mCorner += Int(dbData["My Corners"] as! String)!
                            self.oCorner += Int(dbData["Op Corners"] as! String)!
                            self.mTackle += Int(dbData["My Tackles"] as! String)!
                            self.oTackle += Int(dbData["Op Tackles"] as! String)!
                            self.mFoul += Int(dbData["My Fouls"] as! String)!
                            self.oFoul += Int(dbData["Op Fouls"] as! String)!
                            
                            self.mShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                            self.oShotAccu += Int(dbData["Op Shot Accuracy %"] as! String)!
                            self.mPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                            self.oPassAccu += Int(dbData["Op Pass Accuracy %"] as! String)!
                            self.mPoss += Int(dbData["My Possession %"] as! String)!
                            self.oPoss += Int(dbData["Op Possession %"] as! String)!
                            
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
                self.myTotalScore.text = String(self.mGoals)
                self.myTotalShot.text = String(self.mShots)
                self.myTotalTarget.text = String(self.mShotT)
                self.myTotalCorner.text = String(self.mCorner)
                self.myTotalTackle.text = String(self.mTackle)
                self.myTotalFoul.text = String(self.mFoul)
                
                self.opTotalScore.text = String(self.oGoals)
                self.opTotalShot.text = String(self.oShots)
                self.opTotalTarget.text = String(self.oShotT)
                self.opTotalCorner.text = String(self.oCorner)
                self.opTotalTackle.text = String(self.oTackle)
                self.opTotalFoul.text = String(self.oFoul)
                
                self.TotalRangeQuit.text = String(self.RageQuit)
                self.TotalCount.text = String(self.matchCount)
                self.TotalTime.text = String(self.totalTime)
                self.TotalWin.text = String(self.winCount)
                self.TotalLoss.text = String(self.lossCount)
                
                /*************         cast value to Average       *******************/
                if self.RageQuit == 0 && self.isExtra == 0 {
                    self.myScore.text = String(format: "%.02f", Double(round(100*Double(self.mGoals)/Double(self.matchCount))/100))
                    self.myShot.text = String(format: "%.02f", Double(round(100*Double(self.mShots)/Double(self.matchCount))/100))
                    self.myTarget.text = String(format: "%.02f", Double(round(100*Double(self.mShotT)/Double(self.matchCount))/100))
                    self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                    self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                    self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                    self.myCorner.text = String(format: "%.02f", Double(round(100*Double(self.mCorner)/Double(self.matchCount))/100))
                    self.myTackle.text = String(format: "%.02f", Double(round(100*Double(self.mTackle)/Double(self.matchCount))/100))
                    self.myFoul.text = String(format: "%.02f", Double(round(100*Double(self.mFoul)/Double(self.matchCount))/100))
                    
                    self.opScore.text = String(format: "%.02f", Double(round(100*Double(self.oGoals)/Double(self.matchCount))/100))
                    self.opShot.text = String(format: "%.02f", Double(round(100*Double(self.oShots)/Double(self.matchCount))/100))
                    self.opTarget.text = String(format: "%.02f", Double(round(100*Double(self.oShotT)/Double(self.matchCount))/100))
                    self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                    self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                    self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                    self.opCorner.text = String(format: "%.02f", Double(round(100*Double(self.oCorner)/Double(self.matchCount))/100))
                    self.opTackle.text = String(format: "%.02f", Double(round(100*Double(self.oTackle)/Double(self.matchCount))/100))
                    self.opFoul.text = String(format: "%.02f", Double(round(100*Double(self.oFoul)/Double(self.matchCount))/100))
                    
                    self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime))/100))
                } else {
                    
                    let averageNum = Double(round(100*Double(self.totalTime)/Double(90))/100)
                    
                    self.myScore.text = String(format: "%.02f", Double(round(Double(self.mGoals)/averageNum*100)/100))
                    self.myShot.text = String(format: "%.02f", Double(round(Double(self.mShots)/averageNum*100)/100))
                    self.myTarget.text = String(format: "%.02f", Double(round(Double(self.mShotT)/averageNum*100)/100))
                    self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                    self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                    self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                    self.myCorner.text = String(format: "%.02f", Double(round(Double(self.mCorner)/averageNum*100)/100))
                    self.myTackle.text = String(format: "%.02f", Double(round(Double(self.mTackle)/averageNum*100)/100))
                    self.myFoul.text = String(format: "%.02f", Double(round(Double(self.mFoul)/averageNum*100)/100))
                    
                    self.opScore.text = String(format: "%.02f", Double(round(Double(self.oGoals)/averageNum*100)/100))
                    self.opShot.text = String(format: "%.02f", Double(round(Double(self.oShots)/averageNum*100)/100))
                    self.opTarget.text = String(format: "%.02f", Double(round(Double(self.oShotT)/averageNum*100)/100))
                    self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                    self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                    self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                    self.opCorner.text = String(format: "%.02f", Double(round(Double(self.oCorner)/averageNum*100)/100))
                    self.opTackle.text = String(format: "%.02f", Double(round(Double(self.oTackle)/averageNum*100)/100))
                    self.opFoul.text = String(format: "%.02f", Double(round(Double(self.oFoul)/averageNum*100)/100))
                    
                    
                    self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime)/Double(self.matchCount))/100))
                    
                }
            }
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
    }
    
    func getAllCompetitionData(){
        self.loading.isHidden = false
        self.loading.startAnimating()
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("\(userId)")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loading.stopAnimating()
                    self.loading.isHidden = true
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        if dbData["My Shots"] != nil {
                            let obj = MyScoreData()
                            let checkVal = obj.checkIsInt(data: dbData)
                            
                            if checkVal == 1 {
                                self.mGoals += Int(dbData["MyScore"] as! String)!
                                self.oGoals += Int(dbData["OpScore"] as! String)!
                                self.mShots += Int(dbData["My Shots"] as! String)!
                                self.oShots += Int(dbData["Op Shots"] as! String)!
                                self.mShotT += Int(dbData["My Shots on Targets"] as! String)!
                                self.oShotT += Int(dbData["Op Shots on Targets"] as! String)!
                                self.mCorner += Int(dbData["My Corners"] as! String)!
                                self.oCorner += Int(dbData["Op Corners"] as! String)!
                                self.mTackle += Int(dbData["My Tackles"] as! String)!
                                self.oTackle += Int(dbData["Op Tackles"] as! String)!
                                self.mFoul += Int(dbData["My Fouls"] as! String)!
                                self.oFoul += Int(dbData["Op Fouls"] as! String)!
                                
                                self.mShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                                self.oShotAccu += Int(dbData["Op Shot Accuracy %"] as! String)!
                                self.mPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                                self.oPassAccu += Int(dbData["Op Pass Accuracy %"] as! String)!
                                self.mPoss += Int(dbData["My Possession %"] as! String)!
                                self.oPoss += Int(dbData["Op Possession %"] as! String)!
                                
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
                    self.myTotalScore.text = String(self.mGoals)
                    self.myTotalShot.text = String(self.mShots)
                    self.myTotalTarget.text = String(self.mShotT)
                    self.myTotalCorner.text = String(self.mCorner)
                    self.myTotalTackle.text = String(self.mTackle)
                    self.myTotalFoul.text = String(self.mFoul)
                    
                    self.opTotalScore.text = String(self.oGoals)
                    self.opTotalShot.text = String(self.oShots)
                    self.opTotalTarget.text = String(self.oShotT)
                    self.opTotalCorner.text = String(self.oCorner)
                    self.opTotalTackle.text = String(self.oTackle)
                    self.opTotalFoul.text = String(self.oFoul)
                    
                    self.TotalRangeQuit.text = String(self.RageQuit)
                    self.TotalCount.text = String(self.matchCount)
                    self.TotalTime.text = String(self.totalTime)
                    self.TotalWin.text = String(self.winCount)
                    self.TotalLoss.text = String(self.lossCount)
                    
                    /*************         cast value to Average       *******************/
                    if self.RageQuit == 0 && self.isExtra == 0 {
                        self.myScore.text = String(format: "%.02f", Double(round(100*Double(self.mGoals)/Double(self.matchCount))/100))
                        self.myShot.text = String(format: "%.02f", Double(round(100*Double(self.mShots)/Double(self.matchCount))/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(100*Double(self.mShotT)/Double(self.matchCount))/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(100*Double(self.mCorner)/Double(self.matchCount))/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(100*Double(self.mTackle)/Double(self.matchCount))/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(100*Double(self.mFoul)/Double(self.matchCount))/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(100*Double(self.oGoals)/Double(self.matchCount))/100))
                        self.opShot.text = String(format: "%.02f", Double(round(100*Double(self.oShots)/Double(self.matchCount))/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(100*Double(self.oShotT)/Double(self.matchCount))/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(100*Double(self.oCorner)/Double(self.matchCount))/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(100*Double(self.oTackle)/Double(self.matchCount))/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(100*Double(self.oFoul)/Double(self.matchCount))/100))
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime))/100))
                    } else {
                        
                        let averageNum = Double(round(100*Double(self.totalTime)/Double(90))/100)
                        
                        self.myScore.text = String(format: "%.02f", Double(round(Double(self.mGoals)/averageNum*100)/100))
                        self.myShot.text = String(format: "%.02f", Double(round(Double(self.mShots)/averageNum*100)/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(Double(self.mShotT)/averageNum*100)/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(Double(self.mCorner)/averageNum*100)/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(Double(self.mTackle)/averageNum*100)/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(Double(self.mFoul)/averageNum*100)/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(Double(self.oGoals)/averageNum*100)/100))
                        self.opShot.text = String(format: "%.02f", Double(round(Double(self.oShots)/averageNum*100)/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(Double(self.oShotT)/averageNum*100)/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(Double(self.oCorner)/averageNum*100)/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(Double(self.oTackle)/averageNum*100)/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(Double(self.oFoul)/averageNum*100)/100))
                        
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime)/Double(self.matchCount))/100))
                        
                    }
                }
                self.loading.stopAnimating()
                self.loading.isHidden = true
        }
    }
    
    func getAllWeekEndData(){
        self.loading.isHidden = false
        self.loading.startAnimating()
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isGreaterThan: "-1")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loading.stopAnimating()
                    self.loading.isHidden = true
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        if dbData["My Shots"] != nil {
                            let obj = MyScoreData()
                            let checkVal = obj.checkIsInt(data: dbData)
                            
                            if checkVal == 1 {
                                self.mGoals += Int(dbData["MyScore"] as! String)!
                                self.oGoals += Int(dbData["OpScore"] as! String)!
                                self.mShots += Int(dbData["My Shots"] as! String)!
                                self.oShots += Int(dbData["Op Shots"] as! String)!
                                self.mShotT += Int(dbData["My Shots on Targets"] as! String)!
                                self.oShotT += Int(dbData["Op Shots on Targets"] as! String)!
                                self.mCorner += Int(dbData["My Corners"] as! String)!
                                self.oCorner += Int(dbData["Op Corners"] as! String)!
                                self.mTackle += Int(dbData["My Tackles"] as! String)!
                                self.oTackle += Int(dbData["Op Tackles"] as! String)!
                                self.mFoul += Int(dbData["My Fouls"] as! String)!
                                self.oFoul += Int(dbData["Op Fouls"] as! String)!
                                
                                self.mShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                                self.oShotAccu += Int(dbData["Op Shot Accuracy %"] as! String)!
                                self.mPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                                self.oPassAccu += Int(dbData["Op Pass Accuracy %"] as! String)!
                                self.mPoss += Int(dbData["My Possession %"] as! String)!
                                self.oPoss += Int(dbData["Op Possession %"] as! String)!
                                
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
                    self.myTotalScore.text = String(self.mGoals)
                    self.myTotalShot.text = String(self.mShots)
                    self.myTotalTarget.text = String(self.mShotT)
                    self.myTotalCorner.text = String(self.mCorner)
                    self.myTotalTackle.text = String(self.mTackle)
                    self.myTotalFoul.text = String(self.mFoul)
                    
                    self.opTotalScore.text = String(self.oGoals)
                    self.opTotalShot.text = String(self.oShots)
                    self.opTotalTarget.text = String(self.oShotT)
                    self.opTotalCorner.text = String(self.oCorner)
                    self.opTotalTackle.text = String(self.oTackle)
                    self.opTotalFoul.text = String(self.oFoul)
                    
                    self.TotalRangeQuit.text = String(self.RageQuit)
                    self.TotalCount.text = String(self.matchCount)
                    self.TotalTime.text = String(self.totalTime)
                    self.TotalWin.text = String(self.winCount)
                    self.TotalLoss.text = String(self.lossCount)
                    
                    /*************         cast value to Average       *******************/
                    if self.RageQuit == 0 && self.isExtra == 0 {
                        self.myScore.text = String(format: "%.02f", Double(round(100*Double(self.mGoals)/Double(self.matchCount))/100))
                        self.myShot.text = String(format: "%.02f", Double(round(100*Double(self.mShots)/Double(self.matchCount))/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(100*Double(self.mShotT)/Double(self.matchCount))/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(100*Double(self.mCorner)/Double(self.matchCount))/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(100*Double(self.mTackle)/Double(self.matchCount))/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(100*Double(self.mFoul)/Double(self.matchCount))/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(100*Double(self.oGoals)/Double(self.matchCount))/100))
                        self.opShot.text = String(format: "%.02f", Double(round(100*Double(self.oShots)/Double(self.matchCount))/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(100*Double(self.oShotT)/Double(self.matchCount))/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(100*Double(self.oCorner)/Double(self.matchCount))/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(100*Double(self.oTackle)/Double(self.matchCount))/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(100*Double(self.oFoul)/Double(self.matchCount))/100))
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime))/100))
                    } else {
                        
                        let averageNum = Double(round(100*Double(self.totalTime)/Double(90))/100)
                        
                        self.myScore.text = String(format: "%.02f", Double(round(Double(self.mGoals)/averageNum*100)/100))
                        self.myShot.text = String(format: "%.02f", Double(round(Double(self.mShots)/averageNum*100)/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(Double(self.mShotT)/averageNum*100)/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(Double(self.mCorner)/averageNum*100)/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(Double(self.mTackle)/averageNum*100)/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(Double(self.mFoul)/averageNum*100)/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(Double(self.oGoals)/averageNum*100)/100))
                        self.opShot.text = String(format: "%.02f", Double(round(Double(self.oShots)/averageNum*100)/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(Double(self.oShotT)/averageNum*100)/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(Double(self.oCorner)/averageNum*100)/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(Double(self.oTackle)/averageNum*100)/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(Double(self.oFoul)/averageNum*100)/100))
                        
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime)/Double(self.matchCount))/100))
                        
                    }
                }
                self.loading.stopAnimating()
                self.loading.isHidden = true
        }
    }
    
    func getCurrentWeekendData(){
        self.loading.isHidden = false
        self.loading.startAnimating()
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isEqualTo: self.weekNum)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loading.stopAnimating()
                    self.loading.isHidden = true
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        if dbData["My Shots"] != nil {
                            let obj = MyScoreData()
                            let checkVal = obj.checkIsInt(data: dbData)
                            
                            if checkVal == 1 {
                                self.mGoals += Int(dbData["MyScore"] as! String)!
                                self.oGoals += Int(dbData["OpScore"] as! String)!
                                self.mShots += Int(dbData["My Shots"] as! String)!
                                self.oShots += Int(dbData["Op Shots"] as! String)!
                                self.mShotT += Int(dbData["My Shots on Targets"] as! String)!
                                self.oShotT += Int(dbData["Op Shots on Targets"] as! String)!
                                self.mCorner += Int(dbData["My Corners"] as! String)!
                                self.oCorner += Int(dbData["Op Corners"] as! String)!
                                self.mTackle += Int(dbData["My Tackles"] as! String)!
                                self.oTackle += Int(dbData["Op Tackles"] as! String)!
                                self.mFoul += Int(dbData["My Fouls"] as! String)!
                                self.oFoul += Int(dbData["Op Fouls"] as! String)!
                                
                                self.mShotAccu += Int(dbData["My Shot Accuracy %"] as! String)!
                                self.oShotAccu += Int(dbData["Op Shot Accuracy %"] as! String)!
                                self.mPassAccu += Int(dbData["My Pass Accuracy %"] as! String)!
                                self.oPassAccu += Int(dbData["Op Pass Accuracy %"] as! String)!
                                self.mPoss += Int(dbData["My Possession %"] as! String)!
                                self.oPoss += Int(dbData["Op Possession %"] as! String)!
                                
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
                                }
                                else if Int(dbData["MyScore"] as! String)! < Int(dbData["OpScore"] as! String)! {
                                    self.lossCount += 1
                                }
                            }
                        }
                    }
                    /*************         cast value to Non Average       *******************/
                    self.myTotalScore.text = String(self.mGoals)
                    self.myTotalShot.text = String(self.mShots)
                    self.myTotalTarget.text = String(self.mShotT)
                    self.myTotalCorner.text = String(self.mCorner)
                    self.myTotalTackle.text = String(self.mTackle)
                    self.myTotalFoul.text = String(self.mFoul)
                    
                    self.opTotalScore.text = String(self.oGoals)
                    self.opTotalShot.text = String(self.oShots)
                    self.opTotalTarget.text = String(self.oShotT)
                    self.opTotalCorner.text = String(self.oCorner)
                    self.opTotalTackle.text = String(self.oTackle)
                    self.opTotalFoul.text = String(self.oFoul)
                    
                    self.TotalRangeQuit.text = String(self.RageQuit)
                    self.TotalCount.text = String(self.matchCount)
                    self.TotalTime.text = String(self.totalTime)
                    self.TotalWin.text = String(self.winCount)
                    self.TotalLoss.text = String(self.lossCount)
                    
                    /*************         cast value to Average       *******************/
                    if self.RageQuit == 0 && self.isExtra == 0 {
                        self.myScore.text = String(format: "%.02f", Double(round(100*Double(self.mGoals)/Double(self.matchCount))/100))
                        self.myShot.text = String(format: "%.02f", Double(round(100*Double(self.mShots)/Double(self.matchCount))/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(100*Double(self.mShotT)/Double(self.matchCount))/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(100*Double(self.mCorner)/Double(self.matchCount))/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(100*Double(self.mTackle)/Double(self.matchCount))/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(100*Double(self.mFoul)/Double(self.matchCount))/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(100*Double(self.oGoals)/Double(self.matchCount))/100))
                        self.opShot.text = String(format: "%.02f", Double(round(100*Double(self.oShots)/Double(self.matchCount))/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(100*Double(self.oShotT)/Double(self.matchCount))/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(100*Double(self.oCorner)/Double(self.matchCount))/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(100*Double(self.oTackle)/Double(self.matchCount))/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(100*Double(self.oFoul)/Double(self.matchCount))/100))
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime))/100))
                    } else {
                        
                        let averageNum = Double(round(100*Double(self.totalTime)/Double(90))/100)
                        
                        self.myScore.text = String(format: "%.02f", Double(round(Double(self.mGoals)/averageNum*100)/100))
                        self.myShot.text = String(format: "%.02f", Double(round(Double(self.mShots)/averageNum*100)/100))
                        self.myTarget.text = String(format: "%.02f", Double(round(Double(self.mShotT)/averageNum*100)/100))
                        self.myAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.mShotAccu)/Double(self.matchCount))/100))
                        self.myPass.text = String(format: "%.02f", Double(round(100*Double(self.mPassAccu)/Double(self.matchCount))/100))
                        self.myPossesion.text = String(format: "%.02f", Double(round(100*Double(self.mPoss)/Double(self.matchCount))/100))
                        self.myCorner.text = String(format: "%.02f", Double(round(Double(self.mCorner)/averageNum*100)/100))
                        self.myTackle.text = String(format: "%.02f", Double(round(Double(self.mTackle)/averageNum*100)/100))
                        self.myFoul.text = String(format: "%.02f", Double(round(Double(self.mFoul)/averageNum*100)/100))
                        
                        self.opScore.text = String(format: "%.02f", Double(round(Double(self.oGoals)/averageNum*100)/100))
                        self.opShot.text = String(format: "%.02f", Double(round(Double(self.oShots)/averageNum*100)/100))
                        self.opTarget.text = String(format: "%.02f", Double(round(Double(self.oShotT)/averageNum*100)/100))
                        self.opAccuracy.text = String(format: "%.02f", Double(round(100*Double(self.oShotAccu)/Double(self.matchCount))/100))
                        self.opPass.text = String(format: "%.02f", Double(round(100*Double(self.oPassAccu)/Double(self.matchCount))/100))
                        self.opPossesion.text = String(format: "%.02f", Double(round(100*Double(self.oPoss)/Double(self.matchCount))/100))
                        self.opCorner.text = String(format: "%.02f", Double(round(Double(self.oCorner)/averageNum*100)/100))
                        self.opTackle.text = String(format: "%.02f", Double(round(Double(self.oTackle)/averageNum*100)/100))
                        self.opFoul.text = String(format: "%.02f", Double(round(Double(self.oFoul)/averageNum*100)/100))
                        
                        self.time.text = String(format: "%.02f", Double(round(100*Double(self.totalTime)/Double(self.matchCount))/100))
                        
                    }
                }
                self.loading.stopAnimating()
                self.loading.isHidden = true
        }
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
}
