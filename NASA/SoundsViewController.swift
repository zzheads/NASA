//
//  SoundsViewController.swift
//  NASA
//
//  Created by Alexey Papin on 25.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SoundsViewController: UIViewController {
    fileprivate let cellReuseIdentifier = "SoundCell"
    let apiClient = NASAAPIClient(delegate: nil, delegateQueue: nil)
    var sounds: [Sound] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.endEditing(_:)), for: .editingDidEndOnExit)
    }
}

extension SoundsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.sounds[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = self.sounds[indexPath.row]
        print("\(sound.url), \(sound.streamUrl)")
        let playerItem = AVPlayerItem(url: sound.streamUrl)
        let player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
    }
    
}

// MARK: - Handle Events
extension SoundsViewController {
    func endEditing(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        let endpoint = NASAEndpoints.Sounds(search: text, limit: nil)
        self.apiClient.fetch(endpoint: endpoint) { (result: APIResult<Response<Sound>>) in
            switch result {
            case .Success(let response):
                self.sounds = response.results
                self.tableView.reloadData()
            case .Failure(let error):
                print("\(error)")
            }
        }
    }
}
