//
//  ExampleCropViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/7/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//



import UIKit
import HorizontalDial
import IGRPhotoTweaks

class CropViewController: IGRPhotoTweakViewController {
    
    /**
     Slider to change angle.
     */
    @IBOutlet weak fileprivate var angleLabel: UILabel?
    @IBOutlet weak fileprivate var horizontalDial: HorizontalDial? {
        didSet {
            self.horizontalDial?.migneticOption = .none
        }
    }
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: Themes Preview
    override open func setupThemes() {
        
        IGRCropLine.appearance().backgroundColor = UIColor.green
        //IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
        //IGRCropCornerView.appearance().backgroundColor = UIColor.purple
        IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
        //IGRCropMaskView.appearance().backgroundColor = UIColor.blue
        //IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
        //IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown
    }
    
    fileprivate func setupAngleLabelValue(radians: CGFloat) {
        let intDegrees: Int = Int(IGRRadianAngle.toDegrees(radians))
        self.angleLabel?.text = "\(intDegrees)°"
    }
    
    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.view.layoutIfNeeded()
        }) { (context) in
            //
        }
    }
    
    override open func customBorderColor() -> UIColor {
        return UIColor.red
    }
    
    override open func customBorderWidth() -> CGFloat {
        return 2.0
    }
    
    override open func customCornerBorderWidth() -> CGFloat {
        return 4.0
    }
    
    override open func customCornerBorderLength() -> CGFloat {
        return 30.0
    }
    
    override open func customIsHighlightMask() -> Bool {
        return true
    }
    
    override open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    // MARK: - Actions
    
    @IBAction func onTouchResetButton(_ sender: UIButton) {
        self.horizontalDial?.value = 0.0
        setupAngleLabelValue(radians: 0.0)
        
        self.resetView()
    }
    
    @IBAction func onTouchCancelButton(_ sender: UIButton) {
        self.dismissAction()
    }
    
    @IBAction func onTouchCropButton(_ sender: UIButton) {
        cropAction()
        ImageData.sharedInstance.isTakenPhoto = 1
    }
    
    override open func customCanvasHeaderHeigth() -> CGFloat {
        var heigth: CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            heigth = 40.0
        } else {
            heigth = 100.0
        }
        
        return heigth
    }
}

extension CropViewController: HorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        let degrees = horizontalDial.value
        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
        
        self.setupAngleLabelValue(radians: radians)
        self.changedAngle(value: radians)
    }
    
    func horizontalDialDidEndScroll(_ horizontalDial: HorizontalDial) {
        self.stopChangeAngle()
    }
}
