//
//  APODViewController.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Nuke

class APODViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var explanationButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let apiClient = NASAAPIClient(config: .default)
    var currentAPOD: APOD? = nil {
        willSet {
            if let newValue = newValue {
                switch newValue.mediaType {
                case .image:
                    self.webView.isHidden = true
                    self.apodImageView.isHidden = false
                    if let url = newValue.secureUrl {
                        Nuke.loadImage(with: url, into: self.apodImageView)
                        self.navigationItem.title = "\(newValue.title)"
                    } else {
                        self.showAlert(title: "Error APOD url", message: "Can not make url with path: \(newValue.url)", style: .alert)
                    }
                    
                case .video:
                    self.apodImageView.image = nil
                    self.navigationItem.title = nil
                    self.webView.isHidden = false
                    self.apodImageView.isHidden = true
                    if let url = newValue.secureUrl {
                        if url.absoluteString.contains("youtube") {
                            self.webView.loadRequest(URLRequest(url: url))
                        } else {
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = AVPlayer(url: url)
                            self.present(playerViewController, animated: true) {
                                if let validPlayer = playerViewController.player {
                                    validPlayer.play()
                                }
                            }
                        }
                    } else {
                        self.showAlert(title: "Error APOD url", message: "Can not make url with path: \(newValue.url)", style: .alert)
                    }
                    
                case .unknown:
                    self.showAlert(title: "Error APOD", message: "Format of media is unknown: \(newValue.media_type)", style: .alert)
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.sendAction(Selector(("setHighlightsToday:")), to: nil, for: nil)
        self.datePicker.maximumDate = Date()
        self.saveButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFrancisco], for: .normal)
        self.datePickerValueChanged()
    }
}

// MARK: - Handle Events
extension APODViewController {
    
    @IBAction func savePressed(_ sender: Any) {
        guard let apod = self.currentAPOD else {
            self.showAlert(title: "Save error", message: "There is nothing to save", style: .alert)
            return
        }
        if let image = self.apodImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            if apod.mediaType == .image {
                self.showAlert(title: "Save error", message: "There is nothing to save", style: .alert)
            } else {
                self.showAlert(title: "Can not save", message: "Can not save \(apod.media_type) media to photo library.", style: .alert)
            }
        }
    }
    @IBAction func explanationPressed(_ sender: Any) {
        if let apod = self.currentAPOD {
            showAlert(title: "APOD Explanation", message: apod.explanation, style: .actionSheet, sender: self.apodImageView)
        }
    }
    
    @IBAction func datePickerValueChanged() {
        let date = self.datePicker.date
        if (date > Date()) {
            showAlert(title: "Incorrect Date", message: "You've choosen incorrect date, there is no APOD's for future dates. Please select date before or equal today.", style: .alert)
            return
        }
        self.apiClient.fetch(endpoint: NASAEndpoints.APOD(date: date, hd: true)) { (result: APIResult<APOD>) in
            switch result {
            case .Success(let apod):
                self.currentAPOD = apod
            case .Failure(let error):
                self.showAlert(title: "API Error", message: "\(error)", style: .alert)
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard let error = error else {
            if let apod = self.currentAPOD {
                self.showAlert(title: "Image saved", message: "Image \(apod.title) successfully saved in photo library.", style: .actionSheet, sender: self.apodImageView)
            } else {
                self.showAlert(title: "Image saved", message: "Unknown Image (?) successfully saved in photo library.", style: .actionSheet, sender: self.apodImageView)
            }
            return
        }
        self.showAlert(title: "Error saving", message: "Can not save an image, error: \(error)", style: .alert)
    }
}

// MARK: - Simple method for handling errors/warnings
extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension APODViewController {
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
}
