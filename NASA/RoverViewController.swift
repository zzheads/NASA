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
    @IBOutlet weak var solPromptLabel: UILabel!
    
    let rovers: [NASAEndpoints.Rover] = [.Curiosity, .Opportunity, .Spirit]
    var currentRover: NASAEndpoints.Rover?
    var cameras: [NASAEndpoints.Rover.Camera] {
        guard let currentRover = self.currentRover else {
            return []
        }
        return currentRover.cameras
    }
    var currentCamera: NASAEndpoints.Rover.Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.currentRover = self.rovers.first
        self.currentCamera = self.cameras.last
        self.pickerView.reloadComponent(1)
    }
}

// MARK: - Handle Events
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
        label.font = AppFont.sanFranciscoMedium(size: 14.0).font
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
