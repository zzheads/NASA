//
//  LandsatImageViewController.swift
//  NASA
//
//  Created by Alexey Papin on 25.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Nuke
import MessageUI

class LandsatImageViewController: UIViewController {
    var location: CLLocationCoordinate2D?
    var header: LandsatImageHeader?
    var picTitle: String {
        guard
        let location = self.location,
        let header = self.header,
        let date = header.dateWithoutTime.toDate
            else {
                return "unknown Landsat8Image"
        }
        return "Landsat8Image of (\(location.latitude),\(location.longitude)) taken \(date.toShortLocalString)"
    }
    
    let apiClient = NASAAPIClient(delegate: nil, delegateQueue: nil)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var sendEmailButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)
        self.sendEmailButton.setTitleTextAttributes([NSFontAttributeName: AppFont.sanFranciscoMedium(size: 14.0).font], for: .normal)

        
        guard
            let header = self.header,
            let location = self.location
            else {
                self.showAlertAndDismiss(title: LandsatError.title, message: LandsatError.noInfo.message, style: .alert)
                return
        }
        let endpoint = NASAEndpoints.Earth(NASAEndpoints.EarthEndpoint.Imagery(location, header.dateWithoutTime, false))
        self.apiClient.fetch(endpoint: endpoint) { (result: APIResult<LandsatImage>) in
            switch result {
            case .Success(let image):
                Nuke.loadImage(with: image.securedUrl, into: self.imageView)
                self.navigationItem.title = self.picTitle
            case .Failure(let error):
                self.showAlertAndDismiss(title: LandsatError.title, message: LandsatError.loadingImage(error).message, style: .alert)
            }
        }
    }
}

// MARK: - Handle Events
extension LandsatImageViewController {
    func savePressed(_ sender: Any) {
        if let image = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            self.showAlert(title: LandsatError.title, message: LandsatError.nothingToSave.message, style: .alert)
        }
    }
    
    func sendEmailPressed(_ sender: Any) {
        guard
            let image = self.imageView.image,
            let data = UIImagePNGRepresentation(image)
            else {
                return
        }
        let mailController = MFMailComposeViewController()
        mailController.addAttachmentData(data, mimeType: "image/png", fileName: self.picTitle)
        mailController.setMessageBody("This image was created by NASA App.", isHTML: false)
        mailController.setSubject(self.picTitle)
        self.present(mailController, animated: true, completion: nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard let error = error else {
            self.showAlert(title: "Image saved", message: "\(self.picTitle) successfully saved in photo library.", style: .actionSheet, sender: self.imageView)
            return
        }
        self.showAlert(title: LandsatError.title, message: LandsatError.savingImage(error).message, style: .alert)
    }
}
