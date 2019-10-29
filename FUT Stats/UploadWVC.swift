//
//  WaitViewController.swift
//
//  Created by mmh on 22/02/2018.
//  Copyright © 2018 mmh. All rights reserved.
//
// import class
import Foundation
import UIKit
// WaitView class
private class WaitView: UIView {
    // variable
    // Indicator
    let mActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    // bounding box
    let mBoundingBoxView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    // message
    let mMessageLabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let mMessageLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    ////////////////////////////////////////////////////////////////////////
    // init
    //
    // inp: none
    // out: none
    ////////////////////////////////////////////////////////////////////////
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        // background color
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        mBoundingBoxView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        mBoundingBoxView.layer.cornerRadius = 12.0
        // animation start
        mActivityIndicatorView.startAnimating()
        // text set
        mMessageLabel1.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        mMessageLabel1.textColor = UIColor.white
        mMessageLabel1.textAlignment = .left
        mMessageLabel1.shadowColor = UIColor.black
        mMessageLabel1.shadowOffset = CGSize(width: 0.0, height: 1.0)
        mMessageLabel1.numberOfLines = 0
        
        mMessageLabel2.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        mMessageLabel2.textColor = UIColor.white
        mMessageLabel2.textAlignment = .left
        mMessageLabel2.shadowColor = UIColor.black
        mMessageLabel2.shadowOffset = CGSize(width: 0.0, height: 1.0)
        mMessageLabel2.numberOfLines = 0
        // Add the sub view
        addSubview(mBoundingBoxView)
        addSubview(mActivityIndicatorView)
        addSubview(mMessageLabel1)
        addSubview(mMessageLabel2)
    }
    ////////////////////////////////////////////////////////////////////////
    // init
    //
    // inp: coder - decode data
    // out: none
    ////////////////////////////////////////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ////////////////////////////////////////////////////////////////////////
    // sub view set
    //
    // inp: none
    // out: none
    ////////////////////////////////////////////////////////////////////////
    override func layoutSubviews() {
        super.layoutSubviews()
        // Bounding box setting
        mBoundingBoxView.frame.size.width = 250.0
        mBoundingBoxView.frame.size.height = 100.0
        mBoundingBoxView.frame.origin.x =
            ceil((bounds.width / 2.0) - (mBoundingBoxView.frame.width / 2.0))
        mBoundingBoxView.frame.origin.y =
            ceil((bounds.height / 2.0) - (mBoundingBoxView.frame.height / 2.0))
        // Indicator setting
        mActivityIndicatorView.frame.origin.x =
            ceil((bounds.width / 2.0) - (mActivityIndicatorView.frame.width / 2.0))
        mActivityIndicatorView.frame.origin.y =
            ceil((bounds.height / 2.0) - (mActivityIndicatorView.frame.height / 2.0))
        // Massage setting
        mMessageLabel1.frame.size.width = mBoundingBoxView.frame.size.width
        mMessageLabel1.frame.size.height = 25
        mMessageLabel1.frame.origin.x =
            ceil((bounds.width / 2.0) - (mMessageLabel1.frame.width / 2.0))
        mMessageLabel1.frame.origin.y = mActivityIndicatorView.frame.origin.y + mActivityIndicatorView.frame.height
        
        mMessageLabel2.frame.size.width = mBoundingBoxView.frame.size.width
        mMessageLabel2.frame.size.height = 50
        mMessageLabel2.frame.origin.x =
            ceil((bounds.width / 2.0) - (mMessageLabel2.frame.width / 2.0))
        mMessageLabel2.frame.origin.y = mMessageLabel1.frame.origin.y + mMessageLabel1.frame.size.height
    }
}
// WaitViewController class
class UploadWVC: UIViewController {
    // variable
    private let mWaitView = WaitView()
    ////////////////////////////////////////////////////////////////////////
    // init
    //
    // inp: message - waiting message
    // out: none
    ////////////////////////////////////////////////////////////////////////
    init(message1: String, message2: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        mWaitView.mMessageLabel1.text = message1
        mWaitView.mMessageLabel2.text = message2
        view = mWaitView
    }
    ////////////////////////////////////////////////////////////////////////
    // init
    //
    // inp: coder - decode data
    // out: none
    ////////////////////////////////////////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
