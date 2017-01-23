//
//  RoversDataSource.swift
//  NASA
//
//  Created by Alexey Papin on 22.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import Nuke
import UIKit

class RoversDataSource: NSObject {
    let apiClient = NASAAPIClient()
    var manifests: [MarsRoverPhotoManifest] = []
    var rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var validDates: [NASAEndpoints.Rover: [Int]] = [:]
    var pics: [MarsRoverPhoto] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var isInitialized: Bool {
        return (self.manifests.count == self.rovers.count)
    }
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
        for rover in self.rovers {
            apiClient.fetch(endpoint: NASAEndpoints.Mars(NASAEndpoints.QueryPhoto.Manifest(rover))) { (result: APIResult<MarsRoverPhotoManifest>) in
                switch result {
                case .Success(let manifest):
                    self.manifests.append(manifest)
                case .Failure(let error):
                    print("\(error)")
                }
            }
        }
    }
    
    func fetchPics(for rover: NASAEndpoints.Rover, sol: Int, camera: NASAEndpoints.Rover.Camera?, errorHandler: ((Error?) -> Void)?) {
        apiClient.fetch(endpoint: .Mars(.Sol(rover, sol: sol, camera: camera))) { (result: APIResult<MarsRoverResponseWithArray<MarsRoverPhoto>>) in
            switch result {
            case .Success(let response):
                self.pics = response.results
            case .Failure(let error):
                if let handler = errorHandler {
                    handler(error)
                }
            }
        }
    }
}

extension RoversDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pics.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarsRoverPhotoCell", for: indexPath) as! MarsRoverPhotoCell
        let photo = self.pics[indexPath.row]
        guard let url = photo.securedUrl else {
            return cell
        }
        Nuke.loadImage(with: url, into: cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarsRoverPhotoCell", for: indexPath) as! MarsRoverPhotoCell
        Nuke.cancelRequest(for: cell.imageView)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
