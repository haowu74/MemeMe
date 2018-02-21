//
//  PhotoViewControllerExtension.swift
//  MemeMe
//
//  Created by Hao Wu on 29/1/18.
//  Copyright © 2018 S&J. All rights reserved.
//

import UIKit

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
