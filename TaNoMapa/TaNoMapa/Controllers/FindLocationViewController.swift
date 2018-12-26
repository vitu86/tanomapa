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
    
    // MARK: Private properties
    private var placeMark:CLPlacemark?
    
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
                        self.placeMark = markers![0]
                        self.addAnnotation()
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
        showCenterIndicator()
        
        var location:DataToServer = DataToServer()
        location.firstName = DataSingleton.sharedInstance.userData.firstName
        location.lastName = DataSingleton.sharedInstance.userData.lastName
        location.latitude = String(format:"%f", placeMark!.location!.coordinate.latitude)
        location.longitude = String(format:"%f", placeMark!.location!.coordinate.longitude)
        location.mapString = self.location
        location.mediaURL = self.link
        
        NetworkHelper.sharedInstance.postLocation(location) { (result) in
            self.hideCenterIndicator()
            switch result {
            case .Success:
                NotificationCenter.default.post(name: NSNotification.Name.shouldReloadLocations, object: nil)
                self.dismiss(animated: true, completion: nil)
            case .NoInternet:
                self.showAlert(title: "Attention", message: "You are offline")
                self.navigationController?.popViewController(animated: true)
            case .Fail:
                self.showAlert(title: "Attention", message: "Could not send location")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Private functions
    private func addAnnotation() {
        let annotation = MKPointAnnotation()
        if let location = placeMark!.location {
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            mapView.centerCoordinate = annotation.coordinate
        }
    }
    
    private func showAlertAndDismiss() {
        hideCenterIndicator()
        showAlert(title: "Attention", message: "Could not load address", okFunction: { (_) in
            self.navigationController?.popViewController(animated: true)
        }, cancelFunction: nil)
    }
}
