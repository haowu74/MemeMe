//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 15/2/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
   
    // Mark: member variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memeIndex: Int?
    
    // Mark: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // Mark: overridden functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTouched))
        self.navigationItem.rightBarButtonItem = editButton
        self.imageView!.image = appDelegate.memes[memeIndex!].memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExistingMeme" {
            let photoVC = segue.destination as! PhotoViewController
            let index = sender as! Int
            photoVC.memedIndex = index
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    // Mark: callback functions
    @objc func editButtonTouched(_ sender: Any) {
         performSegue(withIdentifier: "editExistingMeme", sender: memeIndex)
    }
}
