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
    
    let apiClient = NASAAPIClient(config: .default)
    let rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var currentRover: NASAEndpoints.Rover? {
        didSet {
            guard let rover = self.currentRover else {
                return
            }
            self.roverImageView.image = rover.photo
        }
    }
    var cameras: [NASAEndpoints.Rover.Camera] {
        guard let currentRover = self.currentRover else {
            return []
        }
        return currentRover.cameras
    }
    var currentCamera: NASAEndpoints.Rover.Camera?
    var photos: [MarsRoverPhoto] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.currentRover = self.rovers.first
        self.currentCamera = self.cameras.first
        self.pickerView.reloadComponent(1)
    }
}

typealias MarsRoverPhotoArray = [MarsRoverPhoto]

// MARK: - Handle Events
extension RoverViewController {
    @IBAction func getPhotosPressed() {
        guard
            let rover = self.currentRover,
            let camera = self.currentCamera,
            let dateString = self.dateTextField.text
            else {
                return
        }
        let date = dateString.toDate

        apiClient.fetch(endpoint: .Mars(.Earth(rover, date: date, camera: camera, page: nil))) { (result: APIResult<MarsRoverResponseWithArray<MarsRoverPhoto>>) in
            switch result {
            case .Success(let response):
                self.photos = response.results
            case .Failure(let error):
                print("\(error)")
            }
        }
    }
    
    @IBAction func manifestPressed() {
        guard let rover = self.currentRover else {
            return
        }
        apiClient.fetch(endpoint: .Mars(.Manifest(rover))) { (result: APIResult<MarsRoverPhotoManifest>) in
            switch result {
            case .Success(let manifest):
                print("\(manifest.debugInfo)")
            case .Failure(let error):
                print("\(error)")
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
            self.pickerView.reloadComponent(1)
        case 1:
            self.currentCamera = self.cameras[self.pickerView.selectedRow(inComponent: 1)]
        default:
            break
        }
    }
}

extension RoverViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MarsRoverPhotoCell", for: indexPath) as! MarsRoverPhotoCell
        let photo = self.photos[indexPath.row]
        guard let url = photo.securedUrl else {
            return cell
        }
        cell.imageView.downloadedFrom(url: url)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension RoverViewController: UICollectionViewDelegate {
    
}
