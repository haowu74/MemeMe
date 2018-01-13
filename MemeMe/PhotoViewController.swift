//
//  ViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 12/1/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2.0]
    
    
    // Mark: overridden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.text = topDefaultText
        topTextField.textAlignment = .center
        topTextField.delegate = self
        bottomTextField.text = bottomDefaultText
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
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
    // Mark: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Mark: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

