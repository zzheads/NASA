//
//  RoverPhotosCollectionViewController.swift
//  NASA
//
//  Created by Alexey Papin on 23.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import Nuke

private let cellReuseID = "MarsRoverPhotoCell"

class RoverPhotosCollectionViewController: UICollectionViewController {
    var dataSource: RoversDataSource!
    var photos: [URL]!
    var manager = Nuke.Manager.shared
    var itemsPerRow = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = RoversDataSource(collectionView: self.collectionView!)
        self.dataSource.fetchPics(for: NASAEndpoints.Rover.Curiosity, sol: 1000, camera: nil) { error in
        }
        //self.collectionView?.backgroundView
        self.collectionView?.register(MarsRoverPhotoCell.self, forCellWithReuseIdentifier: cellReuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItemSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSize()
    }
    
    func updateItemSize() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        let side = (Double(view.bounds.size.width) - Double(itemsPerRow - 1) * 2.0) / Double(self.itemsPerRow)
        layout.itemSize = CGSize(width: side, height: side)
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
        cell.backgroundColor = UIColor(white: 235.0 / 255.0, alpha: 1.0)
        
        let imageView = imageViewForCell(cell)
        imageView.image = nil
        
        let request = makeRequest(with: photos[indexPath.row])
        
        manager.loadImage(with: request, into: imageView)
        
        return cell
    }
    
    func makeRequest(with url: URL) -> Request {
        return Request(url: url)
    }
    
    func imageViewForCell(_ cell: UICollectionViewCell) -> UIImageView {
        var imageView: UIImageView! = cell.viewWithTag(15) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.bounds)
            imageView.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            imageView.tag = 15
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.addSubview(imageView!)
        }
        return imageView!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Makes sure that requests get cancelled as soon as the
        // cell goes offscreen
        manager.cancelRequest(for: self.imageViewForCell(cell))
    }
}
