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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberOfPicsLabel: UILabel!
    @IBOutlet weak var enterSolLabel: UILabel!
    @IBOutlet weak var getPhotosButton: UIButton!
    
    var isRequestCorrect: Bool = false {
        didSet {
            let color = self.isRequestCorrect ? AppColor.blueCorrect.color : AppColor.redIncorrect.color
            self.getPhotosButton.backgroundColor = color
        }
    }
    let rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var currentRover: NASAEndpoints.Rover? {
        didSet {
            guard let rover = self.currentRover else {
                return
            }
            self.roverImageView.image = rover.photo
            if self.dataSource.isInitialized {
                let manifest = self.dataSource.manifests[self.pickerView.selectedRow(inComponent: 0)]
                self.enterSolLabel.text = "Enter Sol (max = \(manifest.max_sol))"
            }
        }
    }
    var cameras: [NASAEndpoints.Rover.Camera] {
        guard let currentRover = self.currentRover else {
            return []
        }
        return currentRover.cameras
    }
    var currentCamera: NASAEndpoints.Rover.Camera?
    var dataSource: RoversDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.dataSource = RoversDataSource(collectionView: self.collectionView, manifestsObserver: self)
        //self.collectionView.delegate = self
        self.currentRover = self.rovers.first
        self.currentCamera = self.cameras.first
        self.pickerView.reloadComponent(1)
        self.dateTextField.addTarget(self, action: #selector(self.dateTextFieldValueChanged), for: .editingChanged)
    }
}

// MARK: - Handle Events
extension RoverViewController {
    @IBAction func getPhotosPressed() {
        guard
            let rover = self.currentRover,
            let camera = self.currentCamera,
            let dateString = self.dateTextField.text,
            let sol = Int(dateString)
            else {
                return
        }
        self.dataSource.fetchPics(for: rover, sol: sol, camera: camera) { error in
            if let error = error as? NSError {
                if (error.code == 400) {
                    self.showAlert(title: "Loading pics error", message: "Photos NOT found.\n\n (\(error))", style: .alert)
                } else {
                    self.showAlert(title: "Loading pics error", message: "\(error)", style: .alert)
                }
            }
        }
    }
    
    @IBAction func dateTextFieldValueChanged() {
        self.isRequestCorrect = false
        guard
            let dateText = self.dateTextField.text,
            let sol = Int(dateText)
            else {
                self.numberOfPicsLabel.text = "Enter sol"
                return
        }
        if self.dataSource.isInitialized {
            let manifest = self.dataSource.manifests[self.pickerView.selectedRow(inComponent: 0)]
            if (sol >= 0 && sol <= manifest.max_sol) {
                if (sol == 0) {
                    self.numberOfPicsLabel.text = "\(manifest.total_photos) pics"
                    self.isRequestCorrect = true
                    return
                }
                guard let photoHeader = manifest.getPhotoHeader(for: sol) else {
                    self.numberOfPicsLabel.text = "0 pics"
                    return
                }
                self.numberOfPicsLabel.text = "\(photoHeader.total_photos) pics"
                self.isRequestCorrect = true
                return
            } else {
                self.numberOfPicsLabel.text = "Incorrect sol"
            }
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
        label.font = UIFont(name: "SanFranciscoDisplay-Medium", size: 13.0)
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
            self.dateTextFieldValueChanged()
            self.pickerView.reloadComponent(1)
        case 1:
            self.currentCamera = self.cameras[self.pickerView.selectedRow(inComponent: 1)]
        default:
            break
        }
    }
}

extension RoverViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSelectedPhoto") {
            guard
                let indexPaths = self.collectionView.indexPathsForSelectedItems,
                let indexPath = indexPaths.first
                else {
                    return
            }
            let selectedPhoto = self.dataSource.pics[indexPath.row]
            let controller = segue.destination as! RoverPostcardDetailsViewController
            controller.photo = selectedPhoto
        }
    }
}

extension RoverViewController: ManifestsChangedObserverType {
    func manifests(didChanged manifests: [MarsRoverPhotoManifest]) {
        if (manifests.count != self.rovers.count) {
            return
        }
        let manifest = manifests[self.pickerView.selectedRow(inComponent: 0)]
        self.enterSolLabel.text = "Enter Sol (max = \(manifest.max_sol))"
    }
}
