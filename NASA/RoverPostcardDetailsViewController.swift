//
//  RoverPostcardDetailsViewController.swift
//  NASA
//
//  Created by Alexey Papin on 22.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import MessageUI

class RoverPostcardDetailsViewController: UIViewController {
    var photo: MarsRoverPhoto?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTextButton: UIBarButtonItem!
    @IBOutlet weak var sendEmailButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.addTextButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.sendEmailButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.undoButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        
        self.undoPressed(nil)
    }
}

extension RoverPostcardDetailsViewController {
    
    @IBAction func savePressed(_ sender: Any) {
        if let image = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            self.showAlert(title: MarsRoverError.title, message: MarsRoverError.nothingToSave.message, style: .alert)
        }
    }
    
    @IBAction func addTextPressed(_ sender: Any) {
        self.showPrompt(title: "Enter text", message: nil, placeholder: "text") { text in
            guard let text = text else {
                return
            }
            let newImage = self.imageView.image?.addText(text, font: AppFont.sanFranciscoMedium(size: 20.0).font, color: .white, atPoint: CGPoint(x: 10, y: 10))
            self.imageView.image = newImage
        }
    }
    
    @IBAction func sendEmailPressed(_ sender: Any) {
        guard
            let fileName = self.photo?.title,
            let image = self.imageView.image,
            let data = UIImagePNGRepresentation(image)
            else {
                return
        }
        let mailController = MFMailComposeViewController()
        mailController.addAttachmentData(data, mimeType: "image/png", fileName: fileName)
        mailController.setMessageBody("This image was created by NASA App.", isHTML: false)
        mailController.setSubject("Image of Mars Rover \(fileName)")
        self.present(mailController, animated: true, completion: nil)
    }
    
    @IBAction func undoPressed(_ sender: Any?) {
        self.imageView.image = nil
        guard
            let photo = self.photo,
            let url = photo.securedUrl
            else {
                return
        }
        self.navigationItem.title = photo.title
        Nuke.loadImage(with: url, into: self.imageView)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard let error = error else {
            if let photo = self.photo {
                self.showAlert(title: "Image saved", message: "Image \(photo.title) successfully saved in photo library.", style: .actionSheet, sender: self.imageView)
            } else {
                self.showAlert(title: "Image saved", message: "Unknown Image (?) successfully saved in photo library.", style: .actionSheet, sender: self.imageView)
            }
            return
        }
        self.showAlert(title: MarsRoverError.title, message: MarsRoverError.savingError(error).message, style: .alert)
    }
}
