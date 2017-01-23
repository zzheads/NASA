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
import Preheat


private var loggingEnabled = false

class RoverPhotosCollectionViewController: UICollectionViewController {
    var rover: NASAEndpoints.Rover?
    var camera: NASAEndpoints.Rover.Camera?
    var sol: Int?
    var preheater: Preheater!
    var preheatController: Preheat.Controller<UICollectionView>!
    var dataSource: RoversDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = RoversDataSource(collectionView: self.collectionView!)
        self.collectionView?.backgroundView = UIImageView(image: #imageLiteral(resourceName: "ipad_background_port_x2"))
        preheater = Preheater()
        preheatController = Preheat.Controller(view: collectionView!)
        preheatController.handler = { [weak self] addedIndexPaths, removedIndexPaths in
            self?.preheat(added: addedIndexPaths, removed: removedIndexPaths)
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.dataSource.cellReuseIdentifier)
        guard
            let rover = self.rover,
            let sol = self.sol
            else {
                self.showAlert(title: "Loading images error", message: "Insufficient information, you have to choose rover and sol. Can not load images.", style: .alert)
                return
        }
        self.dataSource.fetchPics(for: rover, sol: sol, camera: self.camera) { (pics, error) in
            guard let pics = pics else {
                if let error = error {
                    self.showAlert(title: "Loading images for \(rover) rover", message: "\(error)", style: .alert)
                } else {
                    self.showAlert(title: "Loading images for \(rover) rover", message: "Unknown error", style: .alert)
                }
                return
            }
            var title = "\(pics.count) pics of Rover: \(rover.rawValue), sol: \(sol)"
            if let camera = self.camera {
                title += ", camera: \(camera.rawValue):"
            } else {
                title += ":"
            }
            self.navigationItem.title = title
        }
    }
    
    func preheat(added: [IndexPath], removed: [IndexPath]) {
        func requests(for indexPaths: [IndexPath]) -> [Request] {
            return indexPaths.map { Request(url: self.dataSource.pics[$0.row].securedUrl!) }
        }
        preheater.startPreheating(with: requests(for: added))
        preheater.stopPreheating(with: requests(for: removed))
        if loggingEnabled {
            logAddedIndexPaths(added, removedIndexPaths: removed)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItemSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        preheatController.enabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        preheatController.enabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSize()
    }
    
    func updateItemSize() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        let itemsPerRow = 4
        let side = (Double(view.bounds.size.width) - Double(itemsPerRow - 1) * 2.0) / Double(itemsPerRow)
        layout.itemSize = CGSize(width: side, height: side)
    }    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsController = segue.destination as! RoverPostcardDetailsViewController
        let photo = sender as! MarsRoverPhoto
        detailsController.photo = photo
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.dataSource.pics[indexPath.row]
        performSegue(withIdentifier: "showRoverPhotoDetails", sender: photo)
    }
}

private func logAddedIndexPaths(_ addedIndexPath: [IndexPath], removedIndexPaths: [IndexPath]) {
    func stringForIndexPaths(_ indexPaths: [IndexPath]) -> String {
        guard indexPaths.count > 0 else {
            return "[]"
        }
        let items = indexPaths.map{ return "\(($0 as NSIndexPath).item)" }.joined(separator: " ")
        return "[\(items)]"
    }
    print("did change preheat rect with added indexes \(stringForIndexPaths(addedIndexPath)), removed indexes \(stringForIndexPaths(removedIndexPaths))")
}
