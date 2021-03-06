//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 14/2/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    
    // Mark: member variables
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // define the cell height in table view
    let cellHeight: CGFloat = 100.0
    
    var memes: [Meme]?
    
    // Mark: overridden functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes![(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText! + " " + meme.bottomText!
        cell.imageView?.image = meme.memedImage
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memeIndex = (indexPath as NSIndexPath).row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight;  //Choose custom row height
    }
}
