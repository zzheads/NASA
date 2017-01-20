//
//  APODViewController.swift
//  NASA
//
//  Created by Alexey Papin on 20.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

class APODViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleExplanationButton: UIButton!
    
    let apiClient = NASAAPIClient(config: .default)
    var explanation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.backgroundColor = .clear
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.setDate("2016-12-01".toDate!, animated: true)
        self.datePickerValueChanged()
    }
}

// MARK: - Handle Events
extension APODViewController {
    @IBAction func savePressed() {
    }
    @IBAction func toggleExplanation() {
        showAlert(title: "APOD Explanation", message: self.explanation, style: .actionSheet)
    }
    @IBAction func datePickerValueChanged() {
        let date = self.datePicker.date
        self.apiClient.fetch(endpoint: NASAEndpoints.APOD(date: date, hd: true)) { (result: APIResult<APOD>) in
            switch result {
            case .Success(let apod):
                DispatchQueue.main.async {
                    if (apod.media_type == "image") {
                        self.apodImageView.downloadedFrom(link: apod.secureUrl)
                        self.titleLabel.text = "\(apod.title) (\(apod.date_string))"
                        self.explanation = apod.explanation
                    } else {
                        self.showAlert(title: "Under construction", message: "You can see only images in current version of application, but APOD for selected date is not an image. We'll implement it in release version.", style: .alert)
                    }
                }
                
            case .Failure(let error):
                self.showAlert(title: "API Error", message: "\(error)", style: .alert)
            }
        }
    }
}

extension APODViewController {
    func showAlert(title: String, message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}
