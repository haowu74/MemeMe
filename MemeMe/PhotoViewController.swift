//
//  ViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 12/1/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Mark: IBOutlet
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    // Mark: IBAction
    
    @IBAction func cameraButtonTouched(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    @IBAction func albumButtonTouched(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    @IBAction func cancelButtonTouched(_ sender: Any) {
        topTextField.text = topDefaultText
        bottomTextField.text = bottomDefaultText
        imagePickerView.image = nil
    }
    @IBAction func shareButtonTouched(_ sender: Any) {
    }
    
    // Mark: member variables
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    
    // Mark: overridden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.text = topDefaultText
        topTextField.textAlignment = .center
        bottomTextField.text = bottomDefaultText
        bottomTextField.textAlignment = .center
        imagePickerView.image = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

    }
    
    @IBAction func topTextFIeldEditingDidBegin(_ sender: UITextField) {
        sender.text = ""
    }
    
    @IBAction func topTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = topDefaultText
        }
    }
    // Mark: delegation functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

