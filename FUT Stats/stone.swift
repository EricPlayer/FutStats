//
//  stone.swift
//  singletone
//
//  Created by admin on 19/02/2018.
//  Copyright © 2018 mmh. All rights reserved.
//

import Foundation
import UIKit

final class ImageData {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let sharedInstance = ImageData()
    
    // MARK: Local Variable
    
    var cropImage: UIImage?
    var isTakenPhoto = 0
}
