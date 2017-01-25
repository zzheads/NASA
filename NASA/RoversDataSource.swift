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
    let cellReuseIdentifier = "RoverPhotoCell"
    
    let apiClient = NASAAPIClient()
    var rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var validDates: [NASAEndpoints.Rover: [Int]] = [:]
    var pics: [MarsRoverPhoto] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
    }
    
    func fetchPics(for rover: NASAEndpoints.Rover, sol: Int, camera: NASAEndpoints.Rover.Camera?, completionHandler: (([MarsRoverPhoto]?, Error?) -> Void)?) {
        apiClient.fetch(endpoint: .Mars(.Sol(rover, sol: sol, camera: camera))) { (result: APIResult<MarsRoverResponseWithArray<MarsRoverPhoto>>) in
            switch result {
            case .Success(let response):
                self.pics = response.results
                if let handler = completionHandler {
                    handler(self.pics, nil)
                }
            case .Failure(let error):
                if let handler = completionHandler {
                    handler(nil, error)
                }
            }
        }
    }
}

extension RoversDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pics.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .gray
        
        let imageView = self.imageView(for: cell)
        let imageURL = self.pics[indexPath.row].securedUrl!
        imageView.image = nil
        Nuke.loadImage(with: imageURL, into: imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath)
        let imageView = self.imageView(for: cell)
        Nuke.cancelRequest(for: imageView)
    }
    
    func imageView(for cell: UICollectionViewCell) -> UIImageView {
        var imageView = cell.viewWithTag(15) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.bounds)
            imageView!.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            imageView!.tag = 15
            imageView!.contentMode = .scaleAspectFill
            imageView!.clipsToBounds = true
            cell.addSubview(imageView!)
        }
        return imageView!
    }
    
}
