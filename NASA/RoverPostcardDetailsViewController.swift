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

class RoverPostcardDetailsViewController: UIViewController {
    var photo: MarsRoverPhoto?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var saveToGalleryButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let margin = width < height ? width / 40 : height / 40
        
        let freeHeight = height - margin * 6 - 40 * 5 - AppFont.sanFranciscoMedium(size: 14.0).font.lineHeight
        let freeWidth = width - margin * 2
        let sizeOfImage = freeWidth < freeHeight ? freeWidth : freeHeight
        
        switch (UIDevice.current.orientation) {
        case .landscapeLeft, .landscapeRight: self.backgroundImageView.image = #imageLiteral(resourceName: "ipad_background_hori_x2")
        default: self.backgroundImageView.image = #imageLiteral(resourceName: "ipad_background_port_x2")
        }
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.saveToGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        self.addTextButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendEmailButton.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.saveToGalleryButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.saveToGalleryButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            self.saveToGalleryButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -margin),
            self.saveToGalleryButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.addTextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.addTextButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -margin),
            self.addTextButton.bottomAnchor.constraint(equalTo: self.saveToGalleryButton.topAnchor, constant: -margin),
            self.addTextButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.addTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.addTextField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -margin),
            self.addTextField.bottomAnchor.constraint(equalTo: self.addTextButton.topAnchor, constant: -margin),
            self.addTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.sendEmailButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: margin),
            self.sendEmailButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            self.sendEmailButton.bottomAnchor.constraint(equalTo: self.saveToGalleryButton.topAnchor, constant: -margin),
            self.sendEmailButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.emailTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: margin),
            self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            self.emailTextField.bottomAnchor.constraint(equalTo: self.sendEmailButton.topAnchor, constant: -margin),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: margin),
            self.titleLabel.heightAnchor.constraint(equalToConstant: AppFont.sanFranciscoMedium(size: 14.0).font.lineHeight),
            self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            
            self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: margin),
            self.imageView.widthAnchor.constraint(equalToConstant: sizeOfImage),
            self.imageView.heightAnchor.constraint(equalToConstant: sizeOfImage),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        
        guard
            let photo = self.photo,
            let url = photo.securedUrl
            else {
            return
        }
        self.titleLabel.text = photo.title
        Nuke.loadImage(with: url, into: self.imageView)
    }

    @objc private func rotated() {
        self.imageView.removeConstraints(self.imageView.constraints)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let margin = width < height ? width / 40 : height / 40
        
        let freeHeight = height - margin * 6 - 40 * 5 - AppFont.sanFranciscoMedium(size: 14.0).font.lineHeight
        let freeWidth = width - margin * 2
        let sizeOfImage = freeWidth < freeHeight ? freeWidth : freeHeight
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: margin),
            self.imageView.widthAnchor.constraint(equalToConstant: sizeOfImage),
            self.imageView.heightAnchor.constraint(equalToConstant: sizeOfImage),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
    }
}

// MARK: - Handle Events
extension RoverPostcardDetailsViewController {
    @IBAction func sendToEmail() {
    }
    @IBAction func addTextPressed() {
        guard
        let image = self.imageView.image,
        let text = self.addTextField.text
            else {
                return
        }
        let point = CGPoint(x: 10, y: 10)
        let imageWithText = image.addText(text: text, with: .white, font: AppFont.sanFranciscoMedium(size: 14.0).font, atPoint: point)
        self.imageView.image = imageWithText
    }
    @IBAction func saveToGalleryPressed() {
    }
}
