//
//  WeekEndViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/01/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase

class WeekEndViewController: UIViewController, XMLParserDelegate {

    var weekList = [String]()
    
    @IBOutlet var weekOrder: UILabel!
    @IBOutlet var btn_currentWL: UIButton!
    
    let loadingVC = WaitViewController(message: "Loading...")
    
    var payState = 1
    
    var weekEndXmlData = [WeekendData]()
    var foundCharacters = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weekOrder.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //Get past weekend list
        self.getPastWeekLeagueList()
        
        //Get Weekend order from xml file
        self.getWeekEndOrderFromXml()
        
        if payState == 0 {
            btn_currentWL.setImage(UIImage(named: "btn_cur_wl_lock"), for: .normal)
        } else {
            btn_currentWL.setImage(UIImage(named: "btn_cur_wl_unlock"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentWL_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentWVC") as? CurrentWeekEndViewController else {
            return
        }
        uvc.weekNum = self.weekOrder.text!
        self.present(uvc, animated: false)
    }
    
    @IBAction func pastWL_clk(_ sender: Any) {
        if self.weekList.count == 0 {
            let alert = UIAlertController(title: nil, message: "There is no any data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                return
            })
            self.present(alert, animated: true)
        } else {
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "PastWVC") as? PastWeekEndViewController else {
                return
            }
            uvc.realWeekList = self.weekList
            self.present(uvc, animated: false)
        }
    }
    
    @IBAction func compareWL_clk(_ sender: Any) {
        if self.weekList.count == 0 {
            let alert = UIAlertController(title: nil, message: "There is no any data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                return
            })
            self.present(alert, animated: true)
        } else {
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "CompareWVC") as? CompareWeekEndViewController else {
                return
            }
            uvc.compareWeekList = self.weekList
            self.present(uvc, animated: false)
        }
    }
    
    @IBAction func competitionWL_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ShowStatsVC") as? ShowStatsViewController else {
            return
        }
        uvc.viewType = 2
        self.present(uvc, animated: false)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getPastWeekLeagueList() {
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        var weekTemp = [String]()
        
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isGreaterThan: "0")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    
                } else {
                    for document in querySnapshot!.documents {
                        let dbData = document.data()
                        weekTemp.append(dbData["IdWeekendLeague"] as! String)
                    }
                }
                self.weekList.removeAll()
                if weekTemp.count > 0 {
                    var firstWeek = weekTemp[0]
                    self.weekList.append(firstWeek)
                    for i in 1..<weekTemp.count {
                        if firstWeek != weekTemp[i]{
                            self.weekList.append(weekTemp[i])
                            firstWeek = weekTemp[i]
                        }
                    }
                }
        }
    }
    
    func getWeekEndOrderFromXml() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let fileName = "WeekendLeagueIndex.xml"
        present(loadingVC, animated: true, completion: nil)
        
        let xmlRef = storageRef.child ("\(fileName)")
        xmlRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print ( error )
            } else {
                let parser = XMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                for i in 0..<self.weekEndXmlData.count {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                    let startDate = dateFormatter.date(from: self.weekEndXmlData[i].start)!
                    let endDate = dateFormatter.date(from: self.weekEndXmlData[i].end)!
                    
                    //print("\(self.weekEndXmlData[i].start)~~~~~\(self.weekEndXmlData[i].end)")
                    //print("\(startDate)~~~~~\(endDate)")
                    let fallsBetween = (startDate ... endDate).contains(Date())
                    if fallsBetween == true {
                        //print(self.weekEndXmlData[i].index)
                        self.weekOrder.text = self.weekEndXmlData[i].index
                        self.loadingVC.dismiss(animated: true,completion: nil)
                        return
                    } else {
                        self.loadingVC.dismiss(animated: true,completion: nil)
                    }
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "weekendleague" {
            let tempData = WeekendData()
            if let index = attributeDict["index"] {
                tempData.index = index
            }
            if let startTime = attributeDict["start"] {
                tempData.start = startTime
            }
            if let endTime = attributeDict["end"] {
                tempData.end = endTime
            }
            self.weekEndXmlData.append(tempData)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "FUTStats" {
            print("~~~~~parsing end~~~~")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
