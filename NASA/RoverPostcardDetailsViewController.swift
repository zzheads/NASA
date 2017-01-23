//
//  RoverPostcardDetailsViewController.swift
//  NASA
//
//  Created by Alexey Papin on 22.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class RoverPostcardDetailsViewController: UIViewController {
    var photo: MarsRoverPhoto?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let photo = self.photo,
            let url = photo.securedUrl
            else {
            return
        }
        self.titleLabel.text = photo.title
        Nuke.loadImage(with: url, into: self.imageView)
    }
}
