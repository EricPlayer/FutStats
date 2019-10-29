//
//  File.swift
//  Meeting
//
//  Created by POLARIS on 02/28/18.
//  Copyright © 2018 POLARIS. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    fileprivate var showImageContainerView: UIView?
    fileprivate var showImageView: UIImageView?
    var paramImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        maxZoomScale = 2.0
        showImageContainerView = UIView(frame: view.bounds)
        showImageContainerView?.backgroundColor = UIColor.black
        view.addSubview(showImageContainerView!)
        
        showImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50))
        showImageView?.contentMode = .scaleAspectFit
        showImageContainerView?.addSubview(showImageView!)
        showImageContainerView?.isHidden = true
        
        let buttonContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        buttonContainerView.backgroundColor = UIColor.black
        showImageContainerView?.addSubview(buttonContainerView)

        let giveupButton = UIButton(frame: CGRect(x: buttonContainerView.frame.origin.x + 20, y: 10, width: 100, height: 30))
        giveupButton.setTitle("Retake", for: .normal)
        giveupButton.setTitleColor(UIColor.white, for: .normal)
        giveupButton.addTarget(self, action: #selector(giveupImageAction), for: .touchUpInside)
        buttonContainerView.addSubview(giveupButton)
        
        let ensureButton = UIButton(frame: CGRect(x: buttonContainerView.frame.width - 120, y: 10, width: 100, height: 30))
        ensureButton.setTitle("Use Photo", for: .normal)
        ensureButton.setTitleColor(UIColor.white, for: .normal)
        ensureButton.addTarget(self, action: #selector(useImageAction), for: .touchUpInside)
        buttonContainerView.addSubview(ensureButton)
        
        backButton.isHidden = true
        backButton.isEnabled = false
        flashButton.isHidden = true
        flashButton.isEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCrop" {
            let cropVC = segue.destination as! CropViewController
            cropVC.image = sender as! UIImage
            cropVC.delegate = self
        }
    }
    
    func edit(image: UIImage) {
        self.performSegue(withIdentifier: "showCrop", sender: image)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage, didData imageData: Data ) {
        showImageContainerView?.isHidden = false
        self.showImageView?.image = photo
        self.paramImage = photo
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: UIImage(named: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func toggleFlashTapped(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(UIImage(named: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(UIImage(named: "flashOutline"), for: UIControlState())
        }
    }
    
    @objc private func giveupImageAction() {
        showImageView?.image = UIImage()
        showImageContainerView?.isHidden = true
    }
    
    @objc private func useImageAction() {
        showImageView?.image = UIImage()
        showImageContainerView?.isHidden = true
        self.edit(image: paramImage!)
    }
}

extension CameraViewController: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        ImageData.sharedInstance.cropImage = croppedImage
        _ = controller.dismiss(animated: true)
        self.dismiss(animated: false)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.dismiss(animated: true)
        self.dismiss(animated: false)
    }
}

