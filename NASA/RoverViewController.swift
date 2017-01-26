//
//  RoverViewController.swift
//  NASA
//
//  Created by Alexey Papin on 21.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class RoverViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var manifestLabel: UILabel!
    
    let apiClient = NASAAPIClient(delegate: nil, delegateQueue: nil)
    let rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var manifests: [MarsRoverPhotoManifest] = [] {
        didSet {
            self.showManifestInfo()
        }
    }
    var currentRover: NASAEndpoints.Rover? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            self.roverImageView.image = newValue.photo
            self.showManifestInfo()
        }
    }
    var cameras: [NASAEndpoints.Rover.Camera] {
        guard let currentRover = self.currentRover else {
            return []
        }
        return currentRover.cameras
    }
    var currentCamera: NASAEndpoints.Rover.Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manifestLabel.sizeToFit()
        for rover in self.rovers {
            self.apiClient.fetch(endpoint: NASAEndpoints.Mars(NASAEndpoints.QueryPhoto.Manifest(rover))) { (result: APIResult<MarsRoverPhotoManifest>) in
                switch result {
                case .Success(let manifest):
                    self.manifests.append(manifest)
                case .Failure(let error):
                    self.showAlert(title: MarsRoverError.title, message: MarsRoverError.loadingManifest(rover.rawValue, error).message, style: .alert)
                }
            }
        }
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.dateTextField.addTarget(self, action: #selector(self.showManifestInfo), for: .allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.currentRover == nil) {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.currentRover = self.rovers.first
            self.pickerView.reloadComponent(1)
            self.pickerView.selectRow(self.cameras.count - 1, inComponent: 1, animated: true)
            self.currentCamera = self.cameras.last
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getPhotos") {
            let collectionViewController = segue.destination as! RoverPhotosCollectionViewController
            collectionViewController.rover = self.currentRover
            collectionViewController.camera = self.currentCamera
            if let enteredSol = self.dateTextField.text, let sol = Int(enteredSol) {
                collectionViewController.sol = sol
            } else {
                collectionViewController.sol = 0
            }
        }
    }
    
    @objc private func showManifestInfo() {
        if (self.manifests.count == self.rovers.count) {
            let manifest = manifests[self.pickerView.selectedRow(inComponent: 0)]
            var text = "Rover Name: \(manifest.name.capitalized)\n"
            text += "Status: \(manifest.status)\n"
            text += "Launch date: \(manifest.launch_date)\n"
            text += "Landing date: \(manifest.landing_date)\n"
            text += "Max Sol: \(manifest.max_sol)\n\n"
            if let enteredDateText = self.dateTextField.text, let sol = Int(enteredDateText) {
                if let photoHeader = manifest.getPhotoHeader(for: sol) {
                    text += "Number of pics for entered sol: \(photoHeader.total_photos)\n"
                } else {
                    text += "No photos for entered date"
                }
            } else {
                text += "Incorrect date"
            }
            self.manifestLabel.text = text
        }
    }
}

extension RoverViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return self.rovers.count
        case 1: return self.cameras.count
        default: return 0
        }
    }
}

extension RoverViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = AppFont.sanFranciscoMedium(size: 14.0).font
        label.textColor = AppColor.magentaLighten.color
        label.textAlignment = .center
        switch component {
        case 0: label.text = self.rovers[row].rawValue
        case 1: label.text = self.cameras[row].rawValue.uppercased()
            
        default:
            label.text = "unknown"
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.currentRover = self.rovers[self.pickerView.selectedRow(inComponent: 0)]
            self.pickerView.reloadComponent(1)
            pickerView.selectRow(self.cameras.count - 1, inComponent: 1, animated: true)
        case 1:
            self.currentCamera = self.cameras[self.pickerView.selectedRow(inComponent: 1)]
        default:
            break
        }
    }
}
