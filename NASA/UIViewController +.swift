//
//  UIViewController +.swift
//  NASA
//
//  Created by Alexey Papin on 24.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Simple methods for handling errors/warnings/prompts
extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, style: UIAlertControllerStyle, sender: UIView) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.modalPresentationStyle = .popover
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPrompt(title: String?, message: String?, placeholder: String?, completion: @escaping (String?) -> Void) {
        let promptController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        promptController.addTextField() { textField in
            if let placeholder = placeholder {
                textField.text = placeholder
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            guard
                let textFields = promptController.textFields,
                let first = textFields.first,
                let text = first.text
                else {
                    completion(nil)
                    return
            }
            completion(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        promptController.addAction(okAction)
        promptController.addAction(cancelAction)
        self.present(promptController, animated: true, completion: nil)
    }
}
