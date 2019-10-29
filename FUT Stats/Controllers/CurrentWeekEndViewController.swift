//
//  CurrentWeekEndViewController.swift
//  FUT Stats
//
//  Created by POLARIS on 02/05/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import Firebase

class CurrentWeekEndViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let loadingVC = WaitViewController(message: "Loading...")

    @IBOutlet var mycollectionView: UICollectionView!
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var btn_compare: UIButton!
    
    var mDispatchGroup = DispatchGroup()
    
    let cellId = "CurrentButtonCell"
    var weekNum =  ""
    
    /*
     0:success
     1:unsuccess
     2:current processing
     3: next game
     4:available
     */
    var gameStat = [Int](repeating: 4, count: 40) //,
    var checkSate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mDispatchGroup = DispatchGroup()
        mDispatchGroup.enter()
        
        self.getWeekEndAllData()
        
        mDispatchGroup.notify(queue: .main) {
            print("Get all weekend data.")
            
            self.mycollectionView.reloadData()
            self.mycollectionView.register(CurrentButtonCell.self, forCellWithReuseIdentifier: self.cellId)
            self.mycollectionView.delegate = self
            self.mycollectionView.dataSource = self
            self.loadingVC.dismiss(animated: true,completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CurrentButtonCell
        cell.btn_state.isUserInteractionEnabled = false
        cell.btn_image.image = UIImage(named: "willplay")
        
        print("~~~~~\(self.gameStat.count)")
        if self.gameStat[indexPath.row] == 1 {
            cell.btn_image.image = UIImage(named: "errorplay")
        } else if self.gameStat[indexPath.row] == 0 {
            cell.btn_image.image = UIImage(named: "played")
        } else if self.gameStat[indexPath.row] == 2 {
            cell.btn_image.image = UIImage(named: "processing")
        } else if self.gameStat[indexPath.row] == 3 {
            cell.btn_image.image = UIImage(named: "toplay")
            cell.btn_state.isUserInteractionEnabled = true
            cell.btn_state.tag = indexPath.row
            cell.btn_state.addTarget(self, action: #selector(goToTakePhoto(_:)), for: .touchUpInside)
        } else {
            cell.btn_image.image = UIImage(named: "willplay")
        }
        cell.weekEndOrder.text = "\(indexPath.row + 1)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mycollectionView.frame.width / 4, height: mycollectionView.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @objc func goToTakePhoto(_ sender: UIButton) {
        let gameId = sender.tag + 1
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "UploadVC") as? UploadViewController else {
            return
        }
        uvc.gameId = gameId
        uvc.weekNum = self.weekNum
        self.present(uvc, animated: false)
    }
    
    @IBAction func currentWL_clk(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ShowStatsVC") as? ShowStatsViewController else {
            return
        }
        uvc.viewType = 3
        uvc.weekNum = self.weekNum
        self.present(uvc, animated: false)
    }
    
    @IBAction func back_clk(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getWeekEndAllData() {
        present(loadingVC, animated: true, completion: nil)
        let userId: String = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        db.collection("\(userId)")
            .whereField("IdWeekendLeague", isEqualTo: "\(self.weekNum)")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                    self.loadingVC.dismiss(animated: true,completion: nil)
                } else {
                    DispatchQueue.main.async() {
                        var arrayIdx = 0
                        for document in querySnapshot!.documents {
                            let dbData = document.data()
                            if dbData["My Shots"] != nil {
                                let obj = MyScoreData()
                                let checkVal = obj.checkIsInt(data: dbData)
                                if checkVal == 1 {
                                    self.gameStat[arrayIdx] = 0
                                    //self.gameStat.insert(0, at:arrayIdx)
                                } else {
                                    self.gameStat[arrayIdx] = 1
                                }
                            } else {
                                self.gameStat[arrayIdx] = 2
                            }
                            arrayIdx += 1
                        }
                        self.gameStat[arrayIdx] = 3
                    }
                    self.mDispatchGroup.leave()
                }
        }
    }
}

class CurrentButtonCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        self.addSubview(btn_image)
        self.addSubview(weekEndOrder)
        self.addSubview(btn_state)
        
        btn_image.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        
        btn_state.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        
        weekEndOrder.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 10)
    }
    
    let btn_image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let btn_state: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        return btn
    }()
    
    let weekEndOrder: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Din Pro", size: 17)
        lbl.textAlignment = .center
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat,
                paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
}
