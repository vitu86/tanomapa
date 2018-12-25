//
//  FindLocationViewController.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 25/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Public properties
    var location:String?
    var link:String?
    
    //MARK: Override functions
    override func viewDidLoad() {
        showCenterIndicator()
        let geocoder = CLGeocoder()
        if let location = location {
            geocoder.geocodeAddressString(location) { (markers, error) in
                if error == nil {
                    if markers!.count <= 0 {
                        self.showAlertAndDismiss()
                    } else {
                        for item in markers! {
                            self.addAnnotation(placeMark: item)
                        }
                        self.hideCenterIndicator()
                    }
                } else {
                    self.showAlertAndDismiss()
                }
            }
        } else {
            showAlertAndDismiss()
        }
    }
    
    // MARK: IBActions
    @IBAction func finishButtonTapped(_ sender: Any) {
    }
    
    // MARK: Private functions
    private func addAnnotation(placeMark:CLPlacemark) {
        let annotation = MKPointAnnotation()
        if let location = placeMark.location {
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    private func showAlertAndDismiss() {
        hideCenterIndicator()
        showAlert(title: "Attention", message: "Could not load address", okFunction: { (_) in
            self.navigationController?.popViewController(animated: true)
        }, cancelFunction: nil)
    }
}
