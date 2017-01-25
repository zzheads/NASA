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

class LandsatImageViewController: UIViewController {
    var location: CLLocationCoordinate2D?
    var header: LandsatImageHeader?
    let apiClient = NASAAPIClient()
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let header = self.header,
            let location = self.location
            else {
                self.showAlertAndDismiss(title: "Loading Landsat8 Image error", message: "Can not load image, DO NOT get any location and date.", style: .alert)
                return
        }
        let endpoint = NASAEndpoints.Earth(NASAEndpoints.EarthEndpoint.Imagery(location, header.dateWithoutTime, false))
        self.apiClient.fetch(endpoint: endpoint) { (result: APIResult<LandsatImage>) in
            switch result {
            case .Success(let image):
                Nuke.loadImage(with: image.securedUrl, into: self.imageView)
                self.navigationItem.title = "Landsat8 image of (\(location.latitude),\(location.longitude)) taken \(header.dateWithoutTime.toDate?.toShortLocalString):"
            case .Failure(let error):
                self.showAlertAndDismiss(title: "Loading image error", message: "\(error)", style: .alert)
            }
        }
    }
}


// MARK: - Handle Events
extension LandsatImageViewController {
    @IBAction func savePressed(_ sender: Any) {
    }
}
