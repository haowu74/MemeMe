//
//  Meme.swift
//  MemeMe
//
//  Created by Hao Wu on 16/1/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
