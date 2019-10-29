//
//  UIDropDown.swift
//  UIDropDown
//
//  Created by Isaac Gongora on 13/11/15.
//  Copyright © 2015 Isaac Gongora. All rights reserved.
//

import UIKit

public class UIDropDown: UIControl {

    fileprivate var title: UILabel!
    fileprivate var table: UITableView!
    
    public fileprivate(set) var selectedIndex: Int?
    public var options = [String]()
    public var placeholder: String! {
        didSet {
            title.text = placeholder
            title.adjustsFontSizeToFitWidth = true
        }
    }

    // Text
    public var font: String? {
        didSet {
            title.font = UIFont(name: font!, size: fontSize)
        }
    }
    public var fontSize: CGFloat = 17.0 {
        didSet{
            title.font = title.font.withSize(fontSize)
        }
    }
    public var textColor: UIColor? {
        didSet{
            title.textColor = textColor
        }
    }
    public var textAlignment: NSTextAlignment? {
        didSet{
            title.textAlignment = textAlignment!
        }
    }
    
    // Border
    public var cornerRadius: CGFloat = 3.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    public var borderWidth: CGFloat = 0.5 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    public var borderColor: UIColor = .white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    // Table Configurations

    public var tableHeight: CGFloat = 150.0
    public var rowHeight: CGFloat?
    public var rowBackgroundColor: UIColor?
    
    // Closures
    fileprivate var privatedidSelect: (String, Int) -> () = {option, index in }
    fileprivate var privateTableWillAppear: () -> () = { }
    fileprivate var privateTableDidAppear: () -> () = { }
    fileprivate var privateTableWillDisappear: () -> () = { }
    fileprivate var privateTableDidDisappear: () -> () = { }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    // Class methods
    public func resign() -> Bool {
        if isSelected {
            hideTable()
        }
        return true
    }
    
    fileprivate func setup() {
        
        title = UILabel(frame: CGRect(x: 0,
                                      y: 0,
                                      width: self.frame.width,
                                      height: self.frame.height))
        title.backgroundColor = UIColor.clear
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.font = UIFont(name: "Din Pro", size: 17)
        self.addSubview(title)
        
        self.addTarget(self, action: #selector(touch), for: .touchUpInside)
    }
    
    @objc fileprivate func touch() {
        isSelected = !isSelected
        isSelected ? showTable() : hideTable()
    }
    
    fileprivate func showTable() {
        
        privateTableWillAppear()
        
        table = UITableView(frame: CGRect(x: self.frame.minX,
                                          y: self.frame.minY,
                                          width: self.frame.width,
                                          height: self.frame.height))
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.layer.cornerRadius = cornerRadius
        table.layer.borderWidth = borderWidth
        table.layer.borderColor = borderColor.cgColor
        table.rowHeight = 30
        table.backgroundColor = UIColor.clear
        table.backgroundView = UIImageView(image: UIImage(named: "bk_main"))
        self.superview?.insertSubview(table, belowSubview: self)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: {
                        
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.maxY,
                                                  width: self.frame.width,
                                                  height: self.tableHeight)
                        self.table.alpha = 1
                        
        }, completion: { (finished) in
            self.privateTableDidAppear()
        })
    }
    
    fileprivate func hideTable() {
        
        privateTableWillDisappear()
       
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.minY,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.table.alpha = 0
            },
                       completion: { (didFinish) -> Void in
                        self.table.removeFromSuperview()
                        self.isSelected = false
                        self.privateTableDidDisappear()
        })
    }
    
    // Actions Methods
    public func didSelect(completion: @escaping (_ option: String, _ index: Int) -> ()) {
        privatedidSelect = completion
    }
    
    public func tableWillAppear(completion: @escaping () -> ()) {
        privateTableWillAppear = completion
    }
    
    public func tableDidAppear(completion: @escaping () -> ()) {
        privateTableDidAppear = completion
    }
    
    public func tableWillDisappear(completion: @escaping () -> ()) {
        privateTableWillDisappear = completion
    }
    
    public func tableDidDisappear(completion: @escaping () -> ()) {
        privateTableDidDisappear = completion
    }
}

extension UIDropDown: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UIDropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if rowBackgroundColor != nil {
            cell!.contentView.backgroundColor = rowBackgroundColor
        }
        
        cell!.textLabel!.font = UIFont(name: "Din Pro", size: fontSize)
        cell!.textLabel!.textColor = UIColor.white
        cell!.textLabel!.textAlignment = textAlignment ?? cell!.textLabel!.textAlignment
        cell!.textLabel!.text = "Weekend League \(options[indexPath.row])"
        //cell!.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell!.selectionStyle = .none
        cell!.backgroundColor = UIColor.clear
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = (indexPath as NSIndexPath).row
        
        title.alpha = 0.0
        title.text = "\(self.options[(indexPath as NSIndexPath).row])"
        
        UIView.animate(withDuration: 0.6,
                       animations: { () -> Void in
                        self.title.alpha = 1.0
        })
        
        tableView.reloadData()
        
        hideTable()
        
        privatedidSelect("\(self.options[indexPath.row])", selectedIndex!)
    }
}
