//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 15/2/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memeIndex: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = appDelegate.memes[memeIndex!].memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
