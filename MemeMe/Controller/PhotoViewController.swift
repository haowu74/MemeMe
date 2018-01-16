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
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextFieldBottomConstraint: NSLayoutConstraint!
    
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
        cancelButton.isEnabled = false
        topTextField.isEnabled = false
        bottomTextField.isEnabled = false
        self.view.endEditing(true)
    }
    
    @IBAction func shareButtonTouched(_ sender: Any) {
        memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func topTextFieldEditingDidBegin(_ sender: UITextField) {
        sender.text = ""
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
    @IBAction func topTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = topDefaultText
        }
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    @IBAction func bottomTextFieldEdittingDidBegin(_ sender: UITextField) {
        sender.text = ""
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        subscribeToKeyboardNotifications()
    }
    
    @IBAction func bottomTextFieldEdittingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = bottomDefaultText
        }
        unsubscribeFromKeyboardNotifications()
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    
    // Mark: member variables
    var memedImage: UIImage?
    var meme: Meme?
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "MarkerFelt-Wide", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -1.0
    ]
    
    // Mark: member functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let offset = getKeyboardHeight(notification)
        //I only want to move the bottom text field
        bottomTextFieldBottomConstraint.constant -= offset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let offset = getKeyboardHeight(notification)
        //I only want to move the bottom text field
        bottomTextFieldBottomConstraint.constant += offset
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        self.meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
        
    }
    
    // Mark: overridden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.text = topDefaultText
        
        topTextField.isEnabled = false
        topTextField.textAlignment = .center
        topTextField.delegate = self
        
        bottomTextField.text = bottomDefaultText
        bottomTextField.isEnabled = false
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        imagePickerView.image = nil
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
 
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    // Mark: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
            topTextField.text = topDefaultText
            bottomTextField.text = bottomDefaultText
            cancelButton.isEnabled = true
        }
        // Why the toolbar is always squeezed every time when UIImagePickerController is dismissed with imagePickerView.image being assigned? Is it a bug? Maybe we should create a separate ViewController 
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

