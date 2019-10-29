//
//  MyScoreData.swift
//  FUT Stats
//
//  Created by admin on 2/6/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import Foundation
import UIKit

class MyScoreData {
    
    var mGoal: String = ""
    var oGoal: String = ""
    var mShots: String = ""
    var oShots: String = ""
    var mShotT: String = ""
    var oShotT: String = ""
    var mCorner: String = ""
    var oCorner: String = ""
    var mTackle: String = ""
    var oTackle: String = ""
    var mFoul: String = ""
    var oFoul: String = ""
    var totalTime: String = ""
    var RageQuit: String = ""
    var winCount: String = ""
    var lossCount: String = ""
    
    func checkIsInt(data: [String:Any]) -> Int {
        //print(data)
        let mGoal = Int(data["MyScore"] as! String)
        let oGoal = Int(data["OpScore"] as! String)
        let mShots = Int(data["My Shots"] as! String)
        let oShots = Int(data["Op Shots"] as! String)
        let mShotT = Int(data["My Shots on Targets"] as! String)
        let oShotT = Int(data["Op Shots on Targets"] as! String)
        let mCorner = Int(data["My Corners"] as! String)
        let oCorner = Int(data["Op Corners"] as! String)
        let mTackle = Int(data["My Tackles"] as! String)
        let oTackle = Int(data["Op Tackles"] as! String)
        let mFoul = Int(data["My Fouls"] as! String)
        let oFoul = Int(data["Op Fouls"] as! String)
        
        if mGoal != nil&&oGoal != nil&&mShots != nil&&oShots != nil&&mShotT != nil&&oShotT != nil&&mCorner != nil&&oCorner != nil&&mTackle != nil&&oTackle != nil&&mFoul != nil&&oFoul != nil {
            return 1
        } else {
            return -1
        }
    }
    
}
