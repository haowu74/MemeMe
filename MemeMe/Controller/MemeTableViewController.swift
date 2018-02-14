//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 14/2/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memes: [Meme]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
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
        

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
}