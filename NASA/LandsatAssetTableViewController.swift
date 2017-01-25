//
//  LandsatImagesAssetTableViewController.swift
//  NASA
//
//  Created by Alexey Papin on 25.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LandsatAssetTableViewController: UITableViewController {
    private let cellReuseIdentifier = "LandsatAssetHeaderCell"
    var location: CLLocationCoordinate2D!
    var placemarkName: String?
    var addressName: String?
    var asset: LandsatImageAsset?
    let apiClient = NASAAPIClient()
    var headers: [LandsatImageHeader] {
        guard let asset = self.asset else {
            return []
        }
        return asset.results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        
        self.apiClient.fetch(endpoint: NASAEndpoints.Earth(NASAEndpoints.EarthEndpoint.Asset(self.location, nil, nil))) { (result: APIResult<LandsatImageAsset>) in
            switch result {
            case .Success(let asset):
                self.asset = asset
                var title = "Landsat8 Images (\(self.headers.count)) for "
                if let addressName = self.addressName {
                    title += "\(addressName):"
                } else {
                    if let placemarkName = self.placemarkName {
                        title += "\(placemarkName):"
                    } else {
                        title += "(\(self.location.latitude),\(self.location.longitude)):"
                    }
                }
                self.navigationItem.title = title
                self.tableView.reloadData()
                
            case .Failure(let error):
                self.showAlertAndDismiss(title: "Loading asset for \(self.location) error", message: "\(error)", style: .alert)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headers.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        let header = self.headers[indexPath.row]
        var title = header.dateWithoutTime
        if let date = header.dateWithoutTime.toDate {
            title = date.toShortLocalString
        }
        cell.textLabel?.text = title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageDetailsController = segue.destination as! LandsatImageViewController
        imageDetailsController.header = headers[(self.tableView.indexPathForSelectedRow?.row)!]
        imageDetailsController.location = self.location
    }
}
