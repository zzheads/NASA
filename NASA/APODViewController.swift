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
    var buffer = Data()
    var expectedLength: Int64 = 0
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var explanationButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var apiClient: NASAAPIClient!
    
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
                        self.showAlert(title: APODError.title, message: APODError.badPath(newValue.url).message, style: .alert)
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
                        self.showAlert(title: APODError.title, message: APODError.badPath(newValue.url).message, style: .alert)
                    }
                    
                case .unknown:
                    self.showAlert(title: APODError.title, message: APODError.unknownMedia(newValue.media_type).message, style: .alert)
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiClient = NASAAPIClient(delegate: self, delegateQueue: nil)
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.sendAction(Selector(("setHighlightsToday:")), to: nil, for: nil)
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            self.datePicker.setDate(yesterday, animated: true)
        }
        self.datePicker.maximumDate = Date()
        self.saveButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.explanationButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.datePickerValueChanged()
    }
}

// MARK: - Handle Events
extension APODViewController {
    
    @IBAction func savePressed(_ sender: Any) {
        guard let apod = self.currentAPOD else {
            self.showAlert(title: APODError.title, message: APODError.nothingToSave.message, style: .alert)
            return
        }
        if let image = self.apodImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            if apod.mediaType == .image {
                self.showAlert(title: APODError.title, message: APODError.nothingToSave.message, style: .alert)
            } else {
                self.showAlert(title: APODError.title, message: APODError.saveUnknownMedia(apod.media_type).message, style: .alert)
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
            showAlert(title: APODError.title, message: APODError.incorrectDate.message, style: .alert)
            return
        }
        self.apiClient.fetch(endpoint: NASAEndpoints.APOD(date: date, hd: true)) { (result: APIResult<APOD>) in
            switch result {
            case .Success(let apod):
                self.currentAPOD = apod
            case .Failure(let error):
                self.showAlert(title: APODError.title, message: "\(error)", style: .alert)
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
        self.showAlert(title: APODError.title, message: APODError.savingError(error).message, style: .alert)
    }
}

extension APODViewController: URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.buffer.append(data)
        let percentageDownloaded = Float(buffer.count) / Float(self.expectedLength)
        print("Downloading \(percentageDownloaded)%...")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        self.expectedLength = response.expectedContentLength
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    
    }
}
