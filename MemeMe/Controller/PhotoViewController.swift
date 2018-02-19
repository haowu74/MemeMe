//
//  ViewController.swift
//  MemeMe
//
//  Created by Hao Wu on 12/1/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

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
        chooseSourceType(.camera)
    }
    @IBAction func albumButtonTouched(_ sender: Any) {
        chooseSourceType(.photoLibrary)
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        topTextField.text = topDefaultText
        bottomTextField.text = bottomDefaultText
        imagePickerView.image = nil

        topTextField.isEnabled = false
        bottomTextField.isEnabled = false
        shareButton.isEnabled = false
        if memedIndex == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func shareButtonTouched(_ sender: Any) {
        memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save()
                if self.memedIndex == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        shareController.popoverPresentationController?.sourceView = self.view
        self.present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func topTextFieldEditingDidBegin(_ sender: UITextField) {
        sender.text = ""
        shareButton.isEnabled = false

    }
    
    @IBAction func topTextFieldEditingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = topDefaultText
        }
        shareButton.isEnabled = true

    }
    
    @IBAction func bottomTextFieldEdittingDidBegin(_ sender: UITextField) {
        sender.text = ""
        shareButton.isEnabled = false

        
    }
    
    @IBAction func bottomTextFieldEdittingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = bottomDefaultText
        }
        
        shareButton.isEnabled = true

    }
    
    // Mark: member variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memedIndex: Int?
    var memedImage: UIImage?
    var meme: Meme?
    var topDefaultText = "TOP"
    var bottomDefaultText = "BOTTOM"
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "MarkerFelt-Wide", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -1.0
    ]
    
    // Mark: overridden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = memedIndex {
            memedImage = appDelegate.memes[index].originalImage
            topDefaultText = appDelegate.memes[index].topText!
            bottomDefaultText = appDelegate.memes[index].bottomText!
        }
        
        showMeme()
        
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Mark: member functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
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
        
        displayBars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        displayBars(hide: false)
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme =
            Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imagePickerView.image!,
            memedImage: memedImage!);
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func chooseSourceType(_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func configure (textField: UITextField, withText: String, withAttribute: [String: Any], enabled: Bool, alignment: NSTextAlignment, delegate: UITextFieldDelegate) {
        textField.defaultTextAttributes = withAttribute
        textField.text = withText
        textField.isEnabled = enabled
        textField.textAlignment = alignment
        textField.delegate = delegate
    }
    
    func displayBars(hide: Bool){
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func showMeme() {
        configure(textField: topTextField, withText: topDefaultText, withAttribute: memeTextAttributes, enabled: memedImage != nil, alignment: .center, delegate: self)
        configure(textField: bottomTextField, withText: bottomDefaultText, withAttribute: memeTextAttributes, enabled: memedImage != nil, alignment: .center, delegate: self)
        if let image = memedImage {
            imagePickerView.image = image
        } else {
            imagePickerView.image = nil
        }
        
    }
}

