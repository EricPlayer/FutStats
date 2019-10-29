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
    let mMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
        mMessageLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        mMessageLabel.textColor = UIColor.white
        mMessageLabel.textAlignment = .center
        mMessageLabel.shadowColor = UIColor.black
        mMessageLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        mMessageLabel.numberOfLines = 0
        // Add the sub view
        addSubview(mBoundingBoxView)
        addSubview(mActivityIndicatorView)
        addSubview(mMessageLabel)
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
        mBoundingBoxView.frame.size.width = 160.0
        mBoundingBoxView.frame.size.height = 160.0
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
        let messageLabelSize = mMessageLabel.sizeThatFits(CGSize(width: 160.0 - 20.0 * 2.0,
            height: Double(Float.greatestFiniteMagnitude)))
        mMessageLabel.frame.size.width = messageLabelSize.width
        mMessageLabel.frame.size.height = messageLabelSize.height
        mMessageLabel.frame.origin.x =
            ceil((bounds.width / 2.0) - (mMessageLabel.frame.width / 2.0))
        mMessageLabel.frame.origin.y = ceil(mActivityIndicatorView.frame.origin.y
            + mActivityIndicatorView.frame.size.height
            + ((mBoundingBoxView.frame.height - mActivityIndicatorView.frame.height) / 4.0)
            - (mMessageLabel.frame.height / 2.0))
    }
}
// WaitViewController class
class WaitViewController: UIViewController {
    // variable
    private let mWaitView = WaitView()
    ////////////////////////////////////////////////////////////////////////
    // init
    //
    // inp: message - waiting message
    // out: none
    ////////////////////////////////////////////////////////////////////////
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        mWaitView.mMessageLabel.text = message
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
